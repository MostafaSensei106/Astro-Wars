import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'list_tile_component.dart';

final class ListTileWidgetComponent extends StatelessWidget {
  const ListTileWidgetComponent({
    required this.leading,

    required this.title,
    this.useinBorderRadius = false,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.single;

  const ListTileWidgetComponent.top({
    required this.title,
    required this.leading,
    this.useinBorderRadius = false,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.top;

  const ListTileWidgetComponent.middle({
    required this.title,
    required this.leading,
    this.useinBorderRadius = false,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.middle;

  const ListTileWidgetComponent.bottom({
    required this.title,
    required this.leading,
    this.useinBorderRadius = false,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.bottom;

  final String title;
  final Widget leading;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool? selected;
  final bool useinBorderRadius;
  final ListTileGroupType groupType;
  @override
  Widget build(BuildContext context) {
    switch (groupType) {
      case ListTileGroupType.top:
        return ListTileComponent.top(
          title: title,
          leading: leading,
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
          leading: leading,
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
          leading: leading,
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
          leading: leading,
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
