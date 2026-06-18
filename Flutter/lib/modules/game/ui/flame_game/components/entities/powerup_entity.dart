import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';
import 'player_entity.dart';
import 'enemy_entity.dart';
import '../../../../logic/bloc/game_bloc.dart';

enum PowerUpType { flutter, backend, cybersecurity, uiux, hr, logistics }

class PowerUpEntity extends BaseSpriteEntity with MovementBehavior {
  late PowerUpType type;

  PowerUpEntity() : super(size: Vector2(40, 40), anchor: Anchor.center) {
    speed = 100.0;
    velocity = Vector2(0, 1); // Move downwards
    type = PowerUpType.values[Random().nextInt(PowerUpType.values.length)];
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    String spriteName = 'hd_powerup_1781686488826.jpg'; // generic
    if (type == PowerUpType.backend) {
      spriteName = 'hd_powerup_backend_1781686742263.jpg';
    } else if (type == PowerUpType.uiux) {
      spriteName = 'hd_powerup_uiux_1781686753399.jpg';
    }
    
    await loadAsset(spriteName);
    position = Vector2(Random().nextDouble() * game.size.x, -50);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (position.y > game.size.y + 50) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerEntity) {
      HapticFeedback.mediumImpact();
      applyPowerUp(other);
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
        // Care package - Health Regen
        player.health = (player.health + 40).clamp(0, 100).toInt();
        game.gameBloc.add(const GameEvent.playerDamaged(-40));
        break;
      case PowerUpType.logistics:
        // Screen wipe
        for (final enemy in game.children.whereType<EnemyEntity>().toList()) {
          enemy.takeDamage(100);
        }
        break;
    }
  }
}
