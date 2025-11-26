import 'dart:convert';
import 'package:chatapp/global_variable.dart';
import 'package:chatapp/models/group.dart';
import 'package:chatapp/models/group_message.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/utils/manage_http_request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class GroupController{

  Future<void> createNewGroup({
    required String groupName,
    required List<User> members,
    required BuildContext context
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');

      final memberIds = members.map((m) => m.id).toList();

      final body = jsonEncode({
        "groupName": groupName,
        "groupMembers": memberIds
      });

      final res = await http.post(
        Uri.parse("$uri/api/create-group"),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": token!,
        },
        body: body,
      );

      if (res.statusCode == 200) {
        showSnackBar(context, "Group Created");
        Navigator.pop(context);
      } else {
        showSnackBar(context, jsonDecode(res.body)["msg"]);
      }

    } catch (e) {
      throw Exception("Error creating group: $e");
    }
  }
  Future<List<Group>> fetchGroups()async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      http.Response response = await http.get(
          Uri.parse('$uri/api/get-all-groups'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token!
        }
      );

      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        print(data);
        final List<Group> groups = data.map((group)=>Group.fromMap(group)).toList();
        print(groups);
        return groups;
      }
      else{
        throw Exception("We got the error:${response.body}");
      }

    }catch(e){
      throw Exception("We got the error:${e.toString()}");
    }
  }

  Future<GroupMessage> sendMessage({required String message,required String groupId})async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      if(token == null){
        throw Exception('No token found');
      }
      http.Response response = await http.post(
          Uri.parse('$uri/api/send-message-to-group/$groupId'),
          body: jsonEncode({
            'message':message,
          }),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
            'x-auth-token':token
          });
      if(response.statusCode == 200){
        final data = jsonDecode(response.body)['newMessage'];
        final GroupMessage message = GroupMessage.fromMap(data);
        print('Message sent successfully :${message.toJson()}');
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


}