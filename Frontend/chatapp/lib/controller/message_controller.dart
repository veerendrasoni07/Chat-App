import 'dart:convert';

import 'package:chatapp/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variable.dart';

class MessageController{

  Future<Message> sendMessage({required String message,required String receiverId})async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      if(token == null){
        throw Exception('No token found');
      }
      http.Response response = await http.post(
          Uri.parse('$uri/api/send-message/$receiverId'),
          body: jsonEncode({
            'message':message,
          }),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
            'x-auth-token':token
          });
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final Message message = Message.fromMap(data);
        print('Message sent successfully :${message}');
        return message;

      }else{
        print(response.body);
        throw Exception('Failed to send message:${response.statusCode}');
      }
    }
    catch(e){
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Message>> getMessages({required String receiverId})async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      print(token);
      if(token == null){
        throw Exception('No token found');
      }
      http.Response response = await http.get(
          Uri.parse('$uri/api/get-messages/$receiverId'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token
        }
      );

      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        final List<Message> messages = data.map((e) => Message.fromMap(e)).toList();
        return messages;
      }else{
        throw Exception('Failed to fetch messages : ${response.statusCode}');
      }

    }catch(e){
      print(e.toString());
      throw Exception(e);
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


}