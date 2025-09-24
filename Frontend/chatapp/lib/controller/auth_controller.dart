import 'dart:convert';

import 'package:chatapp/global_variable.dart';
import 'package:chatapp/provider/tokenProvider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/utils/manage_http_request.dart';
import 'package:chatapp/views/screens/nav_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AuthController{

  Future<void> signUp({required String fullname,required String email, required String password,required String gender,required BuildContext context,required WidgetRef ref})async{
    try{
      http.Response response = await http.post(
          Uri.parse('$uri/api/sign-up'),
        body: jsonEncode({
          'fullname':fullname,
          'email':email,
          'password':password,
          'gender':gender
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
          MaterialPageRoute(builder: (context) => HomeScreen()),
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
          MaterialPageRoute(builder: (context) => HomeScreen()),
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
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    showSnackBar(context, 'Logged out successfully');
  }


}