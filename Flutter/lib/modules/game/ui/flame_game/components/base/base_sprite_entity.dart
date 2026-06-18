import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../../astro_game.dart';

abstract class BaseSpriteEntity extends SpriteComponent
    with HasGameReference<AstroGame>, CollisionCallbacks {
  BaseSpriteEntity({required super.size, required super.anchor});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
  }

  // Common method to load sprite by name
  Future<void> loadAsset(String assetName) async {
    sprite = await game.loadSprite(assetName);
  }
}
