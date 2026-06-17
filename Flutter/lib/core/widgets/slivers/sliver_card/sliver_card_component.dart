import 'package:flutter/material.dart';
import '../../display/card/card_component.dart';

class SliverCardComponent extends StatelessWidget {
  const SliverCardComponent({
    required this.child,
    super.key,
    this.padding,
    this.color,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(final BuildContext context) => SliverToBoxAdapter(
    child: CardComponent(padding: padding, color: color, child: child),
  );
}
