import 'package:flutter/material.dart';


class AppTheme {
  
  static const Color primaryColor = Color(0xFF4ECB71); 
  static const Color accentColor = Color(0xFF1976D2); 
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color splashCircleColor = Color(0x334ECB71); 

  
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: textColor,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: Colors.white70,
  );

  
  static ThemeData get themeData => ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: accentColor,
          background: backgroundColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: const TextTheme(
          titleLarge: headline,
          bodyMedium: body,
          bodySmall: caption,
        ),
        useMaterial3: true,
      );
}
