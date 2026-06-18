import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame/components.dart';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';
import '../projectiles/projectile.dart';
import 'powerup_entity.dart';
import 'enemy_entity.dart';
import '../../../../logic/bloc/game_bloc.dart';

class PlayerEntity extends BaseSpriteEntity with HealthBehavior {
  PowerUpType? activeWeapon;
  int weaponLevel = 1;
  bool hasShield = false;
  CircleComponent? shieldComponent;
  bool _canShoot = true;
  int _fireRateMs = 250;

  PlayerEntity() : super(size: Vector2(64, 64), anchor: Anchor.center) {
    health = 100;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final prefs = await SharedPreferences.getInstance();
    final shipAsset =
        prefs.getString('selected_ship') ?? 'hd_ship_sleek_1781686447510.jpg';
    await loadAsset(shipAsset);
    position = Vector2(game.size.x / 2, game.size.y - 100);
  }

  void activateWeapon(PowerUpType type, {required double fireRate}) {
    if (activeWeapon == type) {
      weaponLevel = (weaponLevel + 1).clamp(1, 5);
    } else {
      activeWeapon = type;
      weaponLevel = 1;
    }

    // Fire rate gets slightly faster with each level
    double upgradedFireRate = fireRate - ((weaponLevel - 1) * 0.02);
    _fireRateMs = (max(0.05, upgradedFireRate) * 1000).toInt();

    // Weapons are now permanent until taking damage (no 10 sec timer)
  }

  void activateShield() {
    if (!hasShield) {
      hasShield = true;
      shieldComponent = CircleComponent(
        radius: 40,
        paint: Paint()
          ..color = Colors.cyanAccent.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill,
        anchor: Anchor.center,
        position: size / 2,
      );
      add(shieldComponent!);

      Future.delayed(const Duration(seconds: 15), () {
        hasShield = false;
        shieldComponent?.removeFromParent();
        shieldComponent = null;
      });
    } else {
      // If they pick up another shield while having one, it does a mini screen wipe
      for (final enemy in game.children.whereType<EnemyEntity>().toList()) {
        enemy.takeDamage(50);
      }
    }
  }

  @override
  void takeDamage(int amount) {
    if (hasShield) return; // Immune!

    // Lose a weapon level on hit
    if (weaponLevel > 1) {
      weaponLevel--;
    } else {
      activeWeapon = null; // lose weapon entirely
    }

    super.takeDamage(amount);
    HapticFeedback.vibrate();
  }

  void shoot() {
    if (!_canShoot) return;
    _canShoot = false;
    Future.delayed(Duration(milliseconds: _fireRateMs), () {
      _canShoot = true;
    });

    HapticFeedback.lightImpact();

    if (activeWeapon == PowerUpType.flutter) {
      // Dual lasers with spread based on level
      int count = weaponLevel + 1; // 2 to 6 lasers
      double spread = 18.0;
      double startX = -((count - 1) * spread) / 2;

      for (int i = 0; i < count; i++) {
        game.add(
          Projectile(
            startPosition: position.clone()
              ..translate(startX + (i * spread), -size.y / 2),
            direction: Vector2(0, -1),
          )..paint = (Paint()..color = Colors.blueAccent),
        );
      }
    } else if (activeWeapon == PowerUpType.backend) {
      // Heavy slow AoE projectile (Rockets)
      int count = weaponLevel; // 1 to 5 rockets
      double spread = 25.0;
      double startX = -((count - 1) * spread) / 2;

      for (int i = 0; i < count; i++) {
        final bullet =
            Projectile(
                startPosition: position.clone()
                  ..translate(startX + (i * spread), -size.y / 2),
                direction: Vector2(0, -1),
                damage: 100.0 + (weaponLevel * 10),
                isAoE: true,
              )
              ..speed = 200.0 + (weaponLevel * 20)
              ..size = Vector2(
                20 + (weaponLevel * 3.0),
                20 + (weaponLevel * 3.0),
              )
              ..paint = (Paint()..color = Colors.orangeAccent);
        game.add(bullet);
      }
    } else {
      // Normal shoot
      final bullet = Projectile(
        startPosition: position.clone()..y -= size.y / 2,
        direction: Vector2(0, -1),
      );
      game.add(bullet);
    }
  }

  @override
  void onDeath() {
    super.onDeath();
    HapticFeedback.heavyImpact();
    game.gameBloc.add(const GameEvent.playerDamaged(100)); // Triggers game over
  }
}
