import 'package:flutter/material.dart';
import 'astro_design.dart';

/// Neon Space Opera themes. Dark is the default space experience;
/// light is a clean daytime hangar look. Both driven by [accent].
class AppTheme {
  static ThemeData neonDark({Color accent = const Color(0xFF7C4DFF)}) {
    final scheme = ColorScheme.dark(
      primary: accent,
      secondary: AstroDesign.neonCyan,
      tertiary: AstroDesign.neonMagenta,
      surface: AstroDesign.surface,
      error: AstroDesign.danger,
    );
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: AstroDesign.bodyFont,
      scaffoldBackgroundColor: AstroDesign.bg,
      colorScheme: scheme,
      primaryColor: accent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AstroDesign.displayFont,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 3,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontFamily: AstroDesign.displayFont, fontWeight: FontWeight.w900),
        displayMedium: TextStyle(
            fontFamily: AstroDesign.displayFont, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(
            fontFamily: AstroDesign.displayFont, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            fontFamily: AstroDesign.displayFont, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontWeight: FontWeight.bold),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AstroDesign.surface.withValues(alpha: 0.9),
        indicatorColor: accent.withValues(alpha: 0.25),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(accent),
        trackColor: WidgetStatePropertyAll(accent.withValues(alpha: 0.4)),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData neonLight({Color accent = const Color(0xFF7C4DFF)}) {
    final scheme = ColorScheme.light(
      primary: accent,
      secondary: const Color(0xFF0090B3),
      tertiary: const Color(0xFFC81E9E),
      surface: const Color(0xFFF2F4FA),
    );
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: AstroDesign.bodyFont,
      scaffoldBackgroundColor: const Color(0xFFE8ECF5),
      colorScheme: scheme,
      primaryColor: accent,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          fontFamily: AstroDesign.displayFont,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 3,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontFamily: AstroDesign.displayFont, fontWeight: FontWeight.w900),
        displayMedium: TextStyle(
            fontFamily: AstroDesign.displayFont, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(
            fontFamily: AstroDesign.displayFont, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            fontFamily: AstroDesign.displayFont, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontWeight: FontWeight.bold),
      ),
      useMaterial3: true,
    );
  }

  // Backwards-compat getters (old screens still migrating).
  static ThemeData get lightNeumorphicTheme => neonLight();
  static ThemeData get darkNeumorphicTheme => neonDark();
}
