import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:orbit_chat_app/controller/auth_controller.dart';
import 'package:orbit_chat_app/global_variable.dart';
import 'package:orbit_chat_app/models/group.dart';
import 'package:orbit_chat_app/utils/manage_http_request.dart';

class GroupApiService {

  Future<List<Group>> getAllGroups ({required String token,required WidgetRef ref,required BuildContext context})async{
    try{
      http.Response response = await AuthController().sendRequest(request: (token)async{
        return await http.get(
            Uri.parse('$uri/api/get-all-groups'),
            headers: <String,String>{
              'Content-Type':'application/json; charset=UTF-8',
              'x-auth-token':token
            }
        );
      }, ref: ref,context: context);


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
  Future<void> addFriendsToGroup({required List<String> members,required String groupId,required String token,required WidgetRef ref,required BuildContext context})async{
    try{
      http.Response response= await AuthController().sendRequest(request: (token)async{
        return await http.post(
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
      }, ref: ref,context: context);
      if(response.statusCode == 200){
        showSnackBar(context, "Selected members are successfully added to the group");
      }else{
        throw Exception("We got the error:${response.body}");
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
  Future<void> removeFriendsFromTheGroup({required List<String> members,required WidgetRef ref,required String groupId,required String token,required BuildContext context})async{
    try{
      http.Response response= await AuthController().sendRequest(request: (token)async{
        return await http.delete(
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
      },ref: ref,context: context);
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