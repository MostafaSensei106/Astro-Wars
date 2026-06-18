import 'package:flame/components.dart';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';
import '../projectiles/projectile.dart';
import 'powerup_entity.dart';
import '../../../../logic/bloc/game_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class PlayerEntity extends BaseSpriteEntity with HealthBehavior {
  late Timer shootTimer;
  PowerUpType? activeWeapon;
  bool hasShield = false;
  CircleComponent? shieldComponent;

  PlayerEntity() : super(size: Vector2(64, 64), anchor: Anchor.center) {
    health = 100;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final prefs = await SharedPreferences.getInstance();
    final shipAsset = prefs.getString('selected_ship') ?? 'hd_ship_sleek_1781686447510.jpg';
    await loadAsset(shipAsset);
    position = Vector2(game.size.x / 2, game.size.y - 100);
    shootTimer = Timer(0.25, onTick: shoot, repeat: true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.gameBloc.state.entity.isGameOver) {
      shootTimer.update(dt);
    }
  }

  void activateWeapon(PowerUpType type, {required double fireRate}) {
    activeWeapon = type;
    shootTimer.limit = fireRate;
    Future.delayed(const Duration(seconds: 10), () {
      if (activeWeapon == type) { // if not replaced by another
        activeWeapon = null;
        shootTimer.limit = 0.25; // Reset to normal
      }
    });
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
      
      Future.delayed(const Duration(seconds: 10), () {
        hasShield = false;
        shieldComponent?.removeFromParent();
        shieldComponent = null;
      });
    }
  }

  @override
  void takeDamage(int amount) {
    if (hasShield) return; // Immune!
    super.takeDamage(amount);
    HapticFeedback.vibrate();
  }

  void shoot() {
    if (activeWeapon == PowerUpType.flutter) {
      // Dual lasers
      game.add(Projectile(
        startPosition: position.clone()..translate(-15, -size.y / 2),
        direction: Vector2(0, -1),
      )..paint = (Paint()..color = Colors.blueAccent));
      
      game.add(Projectile(
        startPosition: position.clone()..translate(15, -size.y / 2),
        direction: Vector2(0, -1),
      )..paint = (Paint()..color = Colors.blueAccent));
      
    } else if (activeWeapon == PowerUpType.backend) {
      // Heavy slow AoE projectile
      final bullet = Projectile(
        startPosition: position.clone()..y -= size.y / 2,
        direction: Vector2(0, -1),
        damage: 100.0,
        isAoE: true,
      )..speed = 200.0
       ..size = Vector2(25, 25)
       ..paint = (Paint()..color = Colors.orangeAccent);
      game.add(bullet);
      
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
