import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightNeumorphicTheme {
    const Color lightBgColor = Color(0xFFE0E5EC);
    const Color lightTextColor = Colors.black87;
    const Color accentColor = Colors.purpleAccent;

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBgColor,
      primaryColor: accentColor,
      colorScheme: const ColorScheme.light(
        primary: accentColor,
        secondary: Colors.blueAccent,
        surface: lightBgColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: lightTextColor),
        titleTextStyle: TextStyle(
          color: lightTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 2,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: lightTextColor,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: lightTextColor,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: lightTextColor),
        bodyMedium: TextStyle(color: lightTextColor),
      ),
    );
  }

  static ThemeData get darkNeumorphicTheme {
    const Color darkBgColor = Color(0xFF2A2D32);
    const Color darkTextColor = Colors.white;
    const Color accentColor = Colors.purpleAccent;

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBgColor,
      primaryColor: accentColor,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: Colors.blueAccent,
        surface: darkBgColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkTextColor),
        titleTextStyle: TextStyle(
          color: darkTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 2,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: darkTextColor,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: darkTextColor,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: darkTextColor),
        bodyMedium: TextStyle(color: darkTextColor),
      ),
    );
  }
}
