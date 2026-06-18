import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';
import 'player_entity.dart';
import '../projectiles/projectile.dart';
import '../../../../logic/bloc/game_bloc.dart';

class BossEntity extends BaseSpriteEntity with MovementBehavior, HealthBehavior {
  late Timer shootTimer;
  int direction = 1;

  BossEntity() : super(size: Vector2(150, 150), anchor: Anchor.center) {
    health = 500; // Big health
    speed = 80.0;
    velocity = Vector2(1, 0); // Move side to side
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Random boss sprite
    final rand = Random().nextBool();
    final spriteName = rand ? 'hd_boss_car_1781686478720.jpg' : 'hd_boss_professor_1781686774890.jpg';
    await loadAsset(spriteName);
    
    position = Vector2(game.size.x / 2, 150);
    shootTimer = Timer(1.0, onTick: shoot, repeat: true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.gameBloc.state.entity.isGameOver) {
      shootTimer.update(dt);
    }
    
    // Bounce side to side
    if (position.x > game.size.x - size.x / 2) {
      velocity.x = -1;
    } else if (position.x < size.x / 2) {
      velocity.x = 1;
    }
  }

  void shoot() {
    // Spread shot
    for (int i = -1; i <= 1; i++) {
      final bullet = Projectile(
        startPosition: position.clone()..y += size.y / 2,
        direction: Vector2(i * 0.5, 1).normalized(),
        damage: 15,
        isEnemyProjectile: true,
      );
      game.add(bullet);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerEntity) {
      other.takeDamage(50);
      game.gameBloc.add(const GameEvent.playerDamaged(50));
    }
  }

  @override
  void onDeath() {
    super.onDeath();
    HapticFeedback.heavyImpact();
    game.gameBloc.add(const GameEvent.scoreIncreased(200));
    game.bossActive = false; // Notify game boss is dead
    
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 100,
        lifespan: 1.5,
        generator: (i) => AcceleratedParticle(
          speed: Vector2((Random().nextDouble() - 0.5) * 800, (Random().nextDouble() - 0.5) * 800),
          position: position.clone(),
          child: CircleParticle(radius: 4.0, paint: Paint()..color = Colors.redAccent),
        ),
      ),
    );
    game.add(particleComponent);
  }
}
