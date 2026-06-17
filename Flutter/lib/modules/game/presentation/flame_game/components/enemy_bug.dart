import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dart:math';

class EnemyBug extends SpriteComponent with HasGameRef {
  final double speed = 150.0;

  EnemyBug() : super(size: Vector2(48, 48), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load the enemy sprite
    sprite = await gameRef.loadSprite('hd_enemy_bug_1781686468572.jpg');
    
    // Random horizontal spawn position
    final random = Random();
    position = Vector2(random.nextDouble() * gameRef.size.x, -50);
    
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;

    if (position.y > gameRef.size.y + 50) {
      removeFromParent();
    }
  }
}
