import 'package:flutter/material.dart';

final class SectionHeaderComponent extends StatelessWidget {
  const SectionHeaderComponent({
    required this.title,
    super.key,
    this.onActionPressed,
    this.actionLabel,
  });
  final String title;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  @override
  Widget build(final BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      if (onActionPressed != null)
        TextButton(
          onPressed: onActionPressed,
          child: Text(actionLabel ?? 'View All'),
        ),
    ],
  );
}
