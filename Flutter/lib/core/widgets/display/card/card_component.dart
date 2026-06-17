import 'package:flutter/material.dart';
import '../../../constants/app_config.dart';

final class CardComponent extends StatelessWidget {
  const CardComponent({
    required this.child,
    super.key,
    this.padding,
    this.color,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(final BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(AppConfig.padding),
    decoration: BoxDecoration(
      color: color ?? Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
    ),
    child: child,
  );
}
