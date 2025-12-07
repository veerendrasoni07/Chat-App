import 'dart:convert';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatapp/global_variable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VoiceService {
  final AudioRecorder _recorder = AudioRecorder();

  // Get temporary directory for storing your voices
  Future<String> _createTempFilePath() async {
    final dir = await getTemporaryDirectory();
    final voiceDir = Directory(p.join(dir.path, 'voice'));

    if (!voiceDir.existsSync()) {
      voiceDir.createSync(recursive: true);
    }

    final fileName = "${DateTime.now().millisecondsSinceEpoch}.m4a";
    return p.join(voiceDir.path, fileName);
  }

  String? _currentFilePath;

  Future<String> startRecording( ) async {
    if (!await _recorder.hasPermission()) {
      throw Exception("No microphone permission");
    }

    _currentFilePath = await _createTempFilePath();

    // START actual audio recording first
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,
        bitRate: 128000,
      ),
      path: _currentFilePath!,
    );


    return _currentFilePath!;
  }


  /// Stop recording and return file path
  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    return path;
  }

  /// Cancel recording → stop + delete file
  Future<void> cancelRecording(RecorderController waveform) async {
    try {
      await waveform.stop();
    } catch (_) {}

    final path = await _recorder.stop();

    // delete actual file path if provided
    if (path != null && File(path).existsSync()) {
      File(path).deleteSync();
    }
  }


  Future<double> getDurationFromFile(String filePath) async {
    final player = AudioPlayer();
    await player.setFilePath(filePath);
    final duration = player.duration?.inMilliseconds ?? 0;
    await player.dispose();
    return duration / 1000;
  }

  // Get cloudinary signature in order to upload voice directly to Cloudinary
  Future<Map<String, dynamic>> getCloudinarySignature(String type) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');

      http.Response response = await http.post(
        Uri.parse('$uri/api/cloudinary/sign'),
        body: jsonEncode({
          'type':type
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception("Failed to get signature: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Cloudinary signature error: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> uploadVoiceToCloudinary({
    required Map<String, dynamic> signedData,
    required String filePath,
  }) async {
    try {
      final uri = Uri.parse(signedData['uploadUrl']);
      final request = http.MultipartRequest('POST', uri);

      request.fields['api_key'] = signedData['apiKey'].toString();
      request.fields['signature'] = signedData['signature'].toString();
      request.fields['folder'] = signedData['folder'].toString();
      request.fields['timestamp'] = signedData['timestamp'].toString();

      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      final streamed = await request.send();
      final respstr = await streamed.stream.bytesToString();
      final status = streamed.statusCode;

      if (status == 200) {
        return jsonDecode(respstr);
      } else {
        throw Exception("Upload failed with status: $status");
      }
    } catch (e) {
      throw Exception("Cloudinary upload error: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> sendVoiceMessage({
    required String senderId,
    required String receiverId,
    required String filePath,
  }) async {
    final duration = await getDurationFromFile(filePath);

    final signed = await getCloudinarySignature('voice');
    final upload = await uploadVoiceToCloudinary(
      signedData: signed,
      filePath: filePath,
    );

    final voiceUrl = upload["secure_url"];
    final cloudDuration = upload["duration"] ?? duration;
    final publicId = upload['public_id'];

    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final response = await http.post(
      Uri.parse("$uri/api/send-voice-message"),
      headers: {"Content-Type": "application/json", "x-auth-token": token!},
      body: jsonEncode({
        "senderId": senderId,
        "receiverId": receiverId,
        "publicId":publicId,
        "uploadUrl": voiceUrl,
        "uploadDuration": cloudDuration,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to send voice message: ${response.statusCode}");
    }

    return {"url": voiceUrl, "duration": cloudDuration};
  }




}
