import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/assets_images.dart';
import '../../../../../../core/utils/theme/astro_design.dart';
import 'dart:math';
import '../base/behaviors.dart';
import '../particles/fx.dart';
import 'player_entity.dart';
import 'enemy_entity.dart';
import '../../astro_game.dart';
import '../../../../logic/bloc/game_bloc.dart';

enum PowerUpType { flutter, backend, cybersecurity, uiux, hr, logistics, coolant }

class PowerUpEntity extends PositionComponent
    with MovementBehavior, CollisionCallbacks, HasGameReference<AstroGame> {
  late PowerUpType type;
  late double _time;
  late SpriteComponent sprite;
  late CircleComponent aura;
  late TextComponent labelText;

  PowerUpEntity() : super(size: Vector2(40, 40), anchor: Anchor.center) {
    speed = 100.0;
    velocity = Vector2(0, 1); // Move downwards
    type = PowerUpType.values[Random().nextInt(PowerUpType.values.length)];
    _time = Random().nextDouble() * 10;
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    String spriteName = AssetsImages.giftFlutter; // generic gift
    String label = 'POWER';
    Color auraColor = Colors.yellowAccent;

    if (type == PowerUpType.flutter) {
      label = 'LASER';
      auraColor = Colors.blueAccent;
    } else if (type == PowerUpType.backend) {
      spriteName = AssetsImages.giftBackend;
      label = 'BOMB';
      auraColor = Colors.orangeAccent;
    } else if (type == PowerUpType.uiux) {
      spriteName = AssetsImages.giftStun;
      label = 'STUN';
      auraColor = Colors.purpleAccent;
    } else if (type == PowerUpType.cybersecurity) {
      spriteName = AssetsImages.giftShield;
      label = 'SHIELD';
      auraColor = Colors.cyanAccent;
    } else if (type == PowerUpType.hr) {
      spriteName = AssetsImages.giftHeal;
      label = 'HEAL';
      auraColor = Colors.greenAccent;
    } else if (type == PowerUpType.logistics) {
      spriteName = AssetsImages.giftMissile;
      label = 'MISSILE';
      auraColor = Colors.redAccent;
    } else if (type == PowerUpType.coolant) {
      spriteName = AssetsImages.giftCoolant;
      label = 'COOLANT';
      auraColor = Colors.lightBlueAccent;
    }

    // Add glowing magical aura behind the sprite
    aura = CircleComponent(
      radius: 30,
      paint: Paint()
        ..color = auraColor.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      anchor: Anchor.center,
      position: size / 2,
    );
    add(aura);

    sprite = SpriteComponent()
      ..sprite = await game.loadSprite(spriteName)
      ..size =
          Vector2(30, 30) // slightly smaller than aura
      ..anchor = Anchor.center
      ..position = size / 2;
    add(sprite);

    labelText = TextComponent(
      text: label,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(color: auraColor, blurRadius: 10)],
        ),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.y + 8),
    );
    add(labelText);

    position = Vector2(Random().nextDouble() * game.size.x, -50);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    // Pulsate the aura
    aura.scale = Vector2.all(1.0 + 0.2 * sin(_time * 4));

    // Smoothly rotate the inner sprite
    sprite.angle += 2.0 * dt;

    if (position.y > game.size.y + 50) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerEntity) {
      HapticFeedback.mediumImpact();
      applyPowerUp(other);
      if (type != PowerUpType.coolant) {
        // Coolant plays its own shimmer inside applyPowerUp.
        final isGift = type == PowerUpType.flutter ||
            type == PowerUpType.backend ||
            type == PowerUpType.uiux;
        Sfx.play(isGift ? AssetsAudio.giftPickup : AssetsAudio.powerup,
            volume: 0.6);
      }
      Fx.sparkle(game, position.clone(), Colors.white);
      Fx.ring(game, position.clone(), Colors.white, maxRadius: 60);
      removeFromParent();
    }
  }

  void applyPowerUp(PlayerEntity player) {
    switch (type) {
      case PowerUpType.flutter:
        player.activateWeapon(type, fireRate: 0.1);
        break;
      case PowerUpType.backend:
        player.activateWeapon(type, fireRate: 0.6);
        break;
      case PowerUpType.cybersecurity:
        player.activateShield();
        break;
      case PowerUpType.uiux:
        // Stun enemies for 2 seconds
        for (final enemy in game.children.whereType<EnemyEntity>()) {
          enemy.speed = 0;
          enemy.shootTimer.limit = 9999; // effectively stop shooting
          Future.delayed(const Duration(seconds: 2), () {
            if (enemy.isMounted) {
              enemy.speed = 150.0;
              enemy.shootTimer.limit = 1.5;
            }
          });
        }
        break;
      case PowerUpType.hr:
        // Care package - heal exactly 1 HP (clamped to max inside bloc).
        player.heal(1);
        game.gameBloc.add(const GameEvent.playerDamaged(-1));
        break;
      case PowerUpType.logistics:
        // Logistics crate: loads one missile instead of a free screen wipe.
        // Missiles are fired from the HUD button (limited resource).
        game.addMissile(1);
        break;
      case PowerUpType.coolant:
        // Instantly vent weapon heat + clear overheat lockout.
        player.ventHeat();
        Sfx.play(AssetsAudio.coolant, volume: 0.6);
        break;
    }
  }
}
