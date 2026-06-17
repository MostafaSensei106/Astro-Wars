import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

final class ShimmerComponent extends StatelessWidget {
  const ShimmerComponent({required this.child, super.key, this.enabled = true});
  final Widget child;
  final bool enabled;

  @override
  Widget build(final BuildContext context) =>
      Skeletonizer(enabled: enabled, child: child);
}
