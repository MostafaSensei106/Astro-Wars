import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/effects.dart';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';
import 'player_entity.dart';
import '../projectiles/projectile.dart';
import '../../../../logic/bloc/game_bloc.dart';

class BossEntity extends BaseSpriteEntity
    with MovementBehavior, HealthBehavior {
  late Timer shootTimer;
  int direction = 1;
  final int maxHealth = 500;

  BossEntity() : super(size: Vector2(150, 150), anchor: Anchor.center) {
    health = maxHealth; // Big health
    speed = 80.0;
    velocity = Vector2(1, 0); // Move side to side
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await loadAsset(game.currentConfig.bossSprite);

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
    FlameAudio.play('laser_enemy.wav', volume: 0.4);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw Health Bar
    final double healthPercent = (health / maxHealth).clamp(0.0, 1.0);
    final double barWidth = size.x;
    const double barHeight = 12.0;
    const double offsetY = -25.0; // Above the boss

    // Background (Red)
    final bgPaint = Paint()..color = Colors.redAccent.withValues(alpha: 0.6);
    final bgRect = Rect.fromLTWH(0, offsetY, barWidth, barHeight);
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(6)), bgPaint);

    // Foreground (Green)
    final fgPaint = Paint()..color = Colors.greenAccent;
    final fgRect = Rect.fromLTWH(0, offsetY, barWidth * healthPercent, barHeight);
    canvas.drawRRect(RRect.fromRectAndRadius(fgRect, const Radius.circular(6)), fgPaint);

    // Percentage Text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(healthPercent * 100).toInt()}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(blurRadius: 2, color: Colors.black)],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(barWidth / 2 - textPainter.width / 2, offsetY + barHeight / 2 - textPainter.height / 2),
    );
  }

  @override
  void takeDamage(int amount) {
    super.takeDamage(amount);
    
    // Slight knockback
    position.y -= 5;

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
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
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
    FlameAudio.play('explosion.wav', volume: 0.8);
    game.gameBloc.add(const GameEvent.scoreIncreased(200));
    game.bossActive = false; // Notify game boss is dead

    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 100,
        lifespan: 1.5,
        generator: (i) => AcceleratedParticle(
          speed: Vector2(
            (Random().nextDouble() - 0.5) * 800,
            (Random().nextDouble() - 0.5) * 800,
          ),
          position: position.clone(),
          child: CircleParticle(
            radius: 4.0,
            paint: Paint()..color = Colors.redAccent,
          ),
        ),
      ),
    );
    game.add(particleComponent);
  }
}
