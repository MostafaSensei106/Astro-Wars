import "package:flutter/material.dart";
import "../../neu_widgets.dart";
import "../../../constants/app_config.dart";

class TextButtonComponent extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  
  const TextButtonComponent({required this.label, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) => NeuButton(
    onPressed: onPressed,
    child: Text(label, style: TextStyle(color: NeuTheme.textColor(context))),
  );
}