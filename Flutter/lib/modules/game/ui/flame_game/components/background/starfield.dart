import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../astro_game.dart';

class StarfieldComponent extends Component with HasGameReference<AstroGame> {
  final int count = 80;
  final List<_Star> _stars = [];
  late Vector2 gameSize;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    gameSize = size;
    if (_stars.isEmpty) {
      final random = Random();
      for (int i = 0; i < count; i++) {
        _stars.add(_Star(
          x: random.nextDouble() * size.x,
          y: random.nextDouble() * size.y,
          speed: 20 + random.nextDouble() * 150, // Depth parallax
          radius: 0.5 + random.nextDouble() * 2.5,
          alpha: 0.3 + random.nextDouble() * 0.7,
        ));
      }
    }
  }

  @override
  void update(double dt) {
    for (var star in _stars) {
      star.y += star.speed * dt;
      if (star.y > gameSize.y) {
        star.y = 0;
        star.x = Random().nextDouble() * gameSize.x;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Deep Space Gradient Background
    final Rect bgRect = Rect.fromLTWH(0, 0, gameSize.x, gameSize.y);
    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: game.currentConfig.bgGradient,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bgRect);
    canvas.drawRect(bgRect, bgPaint);

    // Render stars
    for (var star in _stars) {
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: star.alpha);
      canvas.drawRect(Rect.fromLTWH(star.x, star.y, star.radius * 2, star.radius * 2), paint);
    }
  }
}

class _Star {
  double x, y, speed, radius, alpha;
  _Star({
    required this.x,
    required this.y,
    required this.speed,
    required this.radius,
    required this.alpha,
  });
}
