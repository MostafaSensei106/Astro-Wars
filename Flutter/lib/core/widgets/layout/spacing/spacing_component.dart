import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpacingComponent extends StatelessWidget {
  const SpacingComponent.horizontal(final double size, {super.key})
    : width = size,
      height = 0;

  const SpacingComponent.vertical(final double size, {super.key})
    : width = 0,
      height = size;
  final double? width;
  final double? height;

  @override
  Widget build(final BuildContext context) =>
      SizedBox(width: width?.w, height: height?.h);
}
