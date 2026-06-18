import "package:flutter/material.dart";
import "../../neu_widgets.dart";
import "../../../constants/app_config.dart";

class FilledButtonComponent extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool useInBorderRadius;
  final double? width;
  final double? height;

  const FilledButtonComponent({
    required this.label,
    required this.onPressed,
    this.useInBorderRadius = false,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) => NeuButton(
    onPressed: onPressed,
    width: width,
    height: height ?? AppConfig.buttonHeight,
    borderRadius: useInBorderRadius
        ? AppConfig.inBorderRadius
        : AppConfig.outBorderRadius,
    child: Text(label, style: TextStyle(color: NeuTheme.textColor(context))),
  );
}
