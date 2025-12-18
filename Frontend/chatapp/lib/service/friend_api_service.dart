
import 'dart:convert';

import 'package:chatapp/models/user.dart';
import 'package:http/http.dart' as http;

import '../global_variable.dart';


class FriendApiService {
  Future<List<User>> getAllFriends({required String token})async{
    try{
      http.Response response = await http.get(Uri.parse('$uri/api/user-connections'),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
            'x-auth-token':"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4ZDNlYzEwYjQ4Mjc4MTNiY2UzNzc4MyIsImlhdCI6MTc2NTYzNzIwMH0.T9Ud2fzEKzhYB6jHDjjLaC2G6FAbZ_LIIukl-JLr-Zc"
          }
      );
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
}