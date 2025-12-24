import 'dart:convert';

import 'package:chatapp/global_variable.dart';
import 'package:chatapp/models/group.dart';
import 'package:chatapp/utils/manage_http_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class GroupApiService {

  Future<List<Group>> getAllGroups ({required String token})async{
    try{
      http.Response response = await http.get(
          Uri.parse('$uri/api/get-all-groups'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token
        }
      );

      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        print(data);
        final List<Group> groups = data.map((group)=>Group.fromMap(group)).toList();
        return groups;
      }
      else{
        throw Exception("We got the error:${response.body}");
      }

    }catch(e){
      throw Exception("We got the error:${e.toString()}");
    }
  }
  Future<void> addFriendsToGroup({required List<String> members,required String groupId,required String token,required BuildContext context})async{
    try{
      http.Response response= await http.post(
          Uri.parse('$uri/api/add-members'),
          body: jsonEncode({
            "members":members,
            "groupId":groupId
          }),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
            'x-auth-token':token
          }
      );
      if(response.statusCode == 200){
        showSnackBar(context, "Selected members are successfully added to the group");
      }else{
        throw Exception("We got the error:${response.body}");
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
  Future<void> removeFriendsFromTheGroup({required List<String> members,required String groupId,required String token,required BuildContext context})async{
    try{
      http.Response response= await http.delete(
          Uri.parse('$uri/api/remove-members-from-group'),
          body: jsonEncode({
            "members":members,
            "groupId":groupId
          }),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
            'x-auth-token':token
          }
      );
      if(response.statusCode == 200){
        showSnackBar(context, "Selected members are successfully removed from the group");
      }else{
        throw Exception("We got the error:${response.body}");
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
  
  
}