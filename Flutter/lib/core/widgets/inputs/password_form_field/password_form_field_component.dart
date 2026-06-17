import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../text_form_field/text_form_field_component.dart';

final class PasswordFieldComponent extends HookWidget {
  const PasswordFieldComponent({
    required this.label,
    required this.onChanged,

    super.key,
    this.controller,
    this.errorText,

    this.isEnable = true,
    this.initialValue,
  });

  final String label;
  final TextEditingController? controller;
  final void Function(String) onChanged;
  final bool isEnable;
  final String? errorText;
  final String? initialValue;

  @override
  Widget build(final BuildContext context) {
    final obscureText = useState(true);

    return TextFormFieldComponent(
      label: label,
      controller: controller,
      prefixIcon: Iconsax.lock_1_copy,
      obscureText: obscureText.value,
      isEnable: isEnable,
      errorText: errorText,
      initialValue: initialValue,

      suffixIcon: IconButton(
        icon: Icon(
          obscureText.value ? Iconsax.eye_copy : Iconsax.eye_slash_copy,
        ),
        onPressed: () => obscureText.value = !obscureText.value,
      ),
      onChanged: (val) => onChanged.call(val),
    );
  }
}
