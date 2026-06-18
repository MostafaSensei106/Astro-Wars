import 'package:flutter/material.dart';
import '../../../constants/app_config.dart';
import '../../neu_widgets.dart';

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
  Widget build(final BuildContext context) => NeuContainer(
    padding: padding ?? const EdgeInsets.all(AppConfig.padding),
    borderRadius: AppConfig.outBorderRadius,
    child: child,
  );
}
