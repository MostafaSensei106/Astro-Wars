import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Spaceship extends PositionComponent {
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Simple placeholder shape for the spaceship
    final paint = Paint()..color = Colors.blueAccent;
    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y)
      ..lineTo(0, size.y)
      ..close();

    canvas.drawPath(path, paint);
  }
}
