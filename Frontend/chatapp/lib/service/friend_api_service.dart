
import 'dart:convert';
import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/models/interaction.dart';
import 'package:chatapp/provider/friends_provider.dart';
import 'package:chatapp/provider/request_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/utils/manage_http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '';
import 'package:chatapp/models/user.dart';
import 'package:http/http.dart' as http;

import '../global_variable.dart';


class FriendApiService {
  Future<List<User>> getAllFriends({required String token,required WidgetRef ref,required BuildContext context})async{
    try{
      http.Response response = await AuthController().sendRequest(request: (token)async{
         return await http.get(Uri.parse('$uri/api/user-connections'),
            headers: <String,String>{
              'Content-Type':'application/json; charset=UTF-8',
              'x-auth-token':token
            }
        );
      }, ref: ref,context: context);
      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        final List<User> users = data.map((user)=> User.fromMap(user)).toList();
        print("fasdfasdfjasdjfhaskjdf");
        print(response.body);
        return users;
      }
      else{
        throw Exception('Failed to fetch friends');
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
  Future<void> removeFriend({required String token,required String friendId,required WidgetRef ref,required BuildContext context})async{
    try{
      http.Response response = await AuthController().sendRequest(request: (token)async{
         return await http.delete(
            Uri.parse('$uri/api/remove-friend/$friendId'),
            headers: <String,String>{
              'Content-Type':'application/json; charset=UTF-8',
              'x-auth-token':token
            }
        );
      }, ref: ref,context: context);
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final User users = User.fromMap(data);
        print("fasdfasdfjasdjfhaskjdf");
        print(response.body);
      }
      else{
        throw Exception('Failed to remove friends');
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }


  Future<void> getAllRequests({required WidgetRef ref,required BuildContext context})async{
    try{
      http.Response response = await AuthController().sendRequest(request:(token)async{
        return  await http.get(
          Uri.parse('$uri/api/get-all-requests'),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
            'x-auth-token':token
          },
        );
      },ref: ref,context: context);

      if(response.statusCode == 200){
        print(response.body);
        final List<dynamic> data = jsonDecode(response.body);
        final List<Interaction> requests = data.map((r)=> Interaction.fromMap(r)).toList();
        print("data:");
        print(requests);
        ref.read(requestProvider(ref.read(userProvider)!.id).notifier).getAllRequest(requests);
      }

    }catch(w){
      throw Exception(w.toString());
    }
  }


  Future<List<User>> searchUser({required String username})async{
    try{
      http.Response response = await http.get(
          Uri.parse('$uri/api/search-user/${username}'),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
          }
      );
      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        final List<User> users = data.map((user)=> User.fromMap(user)).toList();
        return users;
      }
      else{
        throw Exception('Failed to search user');
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }


  Future<List<Interaction>> getAllSentRequests({required WidgetRef ref,required BuildContext context})async{
    try{

      http.Response response = await AuthController().sendRequest(request:(token)async{
        return await http.get(
          Uri.parse('$uri/api/get-all-sent-requests'),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
            'x-auth-token':token
          },
        );
      },ref: ref,context: context);

      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        final List<Interaction> requests = data.map((r)=> Interaction.fromMap(r)).toList();
        print("Data : kasgasdfasdfs");
        print(data);
        return requests;
      }
      else{
        print(response.body);
        throw Exception('Failed to fetch sent requests');
      }

    }catch(w){
      throw Exception(w.toString());
    }
  }
  Future<List<Interaction>> getAllRecentActivities({required WidgetRef ref,required BuildContext context})async{
    try{
      http.Response response = await AuthController().sendRequest(request:(token)async{
        return await http.get(
          Uri.parse('$uri/api/recent-notification-activities'),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
            'x-auth-token':token
          },
        );
      },ref: ref,context: context);

      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        final List<Interaction> requests = data.map((r)=> Interaction.fromMap(r)).toList();
        print("Data : kasgasdfasdfs");
        print(data);
        return requests;
      }
      else{
        print(response.body);
        throw Exception('Failed to fetch sent requests');
      }

    }catch(w){
      throw Exception(w.toString());
    }
  }

  Future<User> getUserById({required String userId})async{
    try{
      http.Response response = await http.get(
          Uri.parse('$uri/api/get-user-by-id/$userId'),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
          }
      );
      if(response.statusCode == 200){
        final dynamic data = jsonDecode(response.body);
        final User user = User.fromMap(data);
        return user;
      }
      else{
        throw Exception('Failed to fetch user');
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }



}