import 'package:flame/components.dart';
import '../base/base_sprite_entity.dart';
import '../base/behaviors.dart';
import '../projectiles/projectile.dart';
import '../../../bloc/game_bloc.dart';

class PlayerEntity extends BaseSpriteEntity with HealthBehavior {
  late Timer shootTimer;

  PlayerEntity() : super(size: Vector2(64, 64), anchor: Anchor.center) {
    health = 100;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await loadAsset('hd_ship_sleek_1781686447510.jpg');
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

  void shoot() {
    // Spawns a projectile moving upwards
    final bullet = Projectile(
      startPosition: position.clone()..y -= size.y / 2,
      direction: Vector2(0, -1),
    );
    game.add(bullet);
  }

  @override
  void onDeath() {
    super.onDeath();
    game.gameBloc.add(const GameEvent.playerDamaged(100)); // Triggers game over
  }
}
