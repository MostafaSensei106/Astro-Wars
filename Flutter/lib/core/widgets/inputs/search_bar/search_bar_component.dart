import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../constants/app_config.dart';
import '../../../di/di.dart';
import '../../../services/theme/theme_service.dart';

final class SearchBarComponent extends StatelessWidget {
  const SearchBarComponent({
    required this.controller,
    required this.hintText,
    super.key,
    this.onChanged,
  });
  final TextEditingController controller;
  final String hintText;
  final void Function(String)? onChanged;

  @override
  Widget build(final BuildContext context) {
    final colorScheme = getIt<ThemeService>().get(context);

    return SearchBar(
      controller: controller,
      leading: const Icon(Iconsax.search_normal_1_copy),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      hintText: hintText,
      onChanged: onChanged,
      elevation: const WidgetStatePropertyAll(0),

      backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainer),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
        ),
      ),
      keyboardType: TextInputType.name,
    );
  }
}
