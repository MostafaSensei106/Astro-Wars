import 'dart:ui';

import 'package:flutter/material.dart';

final class SliverAppBarComponent extends StatelessWidget {
  const SliverAppBarComponent({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.pinned = false,
    this.floating = false,
    this.snap = false,
    this.expandedHeight,
    this.flexibleSpace,
    this.bottom,
    this.centerTitle = true,
  });
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;

  @override
  Widget build(final BuildContext context) => SliverAppBar(
    title: title,
    leading: leading,
    actions: actions,
    pinned: pinned,
    floating: floating,
    snap: snap,
    expandedHeight: expandedHeight,
    flexibleSpace: Stack(
      children: [
        ?flexibleSpace,
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    ),
    bottom: bottom,
    backgroundColor: Theme.of(
      context,
    ).colorScheme.surface.withValues(alpha: 0.7),
    centerTitle: centerTitle,
    elevation: 0,
    scrolledUnderElevation: 0,
    actionsPadding: const EdgeInsets.symmetric(horizontal: 4),
  );
}
