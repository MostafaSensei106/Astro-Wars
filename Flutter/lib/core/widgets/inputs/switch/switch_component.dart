// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';

final class SwitchComponent extends StatelessWidget {
  const SwitchComponent({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });
  final String label;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(final BuildContext context) => Switch(
    // title: Text(label),
    value: value,
    onChanged: onChanged,
    activeTrackColor: Theme.of(context).colorScheme.primary,
  );
}
