import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/app_config.dart';
import '../../neu_widgets.dart';

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
  Widget build(final BuildContext context) => NeuButton(
        onPressed: () {
          unawaited(HapticFeedback.vibrate());
          onPressed();
        },
        width: width,
        height: height ?? AppConfig.buttonHeight,
        borderRadius: useInBorderRadius ? AppConfig.inBorderRadius : AppConfig.outBorderRadius,
        child: icon == null
            ? Text(label, style: TextStyle(color: foregroundColor ?? NeuTheme.textColor(context)))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: AppConfig.iconSize, color: foregroundColor ?? NeuTheme.textColor(context)),
                  const SizedBox(width: 8),
                  Text(label, style: TextStyle(color: foregroundColor ?? NeuTheme.textColor(context))),
                ],
              ),
      );
}
