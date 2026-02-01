import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:orbit_chat_app/global_variable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ImageService {

  Future<XFile?> compressImage({required File image,required int quality})async{
    try{
      final dir = await getTemporaryDirectory();
      final dirPath = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
          image.path,
          dirPath,
          quality: quality
      );
      return compressedImage!;
    }catch(e){
      throw Exception(e.toString());
    }
  }


  Future<Map<String, dynamic>> uploadImageToCloudinary(
      Map<String, dynamic> signedData, XFile filePath) async {
    final req = http.MultipartRequest("POST", Uri.parse(signedData['uploadUrl']))
      ..fields['api_key'] = signedData['apiKey'].toString()
      ..fields['timestamp'] = signedData['timestamp'].toString()
      ..fields['signature'] = signedData['signature'].toString()
      ..fields['folder'] = signedData['folder']
      ..files.add(await http.MultipartFile.fromPath("file", filePath.path));

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
    required File filePath,
    required String message,
    required String localId
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    
    // compress image 
    final image = await compressImage(image: filePath, quality: 80);
    final thumbnail = await compressImage(image: filePath, quality: 40);


    
    // 1. Get signature
    final imageSign = await sign('image', token!);
    final thumbnailSign = await sign('thumbnail', token);

    // upload to the cloudinary
    final uploadImage = await uploadImageToCloudinary(imageSign, image!);
    final thumbnailUpload = await uploadImageToCloudinary(thumbnailSign, thumbnail!);


    final imageUrl = uploadImage["secure_url"];
    final thumbnailUrl = thumbnailUpload['secure_url'];

    // 3. Send message to backend
    final response = await http.post(
      Uri.parse("$uri/api/send-image-message"),
      headers: {"Content-Type": "application/json", "x-auth-token": token},
      body: jsonEncode({
        "senderId": senderId,
        "receiverId": receiverId,
        "message": message,
        "localId":localId,
        "media": {
          "url":imageUrl,
          "thumbnail":thumbnailUrl,
          "type":"image",
          "size":uploadImage['bytes'],
          "height":uploadImage['height'],
          "width":uploadImage['width']
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to send image message");
    }

    return {"url": imageUrl};
  }
}

Future<Map<String, dynamic>> sign(String type,String token) async {
  final res = await http.post(
    Uri.parse("$uri/api/cloudinary/sign"),
    headers: {
      "Content-Type": "application/json",
      "x-auth-token": token
    },
    body: jsonEncode({"type": type}),
  );
  return jsonDecode(res.body);
}



