import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../constants/app_config.dart';

final class AvatarComponent extends StatelessWidget {
  const AvatarComponent({
    required this.imageUrl,
    super.key,
    this.radius,
    this.fallbackIcon,
  });
  final String imageUrl;
  final double? radius;
  final IconData? fallbackIcon;

  @override
  Widget build(final BuildContext context) {
    final effectiveRadius = radius ?? AppConfig.avatarRadius;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1.5,
        ),
      ),
      child: CircleAvatar(
        radius: effectiveRadius,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundImage: CachedNetworkImageProvider(
          imageUrl,
          maxWidth: 150,
          maxHeight: 150,
        ),
        onBackgroundImageError: (final exception, final stackTrace) =>
            fallbackIcon != null ? Icon(fallbackIcon) : null,
        child: imageUrl.isEmpty
            ? Icon(fallbackIcon ?? Iconsax.user_copy, size: effectiveRadius)
            : null,
      ),
    );
  }
}
