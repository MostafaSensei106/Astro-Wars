import 'package:flutter/material.dart';

class SliverPersistentHeaderComponent extends StatelessWidget {
  const SliverPersistentHeaderComponent({
    required this.child,
    required this.minExtent,
    required this.maxExtent,
    super.key,
    this.pinned = false,
    this.floating = false,
  });
  final Widget child;
  final double minExtent;
  final double maxExtent;
  final bool pinned;
  final bool floating;

  @override
  Widget build(final BuildContext context) => SliverPersistentHeader(
    pinned: pinned,
    floating: floating,
    delegate: _SliverPersistentHeaderDelegate(
      minExtent: minExtent,
      maxExtent: maxExtent,
      child: child,
    ),
  );
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate({
    required this.child,
    required this.minExtent,
    required this.maxExtent,
  });
  final Widget child;
  @override
  final double minExtent;
  @override
  final double maxExtent;

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) => SizedBox.expand(child: child);

  @override
  bool shouldRebuild(final _SliverPersistentHeaderDelegate oldDelegate) =>
      child != oldDelegate.child ||
      minExtent != oldDelegate.minExtent ||
      maxExtent != oldDelegate.maxExtent;
}
