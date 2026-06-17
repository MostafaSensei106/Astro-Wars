import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dart:math';
import '../astro_game.dart';

class EnemyBug extends SpriteComponent with HasGameReference<AstroGame> {
  final double speed = 150.0;

  EnemyBug() : super(size: Vector2(48, 48), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load the enemy sprite
    sprite = await game.loadSprite('hd_enemy_bug_1781686468572.jpg');

    // Random horizontal spawn position
    final random = Random();
    position = Vector2(random.nextDouble() * game.size.x, -50);

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;

    if (position.y > game.size.y + 50) {
      removeFromParent();
    }
  }
}
