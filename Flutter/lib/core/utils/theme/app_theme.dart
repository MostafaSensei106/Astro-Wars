import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_config.dart';

final class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,

    fontFamily: 'Rubik',

    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff654fa1),
      surfaceTint: Color(0xff654fa1),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe9ddff),
      onPrimaryContainer: Color(0xff4c3d75),
      secondary: Color(0xff625b71),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe8def8),
      onSecondaryContainer: Color(0xff4a4458),
      tertiary: Color(0xff7e5260),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd9e3),
      onTertiaryContainer: Color(0xff633b49),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff1d1b20),
      onSurfaceVariant: Color(0xff49454e),
      outline: Color(0xff7a757f),
      outlineVariant: Color(0xffcac4cf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xffcfbdfe),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff201047),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff4c3d75),
      secondaryFixed: Color(0xffe8def8),
      onSecondaryFixed: Color(0xff1e192b),
      secondaryFixedDim: Color(0xffcbc2dc),
      onSecondaryFixedVariant: Color(0xff4a4458),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff31101d),
      tertiaryFixedDim: Color(0xffefb8c8),
      onTertiaryFixedVariant: Color(0xff633b49),
      surfaceDim: Color(0xffded8e0),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2fa),
      surfaceContainer: Color(0xfff2ecf4),
      surfaceContainerHigh: Color(0xffece6ee),
      surfaceContainerHighest: Color(0xffe6e1e9),
    ),

    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppConfig.outBorderRadius),
        ),
      ),
    ),

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,

    fontFamily: 'Rubik',

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcfbdfe),
      surfaceTint: Color(0xffcfbdfe),
      onPrimary: Color(0xff35275d),
      primaryContainer: Color(0xff4c3d75),
      onPrimaryContainer: Color(0xffe9ddff),
      secondary: Color(0xffcbc2dc),
      onSecondary: Color(0xff332d41),
      secondaryContainer: Color(0xff4a4458),
      onSecondaryContainer: Color(0xffe8def8),
      tertiary: Color(0xffefb8c8),
      onTertiary: Color(0xff4a2532),
      tertiaryContainer: Color(0xff633b49),
      onTertiaryContainer: Color(0xffffd9e3),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff141218),
      onSurface: Color(0xffe6e1e9),
      onSurfaceVariant: Color(0xffcac4cf),
      outline: Color(0xff948f99),
      outlineVariant: Color(0xff49454e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e1e9),
      inversePrimary: Color(0xff654fa1),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff201047),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff4c3d75),
      secondaryFixed: Color(0xffe8def8),
      onSecondaryFixed: Color(0xff1e192b),
      secondaryFixedDim: Color(0xffcbc2dc),
      onSecondaryFixedVariant: Color(0xff4a4458),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff31101d),
      tertiaryFixedDim: Color(0xffefb8c8),
      onTertiaryFixedVariant: Color(0xff633b49),
      surfaceDim: Color(0xff141218),
      surfaceBright: Color(0xff3b383e),
      surfaceContainerLowest: Color(0xff0f0d13),
      surfaceContainerLow: Color(0xff1d1b20),
      surfaceContainer: Color(0xff211f24),
      surfaceContainerHigh: Color(0xff2b292f),
      surfaceContainerHighest: Color(0xff36343a),
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppConfig.outBorderRadius),
        ),
      ),
    ),

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData lightTheme(String fontFamily) =>
      light.copyWith(textTheme: light.textTheme.apply(fontFamily: fontFamily));

  static ThemeData darkTheme(String fontFamily) =>
      dark.copyWith(textTheme: dark.textTheme.apply(fontFamily: fontFamily));
}
