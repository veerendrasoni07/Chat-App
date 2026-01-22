import 'dart:convert';
import 'package:chatapp/global_variable.dart';
import 'package:chatapp/provider/auth_manager_provider.dart';
import 'package:chatapp/provider/tokenProvider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/utils/manage_http_request.dart';
import 'package:chatapp/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
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
        final refreshToken = data['refreshToken'];
        final token = data['accessToken']; // access token
        final userJson = jsonEncode(data['user']);
        preferences.setString('user', userJson);
        preferences.setString('token', token);
        preferences.setString('refreshToken', refreshToken);
        ref.read(userProvider.notifier).addUser(userJson);
        ref.read(tokenProvider.notifier).setToken(token);
        if(context.mounted){
          showSnackBar(context, 'Account created successfully');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false, // remove all previous routes
          );
        }
      }
      else{
        print(response.body);
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
        final token = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final user = data['user'];
        final userJson = jsonEncode(user);
        preferences.setString('user', userJson);
        preferences.setString('token', token);
        preferences.setString('refreshToken', refreshToken);
        ref.read(userProvider.notifier).addUser(userJson);
        ref.read(tokenProvider.notifier).setToken(token);
        if(context.mounted){
          showSnackBar(context, 'Logged in successfully');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false, // remove all previous routes
          );
        }
      }
      else{
        throw Exception('Failed to create account');
      }

    }catch(e){
      print(e);
    }
  }


  Future<bool> refreshToken({required WidgetRef ref}) async {


    print("REFRESH TOKEN NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN");
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse('$uri/api/refresh-token'),
      body: jsonEncode({
        'refreshToken': refreshToken,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('token', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);
      print(data);
      return true;
    }
    else{
      return false;
    }
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
  
  Future<void> updateUserProfile({required String fullname,required String bio,required String phone,required String location,required String gender ,required WidgetRef ref,required BuildContext context})async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('token');
      http.Response response = await http.put(
          Uri.parse('$uri/api/update-profile'),
        body: jsonEncode({
          "details": {
            'fullname':fullname,
            'bio':bio,
            'phone':phone,
            'location':location,
            'gender':gender
          }
        }),
        headers: <String,String>{
            'Content-Type':'application/json; charset=UTF-8',
            'x-auth-token':token!
        }
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final user = data['user'];
        await preferences.remove('user');
        final userJson = jsonEncode(user);
        await preferences.setString('user', userJson);
        ref.read(userProvider.notifier).addUser(userJson);
        if(context.mounted){
          showSnackBar(context, 'Profile updated successfully');
        }
      }else{
        throw Exception('Failed to update profile');
      }
    }catch(e){
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<http.Response> sendRequest({
    required Future<http.Response> Function ( String token) request,
    required WidgetRef ref,
    required BuildContext context
  })async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('token');

      http.Response requestResponse = await request(accessToken!);
      if(requestResponse.statusCode == 401){
        print("ACCESS TOKEN EXPIRED");
        bool refreshed = await refreshToken(ref: ref);
        if (!refreshed) {
          ref.read(authManagerProvider.notifier).logout(context: context);
        }
        accessToken = prefs.getString('token');
        requestResponse = await request(accessToken!);
      }
      return requestResponse;
    }catch(e){
      print(e);
      throw Exception(e);
    }
  }


}