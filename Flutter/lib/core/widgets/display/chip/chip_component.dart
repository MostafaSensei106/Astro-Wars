import 'package:flutter/material.dart';

final class ChipComponent extends StatelessWidget {
  const ChipComponent({required this.label, super.key, this.onDeleted});
  final String label;
  final VoidCallback? onDeleted;

  @override
  Widget build(final BuildContext context) => Chip(
    label: Text(label),
    onDeleted: onDeleted,
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    labelStyle: TextStyle(
      color: Theme.of(context).colorScheme.onSecondaryContainer,
    ),
  );
}
