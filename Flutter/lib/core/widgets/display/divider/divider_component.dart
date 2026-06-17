import 'package:flutter/material.dart';

final class DividerComponent extends StatelessWidget {
  const DividerComponent({super.key, this.indent, this.endIndent});
  final double? indent;
  final double? endIndent;

  @override
  Widget build(final BuildContext context) => Divider(
    indent: indent,
    endIndent: endIndent,
    color: Theme.of(context).colorScheme.outlineVariant,
  );
}
