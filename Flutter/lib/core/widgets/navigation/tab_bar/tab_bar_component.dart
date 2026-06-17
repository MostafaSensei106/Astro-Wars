import 'package:flutter/material.dart';

class TabBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const TabBarComponent({
    required this.tabs,
    super.key,
    this.controller,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
  });
  final List<Tab> tabs;
  final TabController? controller;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;

  @override
  Size get preferredSize => const Size.fromHeight(0.0);

  @override
  Widget build(final BuildContext context) => TabBar(
    controller: controller,
    tabs: tabs,
    labelColor: labelColor ?? Theme.of(context).colorScheme.primary,
    unselectedLabelColor:
        unselectedLabelColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
    indicatorColor: indicatorColor ?? Theme.of(context).colorScheme.primary,
  );
}
