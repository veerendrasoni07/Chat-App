import 'dart:convert';

import 'package:chatapp/global_variable.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/tokenProvider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/utils/manage_http_request.dart';
import 'package:chatapp/views/entry%20point/authentication/login_screen.dart';
import 'package:chatapp/views/entry%20point/onBoarding/onboarding_page.dart';
import 'package:chatapp/views/screens/main_screen.dart';
import 'package:chatapp/views/screens/nav_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AuthController{

  Future<void> signUp({required String fullname,required String username,required String email, required String password,required String gender,required BuildContext context,required WidgetRef ref})async{
    try{
      http.Response response = await http.post(
          Uri.parse('$uri/api/sign-up'),
        body: jsonEncode({
          'fullname':fullname,
          'email':email,
          'password':password,
          'gender':gender,
          'username':username
        }),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );

      if(response.statusCode == 200){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        final data = jsonDecode(response.body);
        final token = data['token'];
        print(data);
        print(token);
        print(data['user']);
        final userJson = jsonEncode(data['user']);
        preferences.setString('user', userJson);
        preferences.setString('token', token);
        ref.read(userProvider.notifier).addUser(userJson);
        ref.read(tokenProvider.notifier).setToken(token);
        showSnackBar(context, 'Account created successfully');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false, // remove all previous routes
        );
      }
      else{
        throw Exception('Failed to create account');
      }

    }catch(e){
      print(e);
    }
  }

  Future<void> login({required String email, required String password,required BuildContext context,required WidgetRef ref})async{
    try{
      http.Response response = await http.post(
          Uri.parse('$uri/api/sign-in'),
          body: jsonEncode({
            'email':email,
            'password':password,
          }),
          headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
          }
      );

      if(response.statusCode == 200){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];
        final userJson = jsonEncode(user);
        preferences.setString('user', userJson);
        preferences.setString('token', token);
        ref.read(userProvider.notifier).addUser(userJson);
        ref.read(tokenProvider.notifier).setToken(token);
        showSnackBar(context, 'Logged in successfully');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false, // remove all previous routes
        );
      }
      else{
        throw Exception('Failed to create account');
      }

    }catch(e){
      print(e);
    }
  }


  Future<void> logout(BuildContext context,WidgetRef ref)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('user');
    await preferences.remove('token');
    ref.read(userProvider.notifier).signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>OnboardingPage()) , (route) => false);
    showSnackBar(context, 'Logged out successfully');
  }

  Future<bool> usernameCheck(String username)async {
    try {
      http.Response response = await http.get(
          Uri.parse('$uri/api/username-check/$username'),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8'
        }
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body)['msg'];
        return data;
      }else{
        throw Exception('Failed to check username');
      }
    }
    catch(e){
      throw Exception(e);
    }
  }



  // Future<List<User>> getAllUsers({required String userId})async{
  //   try{
  //     http.Response response = await http.get(
  //         Uri.parse('$uri/api/get-all-friends/$userId'),
  //       headers: <String,String>{
  //           'Content-Type':'application/json; charset=UTF-8'
  //       }
  //     );
  //
  //     if(response.statusCode == 200){
  //       final List<dynamic> data = jsonDecode(response.body);
  //       final List<User> users = data.map((user)=>User.fromMap(user)).toList();
  //       return users;
  //     }
  //     else{
  //       throw Exception("New Error Occurred");
  //     }
  //
  //   }catch(w){
  //     print(w);
  //     throw Exception(w.toString());
  //   }
  // }



}