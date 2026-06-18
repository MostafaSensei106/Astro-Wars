import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/app_config.dart';
import '../../neu_widgets.dart';

enum IconButtonVariant { standard, filled, tonal, outlined }

final class IconButtonComponent extends StatelessWidget {
  const IconButtonComponent({
    required this.icon,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.toolTip,
    this.backgroundColor,
    this.foregroundColor,
    this.iconSize,
    this.padding,
  }) : variant = IconButtonVariant.standard;

  const IconButtonComponent.filled({
    required this.icon,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.toolTip,
    this.backgroundColor,
    this.foregroundColor,
    this.iconSize,
    this.padding,
  }) : variant = IconButtonVariant.filled;

  const IconButtonComponent.tonal({
    required this.icon,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.toolTip,
    this.backgroundColor,
    this.foregroundColor,
    this.iconSize,
    this.padding,
  }) : variant = IconButtonVariant.tonal;

  const IconButtonComponent.outlined({
    required this.icon,
    required this.onPressed,
    super.key,
    this.useInBorderRadius = false,
    this.toolTip,
    this.backgroundColor,
    this.foregroundColor,
    this.iconSize,
    this.padding,
  }) : variant = IconButtonVariant.outlined;
  final IconData icon;
  final VoidCallback onPressed;
  final IconButtonVariant variant;
  final bool useInBorderRadius;

  final String? toolTip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? iconSize;
  final double? padding;

  @override
  Widget build(final BuildContext context) {
    return NeuIconButton(
      icon: icon,
      size: iconSize ?? AppConfig.iconSize,
      onPressed: () {
        unawaited(HapticFeedback.vibrate());
        onPressed();
      },
    );
  }
}
