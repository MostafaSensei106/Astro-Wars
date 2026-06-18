import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../astro_game.dart';

class StarfieldComponent extends Component with HasGameReference<AstroGame> {
  late Sprite bgSprite;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    bgSprite = await Sprite.load('space_bg.jpg');
  }

  @override
  void render(Canvas canvas) {
    bgSprite.render(canvas, size: game.size);
  }
}
