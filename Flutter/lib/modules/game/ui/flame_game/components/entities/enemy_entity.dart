import 'package:flame_audio/flame_audio.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';
import 'player_entity.dart';
import '../projectiles/projectile.dart';
import '../../../../logic/bloc/game_bloc.dart';

enum EnemyState { flyingIn, formation, swooping, returning }

class EnemyEntity extends BaseSpriteEntity with HealthBehavior {
  late Timer shootTimer;
  
  Vector2 formationPosition;
  EnemyState state = EnemyState.flyingIn;
  double _time = 0;
  Vector2 _velocity = Vector2.zero();
  double speed = 60.0;
  
  String assetName;

  EnemyEntity({
    required this.formationPosition,
    required Vector2 startPosition,
    this.assetName = 'hd_enemy_bug_1781686468572.png',
  }) : super(size: Vector2(48, 48), anchor: Anchor.center) {
    position = startPosition;
    health = 25;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await loadAsset(assetName);
    final random = Random();
    shootTimer = Timer(3.0 + random.nextDouble() * 4, onTick: shoot, repeat: true);
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
        
        // Randomly break formation and swoop!
        if (Random().nextDouble() < 0.002) { 
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
    FlameAudio.play('laser_enemy.wav', volume: 0.3);
    game.add(bullet);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerEntity) {
      // Enemy hits player
      other.takeDamage(20);
      game.gameBloc.add(const GameEvent.playerDamaged(20));
      removeFromParent(); // Destroy enemy
    }
  }

  @override
  void onDeath() {
    super.onDeath();
    HapticFeedback.lightImpact();
    FlameAudio.play('explosion.wav', volume: 0.5);
    game.gameBloc.add(const GameEvent.scoreIncreased(10));

    // Add simple particle explosion
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 0.5,
        generator: (i) => AcceleratedParticle(
          speed: Vector2(
            (Random().nextDouble() - 0.5) * 400,
            (Random().nextDouble() - 0.5) * 400,
          ),
          position: position.clone(),
          child: CircleParticle(
            radius: 2.5,
            paint: Paint()..color = Colors.orangeAccent,
          ),
        ),
      ),
    );
    game.add(particleComponent);
  }
}
