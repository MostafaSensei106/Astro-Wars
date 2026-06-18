import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import '../../logic/entities/level_config.dart';
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
      'powerup.wav', 'hit.wav', 'gameover.wav', 'levelup.wav', 'bgm.wav'
    ]);

    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('bgm.wav', volume: 0.3);

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

  LevelConfig get currentConfig => LevelConfig.getLevel(currentLevel);

  void spawnEnemyWave() {
    int rows = currentConfig.rows;
    int cols = currentConfig.cols;
    
    double paddingX = size.x / (cols + 1);
    double paddingY = 50.0;
    
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final formationPos = Vector2((c + 1) * paddingX, 60.0 + (r * paddingY));
        
        final startPos = Vector2(
          c % 2 == 0 ? -100 : size.x + 100, 
          -100 - (r * 150) - (c * 60)
        );
        
        final enemy = EnemyEntity(
          formationPosition: formationPos,
          startPosition: startPos,
          assetName: currentConfig.enemySprite
        );
        add(enemy);
      }
    }
  }

  void spawnBoss() {
    bossActive = true;
    add(BossEntity());
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
        final meteor = MeteorEntity();
        bool fromSide = Random().nextBool();
        
        if (fromSide) {
          bool fromLeft = Random().nextBool();
          meteor.position = Vector2(fromLeft ? -50 : size.x + 50, Random().nextDouble() * (size.y / 2));
          meteor.velocity = Vector2((fromLeft ? 1 : -1) * meteor.speed, meteor.speed * 0.5); 
        } else {
          meteor.position = Vector2(Random().nextDouble() * size.x, -50);
          meteor.velocity = Vector2((Random().nextDouble() - 0.5) * 50, meteor.speed);
        }
        
        add(meteor);
      }
    }

    final enemies = children.whereType<EnemyEntity>().toList();
    final bosses = children.whereType<BossEntity>().toList();

    if (bossActive && bosses.isEmpty) {
      // Boss defeated! Level Up!
      FlameAudio.play('levelup.wav', volume: 0.7);
      bossActive = false;
      currentLevel++;
      wavesCleared = 0;
      gameBloc.add(const GameEvent.scoreIncreased(1000)); // Level clear bonus
    }

    if (enemies.isEmpty && !bossActive) {
      if (wavesCleared >= currentConfig.wavesBeforeBoss) {
        spawnBoss();
        wavesCleared = 0;
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
