import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class ThemeService {
  ColorScheme get(BuildContext context) => Theme.of(context).colorScheme;
  TextTheme getTextTheme(BuildContext context) => Theme.of(context).textTheme;
}
