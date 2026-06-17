import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/app_config.dart';

final class ElevatedButtonComponent extends StatelessWidget {
  const ElevatedButtonComponent({
    required this.label,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
  }) : icon = null;

  const ElevatedButtonComponent.icon({
    required this.icon,

    required this.label,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
  });
  final String label;
  final VoidCallback onPressed;
  final bool useInBorderRadius;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(final BuildContext context) => icon == null
      ? ElevatedButton(
          onPressed: () {
            unawaited(HapticFeedback.vibrate());
            onPressed();
          },
          style: _getButtonStyle(context),
          child: Text(label),
        )
      : ElevatedButton.icon(
          onPressed: () {
            unawaited(HapticFeedback.vibrate());
            onPressed();
          },
          style: _getButtonStyle(context),
          icon: Icon(icon, size: AppConfig.iconSize),
          label: Text(label),
        );

  ButtonStyle _getButtonStyle(final BuildContext context) =>
      ElevatedButton.styleFrom(
        minimumSize: Size(
          width ?? double.infinity,
          height ?? AppConfig.buttonHeight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: useInBorderRadius
              ? BorderRadius.circular(AppConfig.inBorderRadius)
              : BorderRadius.circular(AppConfig.outBorderRadius),
        ),
      );
}
