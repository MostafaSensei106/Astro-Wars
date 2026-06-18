import 'package:flutter/material.dart';

class NeuTheme {
  // Dark neumorphism colors suitable for Astro Wars
  static const Color bgColor = Color(0xFF2A2D32);
  static const Color darkShadow = Color(0xFF1A1C1F);
  static const Color lightShadow = Color(0xFF3A3E45);
  static const Color accentColor = Colors.purpleAccent;
  static const Color textColor = Colors.white;
}

class NeuContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool isInner; // For pressed effect

  const NeuContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16.0,
    this.isInner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: NeuTheme.bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isInner
            ? null // Inner shadow in Flutter requires special painting or inner_shadow packages, we'll keep it flat/recessed for inner
            : [
                BoxShadow(
                  color: NeuTheme.darkShadow,
                  offset: const Offset(5, 5),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: NeuTheme.lightShadow,
                  offset: const Offset(-5, -5),
                  blurRadius: 10,
                ),
              ],
        border: isInner
            ? Border.all(color: NeuTheme.darkShadow, width: 2)
            : null,
      ),
      child: child,
    );
  }
}

class NeuButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? width;
  final double? height;

  const NeuButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = 16.0,
    this.width,
    this.height,
  });

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed!();
            }
          : null,
      onTapCancel: widget.onPressed != null
          ? () => setState(() => _isPressed = false)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: NeuTheme.bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isPressed || widget.onPressed == null
              ? [] // Flat when pressed or disabled
              : [
                  BoxShadow(
                    color: NeuTheme.darkShadow,
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: NeuTheme.lightShadow,
                    offset: const Offset(-5, -5),
                    blurRadius: 10,
                  ),
                ],
          border: _isPressed
              ? Border.all(
                  color: NeuTheme.darkShadow,
                  width: 2,
                ) // Simulating inner depth
              : null,
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}

class NeuIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;

  const NeuIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return NeuButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(12.0),
      borderRadius: 50.0, // Circular
      child: Icon(icon, color: NeuTheme.textColor, size: size),
    );
  }
}
