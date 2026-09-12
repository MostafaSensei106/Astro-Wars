import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../../astro_game.dart';
import '../../../../../../core/utils/theme/astro_design.dart';
import '../../../../../../core/constants/assets_images.dart';
import '../particles/fx.dart';

/// Commit pickup (CI drumstick equivalent): drifts down, magnets toward
/// the player when close. Every 10 commits load one missile.
class CommitEntity extends PositionComponent
    with CollisionCallbacks, HasGameReference<AstroGame> {
  CommitEntity({required Vector2 startPosition})
    : super(
        position: startPosition,
        size: Vector2(22, 22),
        anchor: Anchor.center,
      ) {
    add(RectangleHitbox());
  }

  double _time = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    position.y += 80 * dt; // drift down

    // Magnet toward the player.
    final player = game.player;
    if (player.isMounted) {
      final toPlayer = player.position - position;
      final dist = toPlayer.length;
      if (dist < 150 && dist > 1) {
        position.add(toPlayer.normalized() * (320 * dt));
      }
      if (dist < 30) {
        collect();
        return;
      }
    }

    if (position.y > game.size.y + 30) removeFromParent();
  }

  void collect() {
    game.registerCommit();
    Fx.sparkle(game, position.clone(), AstroDesign.neonAmber, count: 6);
    Sfx.play(AssetsAudio.laserEnemy, volume: 0.12);
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final c = Offset(size.x / 2, size.y / 2);
    final bob = (_time * 4).toDouble();
    // Golden hex coin with halo (plain alpha, no blur).
    canvas.drawCircle(
      c,
      11,
      Paint()..color = AstroDesign.neonAmber.withValues(alpha: 0.25),
    );
    final hex = Path();
    for (int i = 0; i < 6; i++) {
      final a = (i / 6) * 2 * pi + bob * 0.3;
      final p = Offset(c.dx + 7 * cos(a), c.dy + 7 * sin(a));
      if (i == 0) {
        hex.moveTo(p.dx, p.dy);
      } else {
        hex.lineTo(p.dx, p.dy);
      }
    }
    hex.close();
    canvas.drawPath(hex, Paint()..color = AstroDesign.neonAmber);
    canvas.drawPath(
      hex,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }
}
