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
  bool isPaused = false;

  // Kill-combo: consecutive kills within [comboWindow] raise the multiplier.
  int comboCount = 0;
  double comboTimer = 0;
  static const double comboWindow = 2.5;
  static const int maxComboMultiplier = 5;

  int get comboMultiplier => (1 + comboCount ~/ 8).clamp(1, maxComboMultiplier);
  double get comboProgress => (comboTimer / comboWindow).clamp(0.0, 1.0);

  AstroGame({required this.gameBloc});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await FlameAudio.audioCache.loadAll([
      'laser.wav', 'explosion.wav', 'laser_enemy.wav',
      'powerup.wav', 'hit.wav', 'gameover.wav', 'levelup.wav', 'bgm.wav'
    ]);

    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('bgm.wav', volume: 0.3);

    // Parallax background (generated layers + legacy space art fallback)
    add(StarfieldComponent());

    // Player
    player = PlayerEntity();
    add(player);
    add(ShootDetector(player));

    // Power-up spawner (was never started — fixed; cadence 5s not 10s)
    powerupSpawner = Timer(
      5.0,
      onTick: () {
        if (!gameBloc.state.entity.isGameOver && !isPaused) {
          add(PowerUpEntity());
        }
      },
      repeat: true,
    );
    powerupSpawner.start();
  }

  int currentLevel = 1;
  int wavesCleared = 0;
  double _meteorTimer = 0;

  LevelConfig get currentConfig => LevelConfig.getLevel(currentLevel);

  /// Central kill feed: applies combo multiplier then forwards score.
  void registerKill(int basePoints) {
    if (gameBloc.state.entity.isGameOver) return;
    comboCount++;
    comboTimer = comboWindow;
    gameBloc.add(GameEvent.scoreIncreased(basePoints * comboMultiplier));
  }

  void resetCombo() {
    comboCount = 0;
    comboTimer = 0;
  }

  void pause() {
    isPaused = true;
    FlameAudio.bgm.pause();
  }

  void resume() {
    isPaused = false;
    if (!gameBloc.state.entity.isGameOver) {
      FlameAudio.bgm.resume();
    }
  }

  /// Full run reset — fixes the old soft-lock where restart only reset
  /// the bloc while the dead player / leftover enemies stayed behind.
  Future<void> reset() async {
    for (final c in children
        .whereType<PositionComponent>()
        .toList(growable: false)) {
      // Keep the background; drop everything else.
      if (c is! StarfieldComponent) c.removeFromParent();
    }
    bossActive = false;
    isPaused = false;
    currentLevel = 1;
    wavesCleared = 0;
    _meteorTimer = 0;
    resetCombo();
    gameBloc.add(const GameEvent.gameRestarted());
    player = PlayerEntity();
    add(player);
    add(ShootDetector(player));
    powerupSpawner.start();
    await FlameAudio.bgm.stop();
    FlameAudio.bgm.play('bgm.wav', volume: 0.3);
  }

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

    if (gameBloc.state.entity.isGameOver || isPaused) return;

    // Combo decay
    if (comboCount > 0) {
      comboTimer -= dt;
      if (comboTimer <= 0) resetCombo();
    }

    // Meteors
    _meteorTimer += dt;
    if (_meteorTimer > 3.0) {
      _meteorTimer = 0;
      if (Random().nextDouble() < 0.6) {
        final meteor = MeteorEntity();
        bool fromSide = Random().nextBool();

        if (fromSide) {
          bool fromLeft = Random().nextBool();
          meteor.position = Vector2(fromLeft ? -50 : size.x + 50,
              Random().nextDouble() * (size.y / 2));
          meteor.velocity =
              Vector2(fromLeft ? 0.9 : -0.9, 0.45).normalized();
        } else {
          meteor.position = Vector2(Random().nextDouble() * size.x, -50);
          meteor.velocity =
              Vector2((Random().nextDouble() - 0.5) * 0.5, 1.0).normalized();
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
    if (gameBloc.state.entity.isGameOver || isPaused) return;
    if (!player.isMounted) return;
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
