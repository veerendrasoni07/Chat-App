import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/views/authentication/login_screen.dart';
import 'package:chatapp/views/screens/nav_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/authentication/register_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> checkUserAndToken()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final String? user = prefs.getString('user');
      if(token != null && user != null){
        ref.read(userProvider.notifier).addUser(user);
      }
      else{
        ref.read(userProvider.notifier).signOut();
      }
    }
    return MaterialApp(
      home: FutureBuilder(
          future: checkUserAndToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final user = ref.read(userProvider);
              return user != null ? HomeScreen() : LoginScreen();
            }
          }
      ),
      routes: {
        '/home':(context)=>HomeScreen(),
        '/register':(context)=>RegisterScreen(),
        '/login':(context)=>LoginScreen(),
      },
    );
  }
}
