import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../base/behaviors.dart';
import '../../astro_game.dart';

class Projectile extends RectangleComponent with MovementBehavior, CollisionCallbacks, HasGameReference<AstroGame> {
  final double damage;
  final bool isEnemyProjectile;
  final bool isAoE;

  Projectile({
    required Vector2 startPosition,
    required Vector2 direction,
    this.damage = 25.0,
    this.isEnemyProjectile = false,
    this.isAoE = false,
  }) : super(size: Vector2(10, 30), anchor: Anchor.center) {
    position = startPosition;
    velocity = direction;
    speed = 400.0; // Fast bullet
    paint = Paint()..color = isEnemyProjectile ? Colors.redAccent : Colors.cyanAccent;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Remove if it goes off-screen
    if (position.y < -50 || position.y > game.size.y + 50) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is IDamageable && other is! Projectile) {
      if (isEnemyProjectile) {
        // Enemy bullets only hit the Player
        if (other.runtimeType.toString() == 'PlayerEntity') {
          (other as IDamageable).takeDamage(damage.toInt());
          removeFromParent();
        }
      } else {
        // Player bullets hit enemies
        if (other.runtimeType.toString() == 'EnemyEntity' || other.runtimeType.toString() == 'BossEntity') {
          (other as IDamageable).takeDamage(damage.toInt());
          
          if (isAoE) {
            // Apply damage to all nearby enemies (radius 150)
            for (final enemy in game.children.whereType<PositionComponent>()) {
              if (enemy is IDamageable && enemy != other && enemy.runtimeType.toString() != 'PlayerEntity') {
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
