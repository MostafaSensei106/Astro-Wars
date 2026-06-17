import 'package:flutter/material.dart';

class SliverFillRemainingComponent extends StatelessWidget {
  const SliverFillRemainingComponent({
    required this.child,
    super.key,
    this.hasScrollBody = true,
    this.fillOverscroll = false,
  });
  final Widget child;
  final bool hasScrollBody;
  final bool fillOverscroll;

  @override
  Widget build(final BuildContext context) => SliverFillRemaining(
    hasScrollBody: hasScrollBody,
    fillOverscroll: fillOverscroll,
    child: child,
  );
}
