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

  static LevelConfig getLevel(int level) {
    switch (level) {
      case 1:
        return const LevelConfig(
          level: 1,
          bgGradient: [Color(0xFF03011A), Color(0xFF0B0D17), Color(0xFF000000)],
          enemySprite: 'hd_enemy_bug_1781686468572.png',
          bossSprite: 'hd_boss_car_1781686478720.png',
          enemySpeedMultiplier: 1.0,
          rows: 2,
          cols: 5,
          wavesBeforeBoss: 2,
        );
      case 2:
        return const LevelConfig(
          level: 2,
          bgGradient: [Color(0xFF1A0105), Color(0xFF170B0B), Color(0xFF000000)], // Reddish
          enemySprite: 'hd_enemy_spaghetti_1781686763386.png',
          bossSprite: 'hd_boss_professor_1781686774890.png',
          enemySpeedMultiplier: 1.2,
          rows: 3,
          cols: 6,
          wavesBeforeBoss: 3,
        );
      case 3:
        return const LevelConfig(
          level: 3,
          bgGradient: [Color(0xFF011A0E), Color(0xFF0B1710), Color(0xFF000000)], // Greenish
          enemySprite: 'hd_enemy_bug_1781686468572.png',
          bossSprite: 'hd_boss_car_1781686478720.png',
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
          enemySprite: level % 2 == 0 ? 'hd_enemy_spaghetti_1781686763386.png' : 'hd_enemy_bug_1781686468572.png',
          bossSprite: level % 2 == 0 ? 'hd_boss_professor_1781686774890.png' : 'hd_boss_car_1781686478720.png',
          enemySpeedMultiplier: 1.5 + (level * 0.1),
          rows: 4,
          cols: 8,
          wavesBeforeBoss: 4,
        );
    }
  }
}
