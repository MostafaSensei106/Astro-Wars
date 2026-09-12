import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import '../../astro_game.dart';
import '../../../../../../core/constants/assets_images.dart';

/// Deep-space backdrop: level-tinted gradient + 3 scrolling parallax
/// star layers (generated in `Python/` via uv).
class _GradientBackground extends PositionComponent
    with HasGameReference<AstroGame> {
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    final colors = game.currentConfig.bgGradient;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ).createShader(Offset.zero & Size(size.x, size.y));
    canvas.drawRect(Offset.zero & Size(size.x, size.y), paint);
  }
}

class StarfieldComponent extends Component with HasGameReference<AstroGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(_GradientBackground());
    add(
      await game.loadParallaxComponent(
        [
          ParallaxImageData(AssetsImages.parallaxFar),
          ParallaxImageData(AssetsImages.parallaxMid),
          ParallaxImageData(AssetsImages.parallaxNear),
        ],
        baseVelocity: Vector2(0, 25),
        velocityMultiplierDelta: Vector2(0, 1.8),
        alignment: Alignment.bottomCenter,
        fill: LayerFill.width,
      ),
    );
  }
}
