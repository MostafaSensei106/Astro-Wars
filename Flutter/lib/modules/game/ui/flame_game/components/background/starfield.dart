import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../astro_game.dart';

/// Lightweight coded starfield: level-tinted gradient + 3 star layers
/// scrolling DOWNWARD (ship flies up), plus an occasional shooting star.
///
/// Fully procedural — no image decoding, no blur filters, no overdraw:
/// the cheapest possible backdrop for low-end phones.
/// Flip [scrollDown] to reverse the flow direction.
class StarfieldComponent extends Component with HasGameReference<AstroGame> {
  static const bool scrollDown = true;
  static const List<int> layerCounts = [70, 45, 25];
  static const List<double> layerSpeeds = [28.0, 68.0, 135.0];

  final _rnd = Random();
  final List<_Star> _stars = [];
  Vector2 _area = Vector2.zero();

  double _shootCooldown = 4.0;
  _ShootingStar? _shooting;

  static final _paints = [
    Paint()..color = const Color(0xFF8A93B8).withValues(alpha: 0.5),
    Paint()..color = const Color(0xFFC6CDE8).withValues(alpha: 0.75),
    Paint()..color = Colors.white,
  ];

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _area = size;
    _seed();
  }

  void _seed() {
    _stars.clear();
    for (int layer = 0; layer < 3; layer++) {
      for (int i = 0; i < layerCounts[layer]; i++) {
        _stars.add(_Star(
          x: _rnd.nextDouble() * _area.x,
          y: _rnd.nextDouble() * _area.y,
          layer: layer,
          size: layer == 2 ? 2.5 : (layer == 1 ? 1.8 : 1.3),
        ));
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_area.x <= 0) return;
    final dir = scrollDown ? 1.0 : -1.0;
    for (final s in _stars) {
      s.y += layerSpeeds[s.layer] * dir * dt;
      if (s.y > _area.y + 4) {
        s.y = -4;
        s.x = _rnd.nextDouble() * _area.x;
      } else if (s.y < -4) {
        s.y = _area.y + 4;
        s.x = _rnd.nextDouble() * _area.x;
      }
    }
    // Occasional shooting star (diagonal streak, same flow direction).
    _shootCooldown -= dt;
    if (_shootCooldown <= 0 && _shooting == null) {
      _shootCooldown = 5 + _rnd.nextDouble() * 7;
      _shooting = _ShootingStar(
        x: _rnd.nextDouble() * _area.x,
        y: -20,
        vx: (_rnd.nextDouble() - 0.5) * 220,
        vy: 420,
      );
    }
    final sh = _shooting;
    if (sh != null) {
      sh.x += sh.vx * dt;
      sh.y += sh.vy * dt;
      sh.life -= dt;
      if (sh.life <= 0 || sh.y > _area.y + 40) _shooting = null;
    }
  }

  @override
  void render(Canvas canvas) {
    // Level-tinted space gradient.
    final colors = game.currentConfig.bgGradient;
    canvas.drawRect(
      Offset.zero & Size(_area.x, _area.y),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ).createShader(Offset.zero & Size(_area.x, _area.y)),
    );
    // Stars: plain rects, zero blur, one paint per layer.
    for (final s in _stars) {
      canvas.drawRect(
        Rect.fromLTWH(s.x, s.y, s.size, s.size),
        _paints[s.layer],
      );
    }
    // Shooting star: bright head + fading tail (two plain strokes).
    final sh = _shooting;
    if (sh != null) {
      final a = (sh.life / _ShootingStar.maxLife).clamp(0.0, 1.0);
      canvas.drawLine(
        Offset(sh.x, sh.y),
        Offset(sh.x - sh.vx * 0.18, sh.y - sh.vy * 0.18),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5 * a)
          ..strokeWidth = 2,
      );
      canvas.drawCircle(
        Offset(sh.x, sh.y),
        2.5,
        Paint()..color = Colors.white.withValues(alpha: a),
      );
    }
  }
}

class _Star {
  double x, y;
  final int layer;
  final double size;
  _Star({required this.x, required this.y, required this.layer, required this.size});
}

class _ShootingStar {
  double x, y, vx, vy;
  double life = maxLife;
  static const double maxLife = 1.1;
  _ShootingStar({required this.x, required this.y, required this.vx, required this.vy});
}
