import 'package:flutter/material.dart';

class AppConstants {
  static const String apiBaseUrl = 'https://acorn-unsafe-spinster.ngrok-free.dev/api';
  // For local testing: static const String apiBaseUrl = 'http://localhost:8080/api';

  static const String tokenKey = 'token';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
}

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: const Color(0xFF006B3F),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF006B3F),
      secondary: Color(0xFFFCD116),
      tertiary: Color(0xFFEF3340),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF006B3F),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF006B3F), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF006B3F),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    scaffoldBackgroundColor: Colors.grey.shade50,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF006B3F),
    scaffoldBackgroundColor: Colors.grey.shade900,
  );
}