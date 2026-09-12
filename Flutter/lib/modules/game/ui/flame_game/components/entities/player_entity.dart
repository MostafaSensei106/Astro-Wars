import 'package:flame_audio/flame_audio.dart';
import '../../../../../../core/utils/theme/astro_design.dart';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/effects.dart';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';
import '../projectiles/projectile.dart';
import '../particles/fx.dart';
import 'powerup_entity.dart';
import 'enemy_entity.dart';
import '../../../../logic/bloc/game_bloc.dart';

class ShieldForcefield extends PositionComponent {
  double _time = 0;

  ShieldForcefield({required double radius})
    : super(size: Vector2.all(radius * 2), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final radius = size.x / 2;

    // Pulsating radius
    final pulse = sin(_time * 5) * 5;

    final paint1 = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius + pulse, paint1);

    final paint2 = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(center, radius + pulse + 2, paint2);

    final paint3 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius + pulse + 2, paint3);
  }
}

class PlayerEntity extends BaseSpriteEntity with HealthBehavior {
  static const int maxHealth = 5;
  PowerUpType? activeWeapon;
  int weaponLevel = 1;
  bool hasShield = false;
  ShieldForcefield? shieldComponent;
  bool _canShoot = true;
  int _fireRateMs = 250;

  /// Hold-to-fire: the game loop calls [tickAutofire] every frame.
  bool autofireEnabled = true;

  // --- Overheat (CI-style): sustained fire builds heat; at 100 the
  // weapon locks for 3s. Backend rockets run hotter than lasers.
  double heat = 0;
  bool overheated = false;
  double _overheatTimer = 0;
  bool _warnPlayed = false;
  static const double _coolRate = 30;
  static const double _overheatLockout = 3.0;

  static const int maxWeaponLevel = 10;

  double get heat01 => (heat / 100).clamp(0.0, 1.0);

  double get _heatPerShot => switch (activeWeapon) {
        PowerUpType.backend => 9.0,
        PowerUpType.flutter => 4.0,
        _ => 5.5,
      };

  double _particleTimer = 0;

  PlayerEntity() : super(size: Vector2(64, 64), anchor: Anchor.center) {
    health = 3;
  }

