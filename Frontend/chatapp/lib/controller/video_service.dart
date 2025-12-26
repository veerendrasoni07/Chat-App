import 'dart:convert';
import 'dart:io';

import 'package:chatapp/global_variable.dart';
import 'package:chatapp/utils/manage_http_request.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
class VideoService {



  Future<Map<String,dynamic>> getSign({required String type,required String token})async{
    try{

      http.Response response =
      await sendRequest(request: (token)async{
        return await http.post(
          Uri.parse('$uri/api/cloudinary/sign'),
          body: jsonEncode({
            'type':type
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception("Failed to get signature: ${response.statusCode}");
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }


  Future<Map<String,dynamic>> uploadVideoToTheCloudinary({
    required Map<String,dynamic> signedData,
    required String filePath
})async{
    try{
      final uri = Uri.parse(signedData['uploadUrl']);
      final request = http.MultipartRequest('POST', uri)
      ..fields['api_key'] = signedData['apiKey'].toString()
      ..fields['signature'] = signedData['signature'].toString()
      ..fields['folder'] = signedData['folder'].toString()
      ..fields['timestamp'] = signedData['timestamp'].toString()
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

      final streamed = await request.send();
      final respStr =  await streamed.stream.bytesToString();
      final status = streamed.statusCode;
      if(status == 200){
        return jsonDecode(respStr);
      }
      else{
        throw Exception("Upload failed with status: $status");
      }

    }catch(e){
      throw Exception(e.toString());
    }
  }
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
  Future<void> sendVideo({
    required File videoFile,
    required String senderId,
    required String receiverId,
    required String thumbnailFile,
    required String message,
    required String localId
})async{
    try{

      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');

      final videoSign = await getSign(type: 'video',token: token!);
      final thumbnailSign = await getSign(type: 'image',token: token);
      final videoUpload = await uploadVideoToTheCloudinary(signedData: videoSign, filePath: videoFile.path);
      final thumbnailUpload = await uploadImageToCloudinary(thumbnailSign,thumbnailFile);

      final url = videoUpload['secure_url'];
      final thumbnail = thumbnailUpload['secure_url'];
      http.Response response =
      await sendRequest(request: (token)async{
        return await http.post(
            Uri.parse('$uri/api/send-video'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            },
            body: jsonEncode({
              'senderId':senderId,
              'receiverId':receiverId,
              'media':{
                'url':url,
                'thumbnail':thumbnail,
                'size':videoUpload['bytes'],
                'width':videoUpload['width'],
                'height':videoUpload['height'],
                'duration':videoUpload['duration']
              },
              'localId':localId
            })
        );
      });
      if(response.statusCode == 200){
        return;
      }else{
        throw Exception('Failed to send video');
      }

    }catch(e){
      throw Exception(e.toString());
    }
  }



}