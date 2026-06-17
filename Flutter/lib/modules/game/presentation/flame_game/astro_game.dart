import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import '../bloc/game_bloc.dart';
import 'components/player_ship.dart';
import 'components/enemy_bug.dart';

class AstroGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  final GameBloc gameBloc;

  AstroGame({required this.gameBloc});

  late PlayerShip player;
  double enemySpawnTimer = 0.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Setup BLoC provider for Flame
    final blocProvider = FlameBlocProvider<GameBloc, GameState>.value(
      value: gameBloc,
      children: [player = PlayerShip()],
    );

    await add(blocProvider);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameBloc.state.entity.isGameOver) return;

    // Simple enemy spawner
    enemySpawnTimer += dt;
    if (enemySpawnTimer > 2.0) {
      enemySpawnTimer = 0.0;
      add(EnemyBug());
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!gameBloc.state.entity.isGameOver) {
      // Logic for shooting can go here
      // e.g., player.shoot();
      gameBloc.add(const GameEvent.scoreIncreased(10));
    }
  }
}
