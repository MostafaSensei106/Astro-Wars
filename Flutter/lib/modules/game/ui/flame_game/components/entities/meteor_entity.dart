import '../../../../../../core/constants/assets_images.dart';
import '../../../../../../core/utils/theme/astro_design.dart';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../base/behaviors.dart';
import 'player_entity.dart';
import '../../astro_game.dart';
import '../particles/fx.dart';

class MeteorEntity extends PositionComponent
    with
        MovementBehavior,
        HealthBehavior,
        HasGameReference<AstroGame>,
        CollisionCallbacks {
  late List<Vector2> _vertices;
  double rotSpeed = 0;
  Color meteorColor = const Color(0xFF4A3C31);

  MeteorEntity() : super(anchor: Anchor.center) {
    final random = Random();
    size = Vector2.all(
      30 + random.nextDouble() * 50,
    ); // Random size between 30 and 80
    health = (size.x).toInt(); // Health based on size

    // NOTE: MovementBehavior moves by velocity * speed * dt, so velocity
    // must be a unit-ish direction — never pre-scaled by speed.
    speed = 40.0 + random.nextDouble() * 50;
    velocity = Vector2((random.nextDouble() - 0.5) * 0.6, 1.0).normalized();
    rotSpeed = (random.nextDouble() - 0.5) * 2;

    // Randomize color slightly
    final colors = [
      const Color(0xFF4A3C31),
      const Color(0xFF5A4D41),
      const Color(0xFF3A2E25),
      const Color(0xFF2A2A2A),
    ];
    meteorColor = colors[random.nextInt(colors.length)];

    _generateShape();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Add hitbox matching the size
    add(PolygonHitbox(_vertices));
  }

  void _generateShape() {
    _vertices = [];
    final random = Random();
    int points = 6 + random.nextInt(4); // 6 to 9 edges
    for (int i = 0; i < points; i++) {
      double angle = (i / points) * 2 * pi;
      double r =
          (size.x / 2) * (0.6 + random.nextDouble() * 0.4); // Irregular radius
      _vertices.add(
        Vector2(size.x / 2 + r * cos(angle), size.y / 2 + r * sin(angle)),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt); // MovementBehavior already advances position
    angle += rotSpeed * dt;

    if (position.y > game.size.y + 100 ||
        position.x < -100 ||
        position.x > game.size.x + 100) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final path = Path();
    path.moveTo(_vertices[0].x, _vertices[0].y);
    for (int i = 1; i < _vertices.length; i++) {
      path.lineTo(_vertices[i].x, _vertices[i].y);
    }
    path.close();

    // Fill
    final fillPaint = Paint()..color = meteorColor;
    canvas.drawPath(path, fillPaint);

    // Hot edges (atmospheric entry friction) — plain double stroke.
    final strokePaint = Paint()
      ..color = Colors.deepOrangeAccent.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, strokePaint);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerEntity) {
      // Hit player!
      other.takeDamage(1);
      // Meteor takes huge damage from crashing into ship
      takeDamage(100);
    }
  }

  @override
  void takeDamage(int amount) {
    super.takeDamage(amount);

    // Knockback/stutter
    position.y -= 5;

    if (health <= 0) {
      onDeath();
      removeFromParent();
    }
  }

  @override
  void onDeath() {
    super.onDeath();
    HapticFeedback.mediumImpact();
    Sfx.play(AssetsAudio.explosion, volume: 0.6);
    game.registerKill((size.x).toInt());

    // Rocky breakup: smoke + tumbling debris.
    Fx.smoke(game, position.clone(), meteorColor, count: 8, size: size.x / 6);
    Fx.debris(game, position.clone(), const Color(0xFF8A7A6A), count: 8);
  }
}
