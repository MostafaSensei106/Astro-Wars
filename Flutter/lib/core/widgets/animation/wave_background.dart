import 'package:flutter/material.dart';

import 'wave_painter.dart';

final class WaveBackground extends StatelessWidget {
  const WaveBackground({
    required this.animation,
    required this.color,
    super.key,
    this.reverse = false,
    this.amplitude = 15,
    this.waveHeight = 100,
  });

  final Animation<double> animation;
  final Color color;
  final bool reverse;
  final double amplitude;
  final double waveHeight;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: WavePainter(
          animation: animation,
          color: color,
          reverse: reverse,
          amplitude: amplitude,
          waveHeight: waveHeight,
        ),
      ),
    );
  }
}
