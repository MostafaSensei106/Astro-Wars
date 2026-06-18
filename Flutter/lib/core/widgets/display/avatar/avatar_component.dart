import "package:flutter/material.dart";
import "../../neu_widgets.dart";

class AvatarComponent extends StatelessWidget {
  final IconData icon;
  final double size;
  const AvatarComponent({required this.icon, this.size = 60, super.key});

  @override
  Widget build(BuildContext context) => NeuContainer(
    width: size * 2,
    height: size * 2,
    borderRadius: size,
    isInner: true,
    child: Icon(icon, size: size, color: NeuTheme.accentColor(context)),
  );
}
