import 'package:flame_audio/flame_audio.dart';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';
import '../projectiles/projectile.dart';
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
  PowerUpType? activeWeapon;
  int weaponLevel = 1;
  bool hasShield = false;
  ShieldForcefield? shieldComponent;
  bool _canShoot = true;
  int _fireRateMs = 250;

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
        prefs.getString('selected_ship') ?? 'hd_ship_sleek_1781686447510.png';
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
  }

  void _spawnEngineParticles() {
    final random = Random();
    game.add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 3,
          lifespan: 0.2,
          generator: (i) {
            return AcceleratedParticle(
              acceleration: Vector2(0, 300),
              speed: Vector2(
                (random.nextDouble() - 0.5) * 40,
                50 + random.nextDouble() * 50,
              ),
              position: position.clone()
                ..translate((random.nextDouble() - 0.5) * 20, size.y / 2 - 5),
              child: CircleParticle(
                radius: 1.5 + random.nextDouble() * 2.0,
                paint: Paint()
                  ..color = Colors.cyanAccent.withValues(alpha: 0.8),
              ),
            );
          },
        ),
      ),
    );
  }

  void _spawnSmokeParticles() {
    final random = Random();
    game.add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 2,
          lifespan: 0.5,
          generator: (i) {
            return AcceleratedParticle(
              acceleration: Vector2((random.nextDouble() - 0.5) * 100, -100),
              speed: Vector2((random.nextDouble() - 0.5) * 20, -50),
              position: position.clone()
                ..translate(
                  (random.nextDouble() - 0.5) * 30,
                  (random.nextDouble() - 0.5) * 30,
                ),
              child: CircleParticle(
                radius: 2.0 + random.nextDouble() * 3.0,
                paint: Paint()..color = Colors.black54,
              ),
            );
          },
        ),
      ),
    );
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

    // Lose a weapon level on hit
    if (weaponLevel > 1) {
      weaponLevel--;
    } else {
      activeWeapon = null; // lose weapon entirely
    }

    FlameAudio.play('hit.wav', volume: 0.5);
    // Knockback
    position.add(Vector2((Random().nextDouble() - 0.5) * 40, 30));

    health -= 1; // 1 Heart
    game.gameBloc.add(const GameEvent.playerDamaged(1));
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
    FlameAudio.play('gameover.wav', volume: 0.8);

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
    if (!_canShoot) {
      return;
    }
    _canShoot = false;
    Future.delayed(Duration(milliseconds: _fireRateMs), () {
      _canShoot = true;
    });

    FlameAudio.play('laser.wav', volume: 0.25);

    HapticFeedback.lightImpact();

    // Shoot recoil (knockback)
    position.y = (position.y + 10).clamp(size.y / 2, game.size.y - size.y / 2);

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
          )..basePaint = (Paint()..color = Colors.blueAccent),
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
