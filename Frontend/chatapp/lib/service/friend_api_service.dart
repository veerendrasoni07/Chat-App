
import 'dart:convert';
import 'package:chatapp/utils/manage_http_request.dart';

import '';
import 'package:chatapp/models/user.dart';
import 'package:http/http.dart' as http;

import '../global_variable.dart';


class FriendApiService {
  Future<List<User>> getAllFriends({required String token})async{
    try{
      http.Response response = await sendRequest(request: (token)async{
         return await http.get(Uri.parse('$uri/api/user-connections'),
            headers: <String,String>{
              'Content-Type':'application/json; charset=UTF-8',
              'x-auth-token':token
            }
        );
      });
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
  Future<void> removeFriend({required String token,required String friendId})async{
    try{
      http.Response response = await sendRequest(request: (token)async{
         return await http.delete(
            Uri.parse('$uri/api/remove-friend/$friendId'),
            headers: <String,String>{
              'Content-Type':'application/json; charset=UTF-8',
              'x-auth-token':token
            }
        );
      });
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
}