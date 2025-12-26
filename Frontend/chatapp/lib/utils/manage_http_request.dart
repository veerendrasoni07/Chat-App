import 'dart:convert';

import 'package:chatapp/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variable.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(text), duration: const Duration(seconds: 5)));
}

void manageHttpResponse(
  http.Response response,
  BuildContext context,
  VoidCallback onSuccess,
) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, 'Bad Request: ${response.body}');
      break;
    case 401:
      showSnackBar(context, 'Unauthorized: ${response.body}');
      break;
    case 403:
      showSnackBar(context, 'Forbidden: ${response.body}');
      break;
    case 404:
      showSnackBar(context, 'Not Found: ${response.body}');
      break;
    case 500:
      showSnackBar(context, 'Internal Server Error: ${response.body}');
      break;
    default:
      showSnackBar(context, 'Error ${response.statusCode}: ${response.body}');
  }
}

Future<http.Response> sendRequest({
  required Future<http.Response> Function (String token) request
})async{
  try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('token');

    http.Response requestResponse = await request(accessToken!);
    if(requestResponse.statusCode == 401){
      bool refreshed = await AuthController().refreshToken();
      if (!refreshed) {
        throw Exception('Session expired');
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




