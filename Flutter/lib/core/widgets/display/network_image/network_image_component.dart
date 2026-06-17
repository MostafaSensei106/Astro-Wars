import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_config.dart';

final class NetworkImageComponent extends StatelessWidget {
  const NetworkImageComponent({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? borderRadius;

  @override
  Widget build(final BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(
      borderRadius ?? AppConfig.inBorderRadius,
    ),
    child: CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (final context, final url) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (final context, final url, final error) => Container(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Icon(Icons.error, color: Theme.of(context).colorScheme.error),
      ),
    ),
  );
}
