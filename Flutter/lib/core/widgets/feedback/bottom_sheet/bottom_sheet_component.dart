import 'package:flutter/material.dart';
import '../../../constants/app_config.dart';

final class BottomSheetComponent extends StatelessWidget {
  const BottomSheetComponent({required this.child, super.key, this.title});
  final Widget child;
  final String? title;

  @override
  Widget build(final BuildContext context) => Container(
    padding: const EdgeInsets.all(AppConfig.padding),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppConfig.outBorderRadius),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(),
        ],
        child,
      ],
    ),
  );
}
