import 'dart:convert';
import 'package:chatapp/global_variable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ImageService {
  Future<Map<String, dynamic>> uploadImageToCloudinary(
      Map<String, dynamic> signedData, String filePath) async {
    final req = http.MultipartRequest("POST", Uri.parse(signedData['uploadUrl']))
      ..fields['api_key'] = signedData['apiKey'].toString()
      ..fields['timestamp'] = signedData['timestamp'].toString()
      ..fields['signature'] = signedData['signature'].toString()
      ..fields['folder'] = signedData['folder']
      ..files.add(await http.MultipartFile.fromPath("file", filePath));

    final res = await req.send();
    final body = await res.stream.bytesToString();

    if (res.statusCode != 200) {
      throw Exception("Image upload failed");
    }

    return jsonDecode(body);
  }

  Future<Map<String, dynamic>> sendImageMessage({
    required String senderId,
    required String receiverId,
    required String filePath,
    required String message,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    // 1. Get signature
    final signRes = await http.post(
      Uri.parse("$uri/api/cloudinary/sign"),
      headers: {"Content-Type": "application/json", "x-auth-token": token!},
      body: jsonEncode({"type": "image"}),
    );

    final signed = jsonDecode(signRes.body);

    // 2. Upload to Cloudinary
    final upload = await uploadImageToCloudinary(signed, filePath);
    final imageUrl = upload["secure_url"];

    // 3. Send message to backend
    final response = await http.post(
      Uri.parse("$uri/api/send-image-message"),
      headers: {"Content-Type": "application/json", "x-auth-token": token},
      body: jsonEncode({
        "senderId": senderId,
        "receiverId": receiverId,
        "message": message,
        "imageUrl": imageUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to send image message");
    }

    return {"url": imageUrl};
  }
}
