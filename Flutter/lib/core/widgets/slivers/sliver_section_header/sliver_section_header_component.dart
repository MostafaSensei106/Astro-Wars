import 'package:flutter/material.dart';
import '../../display/section_header/section_header_component.dart';

class SliverSectionHeaderComponent extends StatelessWidget {
  const SliverSectionHeaderComponent({
    required this.title,
    super.key,
    this.onActionPressed,
    this.actionLabel,
  });
  final String title;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  @override
  Widget build(final BuildContext context) => SliverToBoxAdapter(
    child: SectionHeaderComponent(
      title: title,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
    ),
  );
}
