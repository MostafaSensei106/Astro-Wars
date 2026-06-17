import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../constants/app_config.dart';
import '../../../extensions/extensions.dart';

class BottomNavBarComponent extends StatelessWidget {
  const BottomNavBarComponent({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    super.key,
  });
  final int currentIndex;
  final List<BottomNavigationBarItem> items;
  final void Function(int) onTap;

  @override
  Widget build(final BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
      border: Border.all(
        color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          backgroundColor: context.colorScheme.surface.withValues(alpha: 0.8),
          destinations: items
              .map(
                (final item) => NavigationDestination(
                  icon: item.icon,
                  selectedIcon: item.activeIcon,
                  label: item.label!,
                ),
              )
              .toList(),
        ),
      ),
    ),
  );
}
