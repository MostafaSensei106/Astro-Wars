import "package:flutter/material.dart";
import "../../neu_widgets.dart";

class TextFormFieldComponent extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool isEnable;
  final String? errorText;
  final String? initialValue;
  final Function(String)? onChanged;

  const TextFormFieldComponent({
    this.label,
    this.hint,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.isEnable = true,
    this.errorText,
    this.initialValue,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) => NeuContainer(
    isInner: true,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TextFormField(
      controller: controller,
      initialValue: initialValue,
      obscureText: obscureText,
      enabled: isEnable,
      onChanged: onChanged,
      style: TextStyle(color: NeuTheme.textColor(context)),
      decoration: InputDecoration(
        hintText: hint ?? label,
        hintStyle: TextStyle(
          color: NeuTheme.textColor(context).withValues(alpha: 0.5),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: NeuTheme.textColor(context))
            : null,
        suffixIcon: suffixIcon,
        errorText: errorText,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    ),
  );
}
