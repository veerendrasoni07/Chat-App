import 'dart:convert';
import 'package:chatapp/global_variable.dart';
import 'package:chatapp/models/interaction.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/friends_provider.dart';
import 'package:chatapp/provider/request_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class FriendController{



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


  Future<void> getAllFriends({required WidgetRef ref})async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString('token');
      http.Response response = await http.get(Uri.parse('$uri/api/user-connections'),
        headers: <String,String>{
          'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token!
        }
      );
      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        final List<User> users = data.map((user)=> User.fromMap(user)).toList();
        print("fasdfasdfjasdjfhaskjdf");
        print(response.body);
        ref.read(friendsProvider.notifier).setAllFriends(users);
      }
      else{
        throw Exception('Failed to fetch friends');
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }

  // TODO: update this api function.
  Future<void> getAllRequests(WidgetRef ref)async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      http.Response response = await http.get(
          Uri.parse('$uri/api/get-all-requests'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token!
        },
      );

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


  // TODO: Update this api function.
  Future<List<Interaction>> getAllSentRequests()async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      http.Response response = await http.get(
          Uri.parse('$uri/api/get-all-sent-requests'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token!
        },
      );

      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        final List<Interaction> requests = data.map((r)=> Interaction.fromMap(r)).toList();
        print("Data : kasgasdfasdfs");
        print(data);
        return requests;
      }
      else{
        throw Exception('Failed to fetch sent requests');
      }

    }catch(w){
      throw Exception(w.toString());
    }
  }
  Future<List<Interaction>> getAllRecentActivities()async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');
      http.Response response = await http.get(
          Uri.parse('$uri/api/recent-notification-activities'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
          'x-auth-token':token!
        },
      );

      if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        final List<Interaction> requests = data.map((r)=> Interaction.fromMap(r)).toList();
        print("Data : kasgasdfasdfs");
        print(data);
        return requests;
      }
      else{
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