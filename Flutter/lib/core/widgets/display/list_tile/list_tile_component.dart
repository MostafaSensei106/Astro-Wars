import 'package:flutter/material.dart';
import '../../../constants/app_config.dart';

enum ListTileGroupType { top, middle, bottom, single }

final class ListTileComponent extends StatelessWidget {
  const ListTileComponent({
    required this.title,
    this.useinBorderRadius = false,
    this.leading,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.single;

  const ListTileComponent.top({
    required this.title,
    this.useinBorderRadius = false,
    this.leading,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.top;

  const ListTileComponent.middle({
    required this.title,
    this.useinBorderRadius = false,
    this.leading,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.middle;

  const ListTileComponent.bottom({
    required this.title,
    this.useinBorderRadius = false,
    this.leading,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected,
  }) : groupType = ListTileGroupType.bottom;

  final String title;
  final Widget? leading;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool? selected;
  final bool useinBorderRadius;
  final ListTileGroupType groupType;

  @override
  Widget build(final BuildContext context) {
    final borderRadius = useinBorderRadius
        ? BorderRadius.circular(AppConfig.inBorderRadius)
        : BorderRadius.circular(AppConfig.outBorderRadius);

    BorderRadius effectiveRadius;

    switch (groupType) {
      case ListTileGroupType.top:
        effectiveRadius = BorderRadius.only(
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
        );
      case ListTileGroupType.middle:
        effectiveRadius = BorderRadius.zero;
      case ListTileGroupType.bottom:
        effectiveRadius = BorderRadius.only(
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        );
      case ListTileGroupType.single:
        effectiveRadius = borderRadius;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: effectiveRadius,
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            title: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            leading: leading,
            subtitle: subtitle != null ? Text(subtitle!) : null,
            trailing: trailing,
            onTap: onTap,
            horizontalTitleGap: 10,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConfig.paddingHalf,
            ),
          ),
        ),
        if (groupType == ListTileGroupType.top ||
            groupType == ListTileGroupType.middle)
          const Divider(height: 1),
      ],
    );
  }
}
