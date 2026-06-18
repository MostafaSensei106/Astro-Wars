import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../base/behaviors.dart';
import '../../astro_game.dart';

class Projectile extends PositionComponent
    with MovementBehavior, CollisionCallbacks, HasGameReference<AstroGame> {
  final double damage;
  final bool isEnemyProjectile;
  final bool isAoE;
  late Paint basePaint;

  Projectile({
    required Vector2 startPosition,
    required Vector2 direction,
    this.damage = 25.0,
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
      // Scary glowing red orbs for enemies
      final center = Offset(size.x / 2, size.y / 2);
      final radius = size.x / 1.5;
      
      final outerGlow = Paint()
        ..color = Colors.redAccent.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(center, radius + 4, outerGlow);

      final innerGlow = Paint()
        ..color = Colors.red.withValues(alpha: 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(center, radius, innerGlow);

      final core = Paint()..color = Colors.yellowAccent;
      canvas.drawCircle(center, radius / 2, core);
      
    } else {
      // Draw glowing neon effect for player capsules
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Radius.circular(size.x / 2),
      );

      final baseColor = basePaint.color;

      final outerGlow = Paint()
        ..color = baseColor.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawRRect(rect, outerGlow);

      final innerGlow = Paint()
        ..color = baseColor.withValues(alpha: 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
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
    // Remove if it goes off-screen
    if (position.y < -50 || position.y > game.size.y + 50 || 
        position.x < -50 || position.x > game.size.x + 50) {
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
      if (isEnemyProjectile) {
        // Enemy bullets only hit the Player
        if (other.runtimeType.toString() == 'PlayerEntity') {
          (other as IDamageable).takeDamage(damage.toInt());
          removeFromParent();
        }
      } else {
        // Player bullets hit enemies
        if (other.runtimeType.toString() == 'EnemyEntity' ||
            other.runtimeType.toString() == 'BossEntity') {
          (other as IDamageable).takeDamage(damage.toInt());

          if (isAoE) {
            // Apply damage to all nearby enemies (radius 150)
            for (final enemy in game.children.whereType<PositionComponent>()) {
              if (enemy is IDamageable &&
                  enemy != other &&
                  enemy.runtimeType.toString() != 'PlayerEntity') {
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
