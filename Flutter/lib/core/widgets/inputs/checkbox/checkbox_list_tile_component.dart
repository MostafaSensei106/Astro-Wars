// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/app_config.dart';

final class CheckboxListTileComponent extends StatelessWidget {
  const CheckboxListTileComponent({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.useInBorderRadius = false,
  });
  final String title;
  final bool value;
  final bool useInBorderRadius;
  final void Function(bool?) onChanged;

  @override
  Widget build(final BuildContext context) => CheckboxListTile(
    contentPadding: EdgeInsets.zero,
    controlAffinity: ListTileControlAffinity.leading,
    title: Text(title),
    value: value,
    onChanged: (final value) {
      unawaited(HapticFeedback.vibrate());
      onChanged(value);
    },
    shape: RoundedRectangleBorder(
      borderRadius: useInBorderRadius
          ? BorderRadiusGeometry.circular(AppConfig.inBorderRadius)
          : BorderRadius.circular(AppConfig.outBorderRadius),
    ),
  );
}
