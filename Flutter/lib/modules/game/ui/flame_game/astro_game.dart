import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'components/background/starfield.dart';
import 'components/entities/player_entity.dart';
import 'components/entities/enemy_entity.dart';
import 'components/entities/boss_entity.dart';
import 'components/entities/meteor_entity.dart';
import 'components/entities/powerup_entity.dart';
import '../../logic/bloc/game_bloc.dart';

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

class AstroGame extends FlameGame with PanDetector, HasCollisionDetection {
  final GameBloc gameBloc;
  late PlayerEntity player;
  late Timer powerupSpawner;
  bool bossActive = false;

  AstroGame({required this.gameBloc});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await FlameAudio.audioCache.loadAll([
      'laser.wav', 'explosion.wav', 'laser_enemy.wav', 
      'powerup.wav', 'hit.wav', 'gameover.wav', 'levelup.wav'
    ]);

    // Background
    add(StarfieldComponent());

    // Player
    player = PlayerEntity();
    add(player);
    add(ShootDetector(player));

    // Spawner
    powerupSpawner = Timer(
      10.0,
      onTick: () {
        if (!gameBloc.state.entity.isGameOver) add(PowerUpEntity());
      },
      repeat: true,
    );
  }



  int currentLevel = 1;
  int wavesCleared = 0;
  double _meteorTimer = 0;

  void spawnEnemyWave() {
    int rows = min(4, 1 + (currentLevel ~/ 2)); // 1 to 4 rows
    int cols = min(8, 4 + (currentLevel % 3));
    
    double paddingX = size.x / (cols + 1);
    double paddingY = 50.0;
    
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final formationPos = Vector2((c + 1) * paddingX, 60.0 + (r * paddingY));
        
        // Spawn them in a chain from top left or top right
        // The delay creates the "chain" effect visually as they follow the sine curve
        final startPos = Vector2(
          c % 2 == 0 ? -100 : size.x + 100, 
          -100 - (r * 150) - (c * 60)
        );
        
        final enemy = EnemyEntity(
          formationPosition: formationPos,
          startPosition: startPos,
          assetName: currentLevel % 2 == 0 ? 'hd_enemy_spaghetti_1781686763386.png' : 'hd_enemy_bug_1781686468572.png'
        );
        add(enemy);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameBloc.state.entity.isGameOver) return;

    // Meteors
    _meteorTimer += dt;
    if (_meteorTimer > 3.0) {
      _meteorTimer = 0;
      if (Random().nextDouble() < 0.6) {
        add(
          MeteorEntity()
            ..position = Vector2(Random().nextDouble() * size.x, -50),
        );
      }
    }

    final enemies = children.whereType<EnemyEntity>();
    final bosses = children.whereType<BossEntity>();

    if (bossActive && bosses.isEmpty) {
      // Boss defeated! Level Up!
      FlameAudio.play('levelup.wav', volume: 0.7);
      bossActive = false;
      currentLevel++;
      wavesCleared = 0;
      gameBloc.add(const GameEvent.scoreIncreased(1000)); // Level clear bonus
    }

    if (enemies.isEmpty && !bossActive) {
      if (wavesCleared >= 3) {
        // 3 waves per level
        bossActive = true;
        add(BossEntity());
      } else {
        spawnEnemyWave();
        wavesCleared++;
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
