import 'dart:math' as math;

import 'package:flutter/material.dart';

final class WavePainter extends CustomPainter {
  WavePainter({
    required this.animation,
    required this.color,
    this.reverse = false,
    this.amplitude = 15.0,
    this.waveHeight = 100.0,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;
  final bool reverse;
  final double amplitude;
  final double waveHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final baseHeight = size.height - (waveHeight / 2);

    path.moveTo(0, size.height);
    path.lineTo(0, baseHeight);

    final waveValue = animation.value;
    final direction = reverse ? -1 : 1;
    final phase = waveValue * 2 * math.pi * direction;

    for (double i = 0; i <= size.width; i++) {
      final y =
          baseHeight +
          amplitude * math.sin((i / size.width * 2 * math.pi) + phase);
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.reverse != reverse ||
      oldDelegate.amplitude != amplitude ||
      oldDelegate.waveHeight != waveHeight;
}
