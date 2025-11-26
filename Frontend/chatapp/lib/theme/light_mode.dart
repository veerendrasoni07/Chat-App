import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: const  Color(0xFFFFFFFF),
    primary: const Color(0xFFFFFFFF), // violet accent
    secondary: const Color(0xFFC4C4C4), // green
    tertiary: const Color(0xFF8F8F8F), // yellow
    inversePrimary: Colors.black, // used for contrast
  ),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  fontFamily: 'Poppins',
);
