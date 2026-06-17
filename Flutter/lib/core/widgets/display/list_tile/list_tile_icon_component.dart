import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/app_config.dart';
import 'list_tile_component.dart';

final class ListTileIconComponent extends StatelessWidget {
  const ListTileIconComponent({
    required this.leading,
    required this.title,
    this.useinBorderRadius = false,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
    super.key,
  }) : groupType = ListTileGroupType.single;

  const ListTileIconComponent.top({
    required this.leading,
    required this.title,
    this.useinBorderRadius = false,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
    super.key,
  }) : groupType = ListTileGroupType.top;

  const ListTileIconComponent.middle({
    required this.leading,
    required this.title,
    this.useinBorderRadius = false,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
    super.key,
  }) : groupType = ListTileGroupType.middle;

  const ListTileIconComponent.bottom({
    required this.leading,
    required this.title,
    this.useinBorderRadius = false,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
    super.key,
  }) : groupType = ListTileGroupType.bottom;

  final String title;
  final IconData leading;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool? selected;
  final bool useinBorderRadius;
  final ListTileGroupType groupType;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Container(
      padding: const EdgeInsets.all(AppConfig.paddingHalf),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        leading,
        size: AppConfig.iconSize,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );

    switch (groupType) {
      case ListTileGroupType.top:
        return ListTileComponent.top(
          title: title,
          leading: iconWidget,
          subtitle: subtitle,
          trailing: trailing,
          selected: selected,
          useinBorderRadius: useinBorderRadius,
          onTap: () {
            unawaited(HapticFeedback.vibrate());
            onTap?.call();
          },
        );
      case ListTileGroupType.middle:
        return ListTileComponent.middle(
          title: title,
          leading: iconWidget,
          subtitle: subtitle,
          trailing: trailing,
          selected: selected,
          useinBorderRadius: useinBorderRadius,
          onTap: () {
            unawaited(HapticFeedback.vibrate());
            onTap?.call();
          },
        );
      case ListTileGroupType.bottom:
        return ListTileComponent.bottom(
          title: title,
          leading: iconWidget,
          subtitle: subtitle,
          trailing: trailing,
          selected: selected,
          useinBorderRadius: useinBorderRadius,
          onTap: () {
            unawaited(HapticFeedback.vibrate());
            onTap?.call();
          },
        );
      case ListTileGroupType.single:
        return ListTileComponent(
          title: title,
          leading: iconWidget,
          subtitle: subtitle,
          trailing: trailing,
          selected: selected,
          useinBorderRadius: useinBorderRadius,
          onTap: () {
            unawaited(HapticFeedback.vibrate());
            onTap?.call();
          },
        );
    }
  }
}
