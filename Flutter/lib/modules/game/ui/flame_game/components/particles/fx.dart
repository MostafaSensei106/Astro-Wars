import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../astro_game.dart';
import '../../../../../../core/constants/assets_images.dart';
import '../../../../../../core/utils/theme/astro_design.dart';

/// Cartoon particle kit (CI-inspired): feathers, splats, rings, puffs.
///
/// All effects are tiny self-animating components — no extra packages.
/// Usage: `Fx.feathers(game, position, Colors.green)`.
abstract final class Fx {
  static final _rnd = Random();

  /// Metal debris burst for kills + dull clang.
  static void debris(
    AstroGame game,
    Vector2 pos,
    Color color, {
    int count = 12,
  }) {
    for (int i = 0; i < count; i++) {
      game.add(
        _Shard(
          position: pos.clone(),
          color: color,
          velocity: Vector2(
            (_rnd.nextDouble() - 0.5) * 380,
            (_rnd.nextDouble() - 0.7) * 380,
          ),
        ),
      );
    }
    Sfx.play(AssetsAudio.hit, volume: 0.45);
  }

  /// Egg splat: yolk + white blob that sticks briefly.
  static void splat(AstroGame game, Vector2 pos) {
    game.add(_Splat(position: pos.clone()));
    Sfx.play('egg_splat', volume: 0.5);
  }

  /// Expanding shockwave ring (boss kills, gift pickups, missiles).
  static void ring(
    AstroGame game,
    Vector2 pos,
    Color color, {
    double maxRadius = 120,
    double lifespan = 0.5,
  }) {
    game.add(
      _Ring(
        position: pos.clone(),
        color: color,
        maxRadius: maxRadius,
        lifespan: lifespan,
      ),
    );
  }

  /// Soft smoke puff (meteors, damage, exhaust).
  static void smoke(
    AstroGame game,
    Vector2 pos,
    Color color, {
    int count = 8,
    double size = 6,
  }) {
    for (int i = 0; i < count; i++) {
      game.add(
        _Puff(
          position: pos.clone()
            ..add(
              Vector2(
                (_rnd.nextDouble() - 0.5) * 20,
                (_rnd.nextDouble() - 0.5) * 20,
              ),
            ),
          color: color,
          size: size * (0.6 + _rnd.nextDouble() * 0.8),
          velocity: Vector2(
            (_rnd.nextDouble() - 0.5) * 120,
            -40 - _rnd.nextDouble() * 80,
          ),
        ),
      );
    }
  }

  /// Sparkle for pickups.
  static void sparkle(
    AstroGame game,
    Vector2 pos,
    Color color, {
    int count = 10,
  }) {
    for (int i = 0; i < count; i++) {
      final a = _rnd.nextDouble() * 2 * pi;
      game.add(
        _Spark(
          position: pos.clone(),
          color: color,
          velocity: Vector2(cos(a), sin(a)) * (60 + _rnd.nextDouble() * 140),
        ),
      );
    }
  }

  /// Engine trail tick (call throttled, ~12/s).
  static void trail(AstroGame game, Vector2 pos, Color color) {
    game.add(
      _Puff(
        position: pos.clone(),
        color: color,
        size: 4,
        velocity: Vector2(
          (_rnd.nextDouble() - 0.5) * 30,
          90 + _rnd.nextDouble() * 40,
        ),
        lifespan: 0.35,
      ),
    );
  }
}

/// Tumbling angular hull shard.
class _Shard extends PositionComponent with HasGameReference<AstroGame> {
  final Color color;
  Vector2 velocity;
  final double lifespan = 0.7;
  double age = 0;
  final double spin;
  final double shardSize;

  _Shard({required super.position, required this.color, required this.velocity})
    : spin = (Random().nextDouble() - 0.5) * 14,
      shardSize = 4 + Random().nextDouble() * 6,
      super(anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    age += dt;
    if (age >= lifespan) {
      removeFromParent();
      return;
    }
    velocity.y += 300 * dt; // gravity
    velocity *= (1 - 1.4 * dt); // drag
    position.add(velocity * dt);
    angle += spin * dt;
  }

