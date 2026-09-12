import 'package:flutter/material.dart';

class LevelConfig {
  final int level;
  final List<Color> bgGradient;
  final String enemySprite;
  final String bossSprite;
  final double enemySpeedMultiplier;
  final int rows;
  final int cols;
  final int wavesBeforeBoss;

  const LevelConfig({
    required this.level,
    required this.bgGradient,
    required this.enemySprite,
    required this.bossSprite,
    required this.enemySpeedMultiplier,
    required this.rows,
    required this.cols,
    required this.wavesBeforeBoss,
  });

  static const List<String> enemyRotation = [
    'enemy_bug.png',
    'enemy_noodle.png',
    'enemy_chick.png',
    'enemy_ufo.png',
    'enemy_crab.png',
    'enemy_jelly.png',
    'enemy_metal.png',
    'enemy_ghost.png',
  ];

  static const List<String> bossRotation = [
    'boss_dreadnought.png',
    'boss_mothership.png',
    'boss_yolk.png',
    'boss_worm.png',
  ];

  static LevelConfig getLevel(int level) {
    final enemy = enemyRotation[(level - 1) % enemyRotation.length];
    final boss = bossRotation[(level - 1) % bossRotation.length];
    switch (level) {
      case 1:
        return LevelConfig(
          level: 1,
          bgGradient: const [Color(0xFF03011A), Color(0xFF0B0D17), Color(0xFF000000)],
          enemySprite: enemy,
          bossSprite: boss,
          enemySpeedMultiplier: 1.0,
          rows: 2,
          cols: 5,
          wavesBeforeBoss: 2,
        );
      case 2:
        return LevelConfig(
          level: 2,
          bgGradient: const [Color(0xFF1A0105), Color(0xFF170B0B), Color(0xFF000000)], // Reddish
          enemySprite: enemy,
          bossSprite: boss,
          enemySpeedMultiplier: 1.2,
          rows: 3,
          cols: 6,
          wavesBeforeBoss: 3,
        );
      case 3:
        return LevelConfig(
          level: 3,
          bgGradient: const [Color(0xFF011A0E), Color(0xFF0B1710), Color(0xFF000000)], // Greenish
          enemySprite: enemy,
          bossSprite: boss,
          enemySpeedMultiplier: 1.5,
          rows: 4,
          cols: 7,
          wavesBeforeBoss: 4,
        );
      default:
        // Procedural generation for higher levels
        return LevelConfig(
          level: level,
          bgGradient: [
            Color.fromARGB(255, level * 10 % 50, 10, level * 20 % 50),
            const Color(0xFF0B0D17),
            const Color(0xFF000000)
          ],
          enemySprite: enemy,
          bossSprite: boss,
          enemySpeedMultiplier: 1.5 + (level * 0.1),
          rows: 4,
          cols: 8,
          wavesBeforeBoss: 4,
        );
    }
  }
}
