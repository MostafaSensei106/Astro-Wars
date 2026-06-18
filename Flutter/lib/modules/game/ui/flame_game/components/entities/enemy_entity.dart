import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';
import 'player_entity.dart';
import '../projectiles/projectile.dart';
import '../../../../logic/bloc/game_bloc.dart';

class EnemyEntity extends BaseSpriteEntity
    with MovementBehavior, HealthBehavior {
  late Timer shootTimer;

  EnemyEntity() : super(size: Vector2(48, 48), anchor: Anchor.center) {
    health = 25; // 1 shot to kill
    speed = 150.0;
    velocity = Vector2(0, 1); // Move downwards
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await loadAsset('hd_enemy_bug_1781686468572.jpg');
    final random = Random();
    position = Vector2(random.nextDouble() * game.size.x, -50);
    shootTimer = Timer(1.5 + random.nextDouble(), onTick: shoot, repeat: true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.gameBloc.state.entity.isGameOver) {
      shootTimer.update(dt);
    }
    if (position.y > game.size.y + 50) {
      removeFromParent();
    }
  }

  void shoot() {
    final bullet = Projectile(
      startPosition: position.clone()..y += size.y / 2,
      direction: Vector2(0, 1),
      damage: 10,
      isEnemyProjectile: true,
    );
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
