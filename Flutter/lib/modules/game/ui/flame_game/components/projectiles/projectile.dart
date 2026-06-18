import 'package:flame/components.dart';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';

class Projectile extends BaseSpriteEntity with MovementBehavior {
  final double damage;
  final bool isEnemyProjectile;

  Projectile({
    required Vector2 startPosition,
    required Vector2 direction,
    this.damage = 25.0,
    this.isEnemyProjectile = false,
  }) : super(size: Vector2(10, 30), anchor: Anchor.center) {
    position = startPosition;
    velocity = direction;
    speed = 400.0; // Fast bullet
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await game.loadSprite('hd_powerup_1781686488826.jpg');
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
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
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
        if (other.runtimeType.toString() == 'EnemyEntity') {
          (other as IDamageable).takeDamage(damage.toInt());
          removeFromParent();
        }
      }
    }
  }
}
