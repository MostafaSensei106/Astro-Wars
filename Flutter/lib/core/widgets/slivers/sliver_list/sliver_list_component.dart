import 'package:flutter/material.dart';

class SliverListComponent extends StatelessWidget {
  const SliverListComponent({
    super.key,
    this.children,
    this.itemBuilder,
    this.itemCount,
  }) : assert(children != null || (itemBuilder != null && itemCount != null));
  final List<Widget>? children;
  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;

  @override
  Widget build(final BuildContext context) {
    if (children != null) {
      return SliverList(delegate: SliverChildListDelegate(children!));
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          itemBuilder!,
          childCount: itemCount,
        ),
      );
    }
  }
}
