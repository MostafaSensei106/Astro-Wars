import 'package:flutter/material.dart';

class SliverGridComponent extends StatelessWidget {
  const SliverGridComponent({
    required this.gridDelegate,
    required this.itemBuilder,
    required this.itemCount,
    super.key,
  });
  final SliverGridDelegate gridDelegate;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  @override
  Widget build(final BuildContext context) => SliverGrid(
    gridDelegate: gridDelegate,
    delegate: SliverChildBuilderDelegate(itemBuilder, childCount: itemCount),
  );
}
