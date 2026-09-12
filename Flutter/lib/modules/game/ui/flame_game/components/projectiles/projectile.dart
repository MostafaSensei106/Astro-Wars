import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../base/behaviors.dart';
import '../../astro_game.dart';
import '../particles/fx.dart';

class Projectile extends PositionComponent
    with MovementBehavior, CollisionCallbacks, HasGameReference<AstroGame> {
  final double damage;
  final bool isEnemyProjectile;
  final bool isAoE;
  late Paint basePaint;

  Projectile({
    required Vector2 startPosition,
    required Vector2 direction,
    this.damage = 30.0,
    this.isEnemyProjectile = false,
    this.isAoE = false,
  }) : super(size: Vector2(8, 30), anchor: Anchor.center) {
    position = startPosition;
    velocity = direction;
    speed = 400.0;
    basePaint = Paint()
      ..color = isEnemyProjectile ? Colors.redAccent : Colors.cyanAccent;
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    if (isEnemyProjectile) {
      // Cartoon egg: white shell, soft outline, glossy highlight.
      final center = Offset(size.x / 2, size.y / 2);
      final shell = Paint()..color = const Color(0xFFFFF6E8);
      final outline = Paint()
        ..color = const Color(0xFFD8C9A8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      final glow = Paint()
        ..color = Colors.redAccent.withValues(alpha: 0.18);
      final eggRect = Rect.fromCenter(
        center: center,
        width: size.x,
        height: size.y * 1.6,
      );
      final haloRect = Rect.fromCenter(
        center: center,
        width: size.x + 8,
        height: size.y * 1.6 + 8,
      );
      canvas.drawOval(haloRect, glow);
      canvas.drawOval(eggRect, shell);
      canvas.drawOval(eggRect, outline);
      canvas.drawCircle(
        center + const Offset(-2, -4),
        2,
        Paint()..color = Colors.white,
      );
    } else {
      // Neon capsule: layered alpha shells, no blur filters (hot path).
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Radius.circular(size.x / 2),
      );
      final baseColor = basePaint.color;
      final outerGlow = Paint()
        ..color = baseColor.withValues(alpha: 0.25);
      canvas.drawRRect(rect, outerGlow);

      final innerGlow = Paint()
        ..color = baseColor.withValues(alpha: 0.75);
      canvas.drawRRect(rect, innerGlow);

      final coreRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(size.x * 0.25, size.y * 0.1, size.x * 0.5, size.y * 0.8),
        Radius.circular(size.x / 4),
      );
      final corePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawRRect(coreRect, corePaint);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isEnemyProjectile) {
      // Eggs fall with gravity: slight arc instead of a laser-straight line.
      velocity.y += 1.4 * dt;
      angle = (velocity.x * 0.4).clamp(-0.5, 0.5);
    }
    // Remove if it goes off-screen
    if (position.y < -50 ||
        position.y > game.size.y + 50 ||
        position.x < -50 ||
        position.x > game.size.x + 50) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is IDamageable) {
      final damageable = other as IDamageable;
      // Team check via game player identity — no fragile runtimeType strings.
      final bool isPlayer = identical(other, game.player);
      if (isEnemyProjectile) {
        // Enemy eggs only hit the Player — with a yolky splat.
        if (isPlayer) {
          Fx.splat(game, position.clone());
          damageable.takeDamage(damage.toInt());
          removeFromParent();
        }
      } else {
        // Player bullets hit anything damageable except the player itself
        // (enemies, bosses AND meteors).
        if (!isPlayer) {
          damageable.takeDamage(damage.toInt());

          if (isAoE) {
            // Apply damage to all nearby enemies (radius 150)
            for (final enemy in game.children.whereType<PositionComponent>()) {
              if (enemy is IDamageable &&
                  enemy != other &&
                  !identical(enemy, game.player)) {
                if (enemy.position.distanceTo(position) < 150) {
                  (enemy as IDamageable).takeDamage(damage.toInt());
                }
              }
            }
          }

          removeFromParent();
        }
      }
    }
  }
}
