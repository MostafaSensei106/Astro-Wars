import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class CheckboxComponent extends StatelessWidget {
  const CheckboxComponent({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });
  final String title;
  final bool value;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unawaited(HapticFeedback.vibrate());
        onChanged(!value);
      },
      child: Row(
        children: [
          Checkbox(value: value, onChanged: onChanged),
          Text(title),
        ],
      ),
    );
  }
}
