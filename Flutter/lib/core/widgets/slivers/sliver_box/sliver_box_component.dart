import 'package:flutter/material.dart';

class SliverBoxComponent extends StatelessWidget {
  const SliverBoxComponent({required this.child, super.key});
  final Widget child;

  @override
  Widget build(final BuildContext context) => SliverToBoxAdapter(child: child);
}
