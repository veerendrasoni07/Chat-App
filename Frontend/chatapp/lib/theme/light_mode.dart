import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: const Color(0xFFFFFFFF), // background
    primary: const Color(0xFF6C63FF), // violet accent
    secondary: const Color(0xFF00D084), // green
    tertiary: const Color(0xFFFFD43B), // yellow
    inversePrimary: Colors.white, // used for contrast
  ),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  fontFamily: 'Poppins',
);
