import '../../../../../../core/utils/theme/astro_design.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';
import 'player_entity.dart';
import 'commit_entity.dart';
import '../projectiles/projectile.dart';
import '../particles/fx.dart';

enum EnemyState { flyingIn, formation, swooping, returning }

class EnemyEntity extends BaseSpriteEntity with HealthBehavior {
  late Timer shootTimer;

  /// Per-type tuning: (hp, base speed, shoot min/max seconds, swoop chance).
  /// Tanks shoot often but crawl; chicks dive constantly; UFOs strafe-fire.
  static const Map<String, (int, double, double, double, double)> stats = {
    'enemy_bug.png': (25, 60.0, 3.0, 7.0, 0.002),
    'enemy_noodle.png': (25, 60.0, 3.0, 7.0, 0.002),
    'enemy_chick.png': (15, 90.0, 5.0, 9.0, 0.008),
    'enemy_ufo.png': (40, 48.0, 1.5, 3.0, 0.001),
    'enemy_crab.png': (70, 38.0, 4.0, 8.0, 0.001),
    'enemy_jelly.png': (20, 42.0, 4.0, 9.0, 0.002),
    'enemy_metal.png': (100, 42.0, 2.0, 4.0, 0.001),
    'enemy_ghost.png': (30, 72.0, 3.0, 6.0, 0.004),
  };

  Vector2 formationPosition;
  EnemyState state = EnemyState.flyingIn;
  double _time = 0;
  Vector2 _velocity = Vector2.zero();
  double speed = 60.0;
  double _swoopChance = 0.002;

  String assetName;

  EnemyEntity({
    required this.formationPosition,
    required Vector2 startPosition,
    this.assetName = 'enemy_bug.png',
  }) : super(size: Vector2(48, 48), anchor: Anchor.center) {
    position = startPosition;
    final s = stats[assetName] ?? stats['enemy_bug.png']!;
    health = s.$1;
    speed = s.$2;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // NOTE: load the per-wave sprite, not the sector default.
    await loadAsset(assetName);
    final s = stats[assetName] ?? stats['enemy_bug.png']!;
    speed *= game.currentConfig.enemySpeedMultiplier * game.waveSpeedMult;
    _swoopChance = s.$5;

    final random = Random();
    shootTimer = Timer(s.$3 + random.nextDouble() * (s.$4 - s.$3),
        onTick: shoot, repeat: true);
  }

  @override
  void takeDamage(int amount) {
    super.takeDamage(amount);
    // Knockback on hit
    position.y -= 20; // Increased knockback
    position.x += (Random().nextDouble() - 0.5) * 15;

    // Flash effect
    add(
      ColorEffect(
        Colors.white,
        EffectController(duration: 0.1, alternate: true),
        opacityTo: 0.8,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    if (!game.gameBloc.state.entity.isGameOver) {
      shootTimer.update(dt);
    }

    switch (state) {
      case EnemyState.flyingIn:
        Vector2 dir = formationPosition - position;
        if (dir.length < 5.0) {
          position = formationPosition.clone();
          state = EnemyState.formation;
        } else {
           dir.normalize();
           _velocity = dir * 250.0;
           // Add dramatic swooping loop effect during spawn
           _velocity.x += sin(_time * 6) * 200;
           position.add(_velocity * dt);
           _updateRotation();
        }
        break;

      case EnemyState.formation:
        // Bobbing in place
        position.x = formationPosition.x + sin(_time * 2) * 20;
        position.y = formationPosition.y + cos(_time * 3) * 10;
        angle = pi; // Point straight down when in formation
        
        // Randomly break formation and swoop (per-type appetite)!
        if (Random().nextDouble() < _swoopChance) { 
           state = EnemyState.swooping;
           _velocity = Vector2(0, -150); // slight jump back before diving
        }
        break;

      case EnemyState.swooping:
        _velocity.y += 350 * dt; // gravity/acceleration
        final player = game.children.whereType<PlayerEntity>().firstOrNull;
        if (player != null) {
          if (player.position.x > position.x) {
            _velocity.x += 150 * dt;
          } else {
            _velocity.x -= 150 * dt;
          }
        }
        position.add(_velocity * dt);
        _updateRotation();

        // If off screen bottom, wrap to top and return
        if (position.y > game.size.y + 50) {
           position.y = -50;
           state = EnemyState.returning;
        }
        break;

      case EnemyState.returning:
        Vector2 dir = formationPosition - position;
        if (dir.length < 10.0) {
          position = formationPosition.clone();
          state = EnemyState.formation;
        } else {
           dir.normalize();
           _velocity = dir * 300.0;
           position.add(_velocity * dt);
           _updateRotation();
        }
        break;
    }

    if (position.y > game.size.y + 50 && state != EnemyState.swooping) {
      removeFromParent();
    }
  }

  void _updateRotation() {
    angle = atan2(_velocity.y, _velocity.x) + pi/2;
  }

  void shoot() {
    if (state == EnemyState.flyingIn) return; // Don't shoot while spawning
    
    final bullet = Projectile(
      startPosition: position.clone()..y += size.y / 2,
      direction: Vector2(0, 1),
      isEnemyProjectile: true,
      damage: 20.0,
    );
    Sfx.play('laser_enemy.wav', volume: 0.3);
    game.add(bullet);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerEntity) {
      // Ramming: single point of damage. PlayerEntity.takeDamage already
      // forwards one GameEvent.playerDamaged(1) to the bloc — do NOT emit
      // a second event here (that caused instant-death double damage).
      other.takeDamage(1);
      removeFromParent(); // Destroy enemy
    }
  }

  @override
  void onDeath() {
    super.onDeath();
    HapticFeedback.lightImpact();
    game.registerKill(10);

    // Hull breakup: tumbling metal shards tinted by enemy type.
    final debrisColor = assetName.contains('noodle')
        ? const Color(0xFFFFAA28)
        : assetName.contains('ghost') || assetName.contains('ufo')
            ? const Color(0xFF3CE6FF)
            : const Color(0xFF9AA2B5);
    Fx.debris(game, position.clone(), debrisColor);
    // Drumstick economy: 60% chance to drop a commit pickup.
    if (Random().nextDouble() < 0.6) {
      game.add(CommitEntity(startPosition: position.clone()));
    }
  }
}