  bool isInvincible = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final prefs = await SharedPreferences.getInstance();
    final shipAsset =
        prefs.getString('selected_ship') ?? 'ship_sleek.png';
    await loadAsset(shipAsset);
    position = Vector2(game.size.x / 2, game.size.y - 100);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameBloc.state.entity.isGameOver) {
      return;
    }

    // Engine exhaust particles
    _particleTimer += dt;
    if (_particleTimer > 0.05) {
      _particleTimer = 0;
      _spawnEngineParticles();
    }

    // Damage Smoke if health is low
    if (health <= 1 && Random().nextDouble() < 0.1) {
      _spawnSmokeParticles();
    }

    // Heat dissipation + overheat lockout countdown.
    if (overheated) {
      _overheatTimer -= dt;
      if (_overheatTimer <= 0) {
        overheated = false;
        heat = 0;
        _warnPlayed = false;
      }
    } else if (heat > 0) {
      heat = (heat - _coolRate * dt).clamp(0.0, 100.0);
      if (heat < 70) _warnPlayed = false;
    }

    // Autofire: tap-to-shoot still works via ShootDetector, but holding
    // is no longer required — the ship fires at its fire-rate automatically.
    if (autofireEnabled) {
      shoot();
    }
  }

  /// Instantly vent all heat (Coolant pickup).
  void ventHeat() {
    heat = 0;
    overheated = false;
    _warnPlayed = false;
  }

  /// Heal clamped to [maxHealth]. The matching bloc event
  /// `playerDamaged(-amount)` is clamped there too.
  void heal(int amount) {
    health = (health + amount).clamp(0, maxHealth);
  }

  void _spawnEngineParticles() {
    Fx.trail(
      game,
      position.clone()..translate(0, size.y / 2 - 5),
      Colors.cyanAccent,
    );
  }

  void _spawnSmokeParticles() {
    Fx.smoke(game, position.clone(), Colors.black54, count: 2, size: 5);
  }

  void activateWeapon(PowerUpType type, {required double fireRate}) {
    if (activeWeapon == type) {
      // CI-style: gifts stack up to power level 10.
      weaponLevel = (weaponLevel + 1).clamp(1, maxWeaponLevel);
    } else {
      activeWeapon = type;
      weaponLevel = 1;
    }

    // Fire rate gets slightly faster with each level.
    double upgradedFireRate = fireRate - ((weaponLevel - 1) * 0.015);
    _fireRateMs = (max(0.05, upgradedFireRate) * 1000).toInt();
  }

  void activateShield() {
    if (!hasShield) {
      hasShield = true;
      shieldComponent = ShieldForcefield(radius: 45)..position = size / 2;
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
    if (hasShield || isInvincible || game.gameBloc.state.entity.isGameOver) {
      return;
    }

    // Lose ONE weapon level per hit (CI-style), never the whole weapon.
    if (weaponLevel > 1) {
      weaponLevel--;
      double baseRate =
          activeWeapon == PowerUpType.backend ? 0.6 : 0.1;
      _fireRateMs =
          (max(0.05, baseRate - ((weaponLevel - 1) * 0.015)) * 1000).toInt();
    }

    Sfx.play('hit.wav', volume: 0.5);
    // Knockback
    position.add(Vector2((Random().nextDouble() - 0.5) * 40, 30));

    health -= 1; // 1 Heart
    game.gameBloc.add(const GameEvent.playerDamaged(1));
    game.resetCombo(); // getting hit breaks the combo
    HapticFeedback.vibrate();

    if (health <= 0) {
      onDeath();
    } else {
      // Invincibility Frames
      isInvincible = true;
      paint.colorFilter = const ColorFilter.mode(
        Colors.redAccent,
        BlendMode.modulate,
      );
      Future.delayed(const Duration(seconds: 1), () {
        isInvincible = false;
        paint.colorFilter = null;
      });
    }
  }

  @override
  void onDeath() {
    HapticFeedback.heavyImpact();
    FlameAudio.bgm.stop();
    Sfx.play('gameover.wav', volume: 0.8);

    // Death Explosion
    final random = Random();
    game.add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 40,
          lifespan: 1.0,
          generator: (i) {
            return AcceleratedParticle(
              acceleration: Vector2(
                (random.nextDouble() - 0.5) * 200,
                (random.nextDouble() - 0.5) * 200,
              ),
              speed: Vector2(
                (random.nextDouble() - 0.5) * 400,
                (random.nextDouble() - 0.5) * 400,
              ),
              position: position.clone(),
              child: CircleParticle(
                radius: 2.0 + random.nextDouble() * 5.0,
                paint: Paint()..color = Colors.orangeAccent,
              ),
            );
          },
        ),
      ),
    );

    removeFromParent();
  }

  void shoot() {
    if (!_canShoot || overheated) {
      return;
    }
    _canShoot = false;
    Future.delayed(Duration(milliseconds: _fireRateMs), () {
      _canShoot = true;
    });

    // Build heat; warn near the top, lock out at 100.
    heat = (heat + _heatPerShot).clamp(0.0, 100.0);
    if (heat >= 80 && !_warnPlayed) {
      _warnPlayed = true;
      Sfx.play('overheat_warn', volume: 0.5);
    }
    if (heat >= 100) {
      overheated = true;
      _overheatTimer = _overheatLockout;
      Sfx.play('overheat_lock', volume: 0.6);
      HapticFeedback.heavyImpact();
      return;
    }

    Sfx.play('laser.wav', volume: 0.25);

    HapticFeedback.lightImpact();

    // Shoot recoil (knockback with return effect)
    add(MoveEffect.by(Vector2(0, 8), EffectController(duration: 0.05, alternate: true)));

    if (activeWeapon == PowerUpType.flutter) {
      // Dual lasers with spread based on level (2..6 streams, damage scales).
      int count = (2 + weaponLevel ~/ 2).clamp(2, 6);
      double spread = 18.0;
      double startX = -((count - 1) * spread) / 2;

      for (int i = 0; i < count; i++) {
        game.add(
          Projectile(
            startPosition: position.clone()
              ..translate(startX + (i * spread), -size.y / 2),
            direction: Vector2(0, -1),
            damage: 25.0 + weaponLevel * 2,
          )..basePaint = (Paint()..color = Colors.blueAccent),
        );
      }
    } else if (activeWeapon == PowerUpType.backend) {
      // Heavy slow AoE projectile (Rockets), 1..4 tubes.
      int count = (1 + weaponLevel ~/ 3).clamp(1, 4);
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
              ..basePaint = (Paint()..color = Colors.orangeAccent);
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
}
