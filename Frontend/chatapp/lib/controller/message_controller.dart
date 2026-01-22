import 'dart:convert';
import 'dart:io';

import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/next_cursor.dart';
import 'package:chatapp/provider/messageProvider.dart';
import 'package:chatapp/provider/next_cursor_provider.dart';
import 'package:chatapp/utils/manage_http_request.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/models/user.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variable.dart';

class MessageService{






  Future<Message> sendVoiceMessage({required File audio,required String senderId,required String receiverId,required double duration,required context,required WidgetRef ref})async{
    try{
      final cloudinary = CloudinaryPublic("dktwuay7l", "Social Media");
      final res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(audio.path, resourceType: CloudinaryResourceType.Video)
      );
      final secure_url = res.secureUrl;
      http.Response response = await http.post(
          Uri.parse('$uri/api/voice-message'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'senderId':senderId,
          'receiverId':receiverId,
          'message':secure_url,
          'duration':duration,
        })
      );

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final msg = Message.fromMap(data);
        return msg;
      }
      else{
        throw Exception('Failed to send voice message');
      }

    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<List<User>> getUsers({required String userId})async{
    try{
      http.Response response = await http.get(
          Uri.parse('$uri/api/get-all-users/$userId'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
      });
      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        final List<User> users = data.map((e) => User.fromMap(e)).toList();
        return users;
      }else{
        throw Exception('Failed to fetch users');
      }
    }catch(e){
      print(e.toString());
      throw Exception(e);
    }
  }





  Future<List<Message>> syncMessages({required String receiverId,required String senderId,required WidgetRef ref,required DateTime? cursor,required BuildContext context})async{
    try{
      http.Response response = await AuthController().sendRequest(request: (token){
        return http.get(
            Uri.parse('$uri/api/v1/get-messages?chatId=$receiverId&senderId=$senderId&cursor=$cursor'),
            headers: <String,String>{
              'Content-Type':'application/json; charset=UTF-8',
              'x-auth-token':token
            }
        );
      }, ref: ref, context: context);
      if(response.statusCode == 200){
        final Map<String,dynamic> data = jsonDecode(response.body);
        print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDAAAAAAAAAAAAAAAAAAAAAAAAAAATTTTTTTTTTTTTTTTTTTTTTTTTTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        print(data.toString());
        final cursor = data['nextCursor'];
        final List<dynamic> msg = data['messages'];
        final List<Message> messages = msg.map((e) => Message.fromMap(e)).toList();
        try{
          NextCursor nextCursor =  NextCursor(cursor, data['isMore']);
          ref.read(nextCursorProvider.notifier).addCursor(nextCursor);
        }catch(e){
          print(e.toString());
        }
        return messages;
      }
      else{
        print(response.body);
        throw Exception('Failed to sync messages');
      }

    }catch(e){
      throw Exception('Failed to sync messages');
    }
  }

}