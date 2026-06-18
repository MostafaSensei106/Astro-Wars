import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'components/spaceship.dart';

class AstroWarsGame extends FlameGame with PanDetector {
  late Spaceship player;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Background color
    camera.backdrop = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF0F0C29),
    );

    // Player spaceship
    player = Spaceship()
      ..position = Vector2(size.x / 2, size.y - 100)
      ..size = Vector2(50, 50)
      ..anchor = Anchor.center;

    add(player);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.position.add(info.delta.global);
    
    // Keep player on screen
    player.position.x = player.position.x.clamp(0, size.x);
    player.position.y = player.position.y.clamp(0, size.y);
  }
}
