import 'package:flutter/material.dart';

final class AssetImageComponent extends StatelessWidget {
  const AssetImageComponent({
    required this.assetName,
    super.key,
    this.width,
    this.height,
    this.fit,
  });
  final String assetName;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(final BuildContext context) =>
      Image.asset(assetName, width: width, height: height, fit: fit);
}
