import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../astro_game.dart';

class PlayerShip extends SpriteComponent with HasGameReference<AstroGame> {
  PlayerShip() : super(size: Vector2(64, 64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load the sprite from the assets directory
    sprite = await game.loadSprite('hd_ship_sleek_1781686447510.jpg');
    position = Vector2(game.size.x / 2, game.size.y - 100);
    
    // Add collision box
    add(RectangleHitbox());
  }
}
