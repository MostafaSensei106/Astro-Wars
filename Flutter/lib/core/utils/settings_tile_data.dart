import 'package:flutter/material.dart';

final class SettingsTileData {
  const SettingsTileData({
    required this.title,
    required this.leading,
    this.trailing,
    this.subtitle,
    this.onTap,
  });
  final String title;
  final IconData leading;
  final Widget? trailing;
  final String? subtitle;
  final VoidCallback? onTap;
}
