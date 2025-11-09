
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color(0xFF171717),
    primary: const Color(0xFF454546), // violet accent
    secondary: const Color(0xFF777777), // green
    tertiary: const Color(0xFF9B9B9B),
    inversePrimary: const Color(0xFFF8F8F8),
  ),
  scaffoldBackgroundColor: const Color(0xFF0D0D0D),
  fontFamily: 'Poppins',
);
