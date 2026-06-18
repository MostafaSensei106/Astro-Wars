import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import '../../logic/bloc/game_bloc.dart';
import 'components/entities/player_entity.dart';
import 'components/entities/enemy_entity.dart';
import 'components/entities/boss_entity.dart';
import 'components/entities/powerup_entity.dart';

class ShootDetector extends PositionComponent with TapCallbacks {
  final PlayerEntity player;
  ShootDetector(this.player);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.shoot();
  }
}

class AstroGame extends FlameGame with HasCollisionDetection, PanDetector {
  final GameBloc gameBloc;

  AstroGame({required this.gameBloc});

  late PlayerEntity player;
  late Timer powerupSpawner;
  bool bossActive = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Setup BLoC provider for Flame
    final blocProvider = FlameBlocProvider<GameBloc, GameState>.value(
      value: gameBloc,
      children: [player = PlayerEntity()],
    );

    await add(blocProvider);
    await add(ShootDetector(player));

    powerupSpawner = Timer(
      10.0,
      onTick: () {
        if (!gameBloc.state.entity.isGameOver) {
          add(PowerUpEntity());
        }
      },
      repeat: true,
    );
  }

  void spawnEnemyWave() {
    int rows = 3;
    int cols = 5;
    double paddingX = size.x / (cols + 1);
    double paddingY = 60.0;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final enemy = EnemyEntity()
          ..position = Vector2((c + 1) * paddingX, -150 + (r * paddingY))
          ..targetHoverY = 50.0 + (r * paddingY);
        add(enemy);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameBloc.state.entity.isGameOver) return;

    final enemies = children.whereType<EnemyEntity>();
    if (enemies.isEmpty && !bossActive) {
      if (gameBloc.state.entity.score > 0 &&
          gameBloc.state.entity.score % 500 == 0) {
        bossActive = true;
        add(BossEntity());
      } else {
        spawnEnemyWave();
      }
    }

    powerupSpawner.update(dt);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!gameBloc.state.entity.isGameOver) {
      player.position.add(info.delta.global);

      // Screen wrapping horizontally
      if (player.position.x > size.x + player.size.x / 2) {
        player.position.x = -player.size.x / 2;
      } else if (player.position.x < -player.size.x / 2) {
        player.position.x = size.x + player.size.x / 2;
      }

      // Keep player inside screen vertically
      player.position.y = player.position.y.clamp(
        player.size.y / 2,
        size.y - player.size.y / 2,
      );
    }
  }
}