  @override
  void render(Canvas canvas) {
    final t = age / lifespan;
    final paint = Paint()..color = color.withValues(alpha: 1 - t);
    canvas.save();
    canvas.translate(0, 0);
    canvas.rotate(angle);
    final path = Path()
      ..moveTo(0, -shardSize)
      ..lineTo(shardSize * 0.8, shardSize * 0.7)
      ..lineTo(-shardSize * 0.8, shardSize * 0.4)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: (1 - t) * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.restore();
  }
}

/// Sticky egg splat: yolk + irregular white, fades in place.
class _Splat extends PositionComponent with HasGameReference<AstroGame> {
  double age = 0;
  final double lifespan = 0.9;
  late final List<Vector2> _blob;

  _Splat({required super.position})
    : super(size: Vector2(36, 36), anchor: Anchor.center) {
    final rnd = Random();
    _blob = List.generate(8, (i) {
      final a = (i / 8) * 2 * pi;
      final r = 12 + rnd.nextDouble() * 6;
      return Vector2(cos(a) * r, sin(a) * r);
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    age += dt;
    if (age >= lifespan) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final t = (age / lifespan).clamp(0.0, 1.0);
    final alpha = t < 0.7 ? 1.0 : 1 - (t - 0.7) / 0.3;
    final c = Offset(size.x / 2, size.y / 2);
    final path = Path()..moveTo(c.dx + _blob[0].x, c.dy + _blob[0].y);
    for (int i = 1; i < _blob.length; i++) {
      path.lineTo(c.dx + _blob[i].x, c.dy + _blob[i].y);
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()..color = Colors.white.withValues(alpha: 0.85 * alpha),
    );
    canvas.drawCircle(
      c,
      6,
      Paint()..color = const Color(0xFFFFC233).withValues(alpha: alpha),
    );
    canvas.drawCircle(
      c + const Offset(-2, -2),
      2,
      Paint()..color = Colors.white.withValues(alpha: alpha),
    );
  }
}

/// Expanding shockwave ring.
class _Ring extends PositionComponent with HasGameReference<AstroGame> {
  final Color color;
  final double maxRadius;
  final double lifespan;
  double age = 0;

  _Ring({
    required super.position,
    required this.color,
    required this.maxRadius,
    required this.lifespan,
  }) : super(anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    age += dt;
    if (age >= lifespan) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final t = (age / lifespan).clamp(0.0, 1.0);
    final r = maxRadius * (1 - (1 - t) * (1 - t)); // ease-out
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..color = color.withValues(alpha: (1 - t) * 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 * (1 - t) + 1
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }
}

/// Soft growing/fading smoke puff.
class _Puff extends PositionComponent with HasGameReference<AstroGame> {
  final Color color;
  final Vector2 velocity;
  final double lifespan;
  final double startSize;
  double age = 0;

  _Puff({
    required super.position,
    required this.color,
    required double size,
    required this.velocity,
    this.lifespan = 0.6,
  }) : startSize = size,
       super(size: Vector2.all(size * 2), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    age += dt;
    if (age >= lifespan) {
      removeFromParent();
      return;
    }
    position.add(velocity * dt);
  }

  @override
  void render(Canvas canvas) {
    final t = (age / lifespan).clamp(0.0, 1.0);
    final r = startSize * (0.6 + t * 1.2);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      r,
      Paint()..color = color.withValues(alpha: (1 - t) * 0.55),
    );
  }
}

/// Fast fading spark (pickups, hits).
class _Spark extends PositionComponent with HasGameReference<AstroGame> {
  final Color color;
  Vector2 velocity;
  double age = 0;
  final double lifespan = 0.4;

  _Spark({required super.position, required this.color, required this.velocity})
    : super(size: Vector2.all(6), anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    age += dt;
    if (age >= lifespan) {
      removeFromParent();
      return;
    }
    velocity *= (1 - 3 * dt);
    position.add(velocity * dt);
  }

  @override
  void render(Canvas canvas) {
    final t = (age / lifespan).clamp(0.0, 1.0);
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      3 * (1 - t) + 0.5,
      Paint()
        ..color = Colors.white.withValues(alpha: 1 - t)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      1.5,
      Paint()..color = color.withValues(alpha: 1 - t),
    );
  }
}
