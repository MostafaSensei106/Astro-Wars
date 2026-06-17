import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../constants/app_config.dart';

final class SvgComponent extends StatelessWidget {
  const SvgComponent({
    required this.path,
    this.fit = BoxFit.contain,
    this.useInBorderRadius = false,
    super.key,
  }) : title = null,
       subtitle = null;

  const SvgComponent.descriptions({
    required this.path,
    required this.title,
    required this.subtitle,

    this.fit = BoxFit.contain,
    this.useInBorderRadius = false,

    super.key,
  });

  final String path;
  final String? title;
  final String? subtitle;

  final BoxFit fit;
  final bool useInBorderRadius;

  @override
  Widget build(BuildContext context) {
    final svgWidget = SvgPicture.asset(
      path,
      fit: fit,

      placeholderBuilder: (context) => Center(
        child: Icon(
          Iconsax.warning_2_copy,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );

    if (title == null && subtitle == null) return svgWidget;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        svgWidget,
        if (title != null) ...[
          const SizedBox(height: AppConfig.margin),

          Text(
            title!,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],

        if (subtitle != null) ...[
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
