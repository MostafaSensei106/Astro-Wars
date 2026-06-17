import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class PlayerShip extends SpriteComponent with HasGameRef {
  PlayerShip() : super(size: Vector2(64, 64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load the sprite from the assets directory
    sprite = await gameRef.loadSprite('hd_ship_sleek_1781686447510.jpg');
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 100);
    
    // Add collision box
    add(RectangleHitbox());
  }
}
