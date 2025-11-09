import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: const  Color(0xFF0A1E52),
    primary: const Color(0xFFFFFFFF), // violet accent
    secondary: const Color(0xFF969696), // green
    tertiary: const Color(0xFF646464), // yellow
    inversePrimary: Colors.black, // used for contrast
  ),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  fontFamily: 'Poppins',
);
