import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/timer.dart';
import 'package:flame_bloc/flame_bloc.dart';
import '../../logic/bloc/game_bloc.dart';
import 'components/entities/player_entity.dart';
import 'components/entities/enemy_entity.dart';
import 'components/entities/boss_entity.dart';
import 'components/entities/powerup_entity.dart';

class AstroGame extends FlameGame with HasCollisionDetection, PanDetector {
  final GameBloc gameBloc;

  AstroGame({required this.gameBloc});

  late PlayerEntity player;
  late Timer enemySpawner;
  late Timer powerupSpawner;
  double currentSpawnInterval = 2.0;
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

    powerupSpawner = Timer(
      10.0,
      onTick: () {
        if (!gameBloc.state.entity.isGameOver) {
          add(PowerUpEntity());
        }
      },
      repeat: true,
    );

    enemySpawner = Timer(
      currentSpawnInterval,
      onTick: () {
        if (!gameBloc.state.entity.isGameOver && !bossActive) {
          if (gameBloc.state.entity.score > 0 && gameBloc.state.entity.score % 500 == 0) {
            bossActive = true;
            add(BossEntity());
          } else {
            add(EnemyEntity());
          }
        }
      },
      repeat: true,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameBloc.state.entity.isGameOver) return;

    // Difficulty scaling: reduce spawn interval based on score
    final score = gameBloc.state.entity.score;
    // Every 100 points, reduce by 0.2s, down to a minimum of 0.5s
    double newInterval = (2.0 - (score / 100) * 0.2).clamp(0.5, 2.0);

    if (newInterval != currentSpawnInterval) {
      currentSpawnInterval = newInterval;
      enemySpawner.limit = currentSpawnInterval;
    }

    enemySpawner.update(dt);
    powerupSpawner.update(dt);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!gameBloc.state.entity.isGameOver) {
      player.position.add(Vector2(info.delta.global.x, 0));
      // Keep player inside screen
      player.position.x = player.position.x.clamp(
        player.size.x / 2,
        size.x - player.size.x / 2,
      );
      // Disabled Y movement to match classic space shooters
    }
  }
}
