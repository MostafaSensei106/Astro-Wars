import 'package:flutter/material.dart';
import '../../../constants/app_config.dart';

class SliverPaddingComponent extends StatelessWidget {
  const SliverPaddingComponent({required this.sliver, super.key, this.padding});
  final EdgeInsetsGeometry? padding;
  final Widget sliver;

  @override
  Widget build(final BuildContext context) => SliverPadding(
    padding: padding ?? const EdgeInsets.all(AppConfig.padding),
    sliver: sliver,
  );
}
