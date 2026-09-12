import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import '../../logic/entities/level_config.dart';
import 'components/background/starfield.dart';
import 'components/entities/player_entity.dart';
import 'components/entities/enemy_entity.dart';
import 'components/entities/boss_entity.dart';
import 'components/entities/meteor_entity.dart';
import 'components/entities/powerup_entity.dart';
import 'components/particles/fx.dart';
import '../../logic/bloc/game_bloc.dart';
import '../../logic/entities/mission.dart';
import '../../../../core/utils/theme/astro_design.dart';
import '../../../../core/constants/assets_images.dart';

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
  final int startLevel;
  late PlayerEntity player;
  late Timer powerupSpawner;
  bool bossActive = false;
  bool isPaused = false;

  // Kill-combo: consecutive kills within [comboWindow] raise the multiplier.
  int comboCount = 0;
  double comboTimer = 0;
  static const double comboWindow = 2.5;
  static const int maxComboMultiplier = 5;

  void _playTrack(String file) {
    if (!Sfx.bgmEnabled) return;
    FlameAudio.bgm.stop();
    FlameAudio.bgm.play(file, volume: 0.3);
  }

  void _playMissionMusic() => _playTrack(AssetsAudio.bgmMission);
  void _playBossMusic() => _playTrack(AssetsAudio.bgmBoss);

  int get comboMultiplier => (1 + comboCount ~/ 8).clamp(1, maxComboMultiplier);
  double get comboProgress => (comboTimer / comboWindow).clamp(0.0, 1.0);

  AstroGame({required this.gameBloc, this.startLevel = 1});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    currentLevel = startLevel;
    await Sfx.loadFromPrefs();
    await FlameAudio.audioCache.loadAll(AssetsAudio.preload);

    FlameAudio.bgm.initialize();
    _mission = await SectorMission.load(startLevel);
    _playMissionMusic();
    showBanner('SECTOR $startLevel', seconds: 2.5);

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
  double _meteorTimer = 0;

  // --- Commit / missile economy (CI drumsticks): 10 commits = 1 missile.
  int commits = 0;
  int missiles = 1;
  static const int commitsPerMissile = 10;
  static const int maxMissiles = 3;

  void registerCommit() {
    if (gameBloc.state.entity.isGameOver) return;
    commits++;
    gameBloc.add(const GameEvent.scoreIncreased(5));
    if (commits >= commitsPerMissile) {
      commits = 0;
      addMissile(1);
    }
  }

  void addMissile(int count) {
    missiles = (missiles + count).clamp(0, maxMissiles);
    showBanner('MISSILE LOADED ($missiles/$maxMissiles)', seconds: 1.5);
    Sfx.play(AssetsAudio.giftPickup, volume: 0.5);
  }

  /// Fire a loaded missile: heavy damage to everything on screen.
  void fireMissile() {
    if (missiles <= 0 || gameBloc.state.entity.isGameOver || isPaused) return;
    if (!player.isMounted) return;
    missiles--;
    Sfx.play(AssetsAudio.missileLaunch, volume: 0.7);
    Fx.ring(this, player.position.clone(), const Color(0xFF22E6FF),
        maxRadius: 300, lifespan: 0.7);
    for (final enemy in children.whereType<EnemyEntity>().toList()) {
      enemy.takeDamage(150);
    }
    for (final boss in children.whereType<BossEntity>().toList()) {
      boss.takeDamage(150);
    }
    for (final meteor in children.whereType<MeteorEntity>().toList()) {
      meteor.takeDamage(150);
    }
  }
  SectorMission _mission = SectorMission.fallback(1);
  int waveIndex = 0;

  // --- Center-screen banner (wave / boss / sector announcements).
  String? bannerText;
  double _bannerTimer = 0;

  void showBanner(String text, {double seconds = 2.2}) {
    bannerText = text;
    _bannerTimer = seconds;
  }

  bool get bannerVisible => bannerText != null && _bannerTimer > 0;

  String get waveProgressText {
    final done = waveIndex.clamp(0, _mission.totalWaves);
    return 'WAVE $done/${_mission.totalWaves}';
  }

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
    if (!gameBloc.state.entity.isGameOver && Sfx.bgmEnabled) {
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
    currentLevel = startLevel;
    _mission = await SectorMission.load(startLevel);
    waveIndex = 0;
    commits = 0;
    missiles = 1;
    _meteorTimer = 0;
    resetCombo();
    gameBloc.add(const GameEvent.gameRestarted());
    player = PlayerEntity();
    add(player);
    add(ShootDetector(player));
    powerupSpawner.start();
    await FlameAudio.bgm.stop();
    _playMissionMusic();
    showBanner('SECTOR $startLevel', seconds: 2.5);
  }

  /// Per-wave speed multiplier from the mission (combined with the
  /// sector config multiplier inside EnemyEntity).
  double waveSpeedMult = 1.0;

  void _spawnGrid(int rows, int cols) {

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

  /// Spawn one typed mission wave.
  void spawnMissionWave(MissionWave wave) {
    waveSpeedMult = wave.speedMult;
    switch (wave.type) {
      case WaveType.formation:
      case WaveType.bonus:
        _spawnGrid(wave.rows, wave.cols);
        for (int i = 0; i < wave.giftShower; i++) {
          add(PowerUpEntity());
        }
      case WaveType.swoop:
        // Chickens dive straight in, no formation entry.
        for (int i = 0; i < wave.rows * wave.cols; i++) {
          final x = Random().nextDouble() * size.x;
          final enemy = EnemyEntity(
            formationPosition: Vector2(x, 80 + (i % wave.rows) * 50),
            startPosition: Vector2(x, -50 - i * 30),
            assetName: currentConfig.enemySprite,
          )..state = EnemyState.swooping;
          add(enemy);
        }
      case WaveType.meteor:
        // Rocky storm: instant meteors + thin escort grid.
        for (int i = 0; i < 6; i++) {
          final meteor = MeteorEntity()
            ..position = Vector2(Random().nextDouble() * size.x, -50 - i * 60)
            ..velocity =
                Vector2((Random().nextDouble() - 0.5) * 0.5, 1.0).normalized();
          add(meteor);
        }
        _spawnGrid(1, wave.cols);
    }
    showBanner('$waveProgressText — ${wave.label}');
    if (wave.type == WaveType.bonus) {
      Sfx.play(AssetsAudio.waveClear, volume: 0.5);
    }
  }

  void spawnBoss() {
    bossActive = true;
    add(BossEntity());
    showBanner('⚠ WARNING: BOSS ⚠', seconds: 3.0);
    Sfx.play(AssetsAudio.bossRoar, volume: 0.8);
    _playBossMusic();
  }

  Future<void> _advanceSector() async {
    currentLevel++;
    _mission = await SectorMission.load(currentLevel);
    waveIndex = 0;
    waveSpeedMult = 1.0;
    gameBloc.add(const GameEvent.scoreIncreased(1000)); // Sector clear bonus
    showBanner('SECTOR $currentLevel', seconds: 2.5);
    _playMissionMusic();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameBloc.state.entity.isGameOver || isPaused) return;

    // Banner decay
    if (_bannerTimer > 0) {
      _bannerTimer -= dt;
      if (_bannerTimer <= 0) bannerText = null;
    }

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
      // Boss defeated! Sector clear.
      Sfx.play(AssetsAudio.levelup, volume: 0.7);
      bossActive = false;
      _advanceSector();
    }

    if (enemies.isEmpty && !bossActive) {
      if (waveIndex >= _mission.totalWaves) {
        spawnBoss();
      } else {
        final wave = _mission.waveAt(waveIndex);
        waveIndex++;
        spawnMissionWave(wave);
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
