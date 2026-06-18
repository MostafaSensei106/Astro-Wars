import 'package:flutter/material.dart';
import '../../widgets/neu_widgets.dart';

class AppTheme {
  static ThemeData get darkNeumorphicTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NeuTheme.bgColor,
      primaryColor: NeuTheme.accentColor,
      colorScheme: const ColorScheme.dark(
        primary: NeuTheme.accentColor,
        secondary: Colors.blueAccent,
        surface: NeuTheme.bgColor,
        background: NeuTheme.bgColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: NeuTheme.textColor),
        titleTextStyle: TextStyle(
          color: NeuTheme.textColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 2,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: NeuTheme.textColor,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: NeuTheme.textColor,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: NeuTheme.textColor),
        bodyMedium: TextStyle(color: NeuTheme.textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NeuTheme.bgColor,
          foregroundColor: NeuTheme.textColor,
          shadowColor:
              Colors.transparent, // Disable default shadow for neumorphism
          elevation: 0,
        ),
      ),
      cardTheme: const CardTheme(
        color: NeuTheme.bgColor,
        elevation: 0,
        margin: EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NeuTheme.bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: NeuTheme.darkShadow, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: NeuTheme.darkShadow, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: NeuTheme.accentColor, width: 2),
        ),
      ),
    );
  }
}
