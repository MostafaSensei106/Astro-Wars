import 'package:flutter/material.dart';

abstract class BaseThemeRepository {
  Future<void> cacheThemeMode(ThemeMode themeMode);
  Future<ThemeMode> getThemeMode();
}
