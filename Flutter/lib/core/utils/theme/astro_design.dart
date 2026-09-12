import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Astro Wars design system: Neon Space Opera.
///
/// Fonts are bundled locally (NOT google_fonts):
///   - Display: **Orbitron**  → `assets/fonts/Orbitron-Bold.ttf`, `Orbitron-Black.ttf`
///   - Body:    **Rubik**     → `assets/fonts/Rubik-Regular.ttf`, `Rubik-Bold.ttf`
/// Until the files land, Flutter silently falls back to the platform font.
abstract final class AstroDesign {
  // --- Fonts ---
  static const String displayFont = 'Orbitron';
  static const String bodyFont = 'Rubik';

  // --- Colors ---
  static const Color bg = Color(0xFF070A18);
  static const Color surface = Color(0xFF10142B);
  static const Color surface2 = Color(0xFF181D3A);
  static const Color neonCyan = Color(0xFF22E6FF);
  static const Color neonMagenta = Color(0xFFFF3DF2);
  static const Color neonAmber = Color(0xFFFFC233);
  static const Color neonGreen = Color(0xFF3DFF88);
  static const Color danger = Color(0xFFFF4D6D);

  static const List<Color> accents = [
    Color(0xFF7C4DFF), // Deep Space
    Color(0xFFFF4D6D), // Neon Red
    Color(0xFF22A7FF), // Cyber Blue
    Color(0xFF3DFF88), // Toxic Green
  ];
  static const List<String> accentNames = [
    'Deep Space',
    'Neon Red',
    'Cyber Blue',
    'Toxic Green',
  ];

  // --- Shape ---
  static const double radiusSm = 12;
  static const double radiusMd = 20;
  static const double radiusLg = 28;

  // --- Prefs keys ---
  static const String kSelectedShip = 'selected_ship';
  static const String kBestScore = 'best_score';
  static const String kMaxLevel = 'max_level_unlocked';
  static const String kRunsPlayed = 'runs_played';
  static const String kSfxEnabled = 'sfx_enabled';
  static const String kBgmEnabled = 'bgm_enabled';
  static const String kDefaultShip = 'ship_sleek.png';

  // --- Ships catalog ---
  static const List<ShipSpec> ships = [
    ShipSpec(
      asset: 'ship_sleek.png',
      name: 'Sleek Fighter',
      role: 'Balanced interceptor',
      firepower: 3,
      speed: 4,
      armor: 2,
    ),
    ShipSpec(
      asset: 'ship_heavy.png',
      name: 'Heavy Cruiser',
      role: 'Slow siege platform',
      firepower: 5,
      speed: 2,
      armor: 4,
    ),
    ShipSpec(
      asset: 'ship_pixel.png',
      name: 'Pixel Glider',
      role: 'Fragile speedster',
      firepower: 2,
      speed: 5,
      armor: 1,
    ),
    ShipSpec(
      asset: 'ship_cipher.png',
      name: 'Cipher Stealth',
      role: 'Tricky striker',
      firepower: 4,
      speed: 3,
      armor: 3,
    ),
  ];

  // --- Prefs helpers ---
  static Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  static Future<String> selectedShip() async =>
      (await _prefs).getString(kSelectedShip) ?? kDefaultShip;

  static Future<void> selectShip(String asset) async =>
      (await _prefs).setString(kSelectedShip, asset);

  static Future<int> bestScore() async =>
      (await _prefs).getInt(kBestScore) ?? 0;

  static Future<int> maxLevel() async =>
      (await _prefs).getInt(kMaxLevel) ?? 1;

  static Future<int> runsPlayed() async =>
      (await _prefs).getInt(kRunsPlayed) ?? 0;

  static Future<void> recordRun(
      {required int score, required int levelReached}) async {
    final p = await _prefs;
    if (score > (p.getInt(kBestScore) ?? 0)) {
      await p.setInt(kBestScore, score);
    }
    if (levelReached > (p.getInt(kMaxLevel) ?? 1)) {
      await p.setInt(kMaxLevel, levelReached);
    }
    await p.setInt(kRunsPlayed, (p.getInt(kRunsPlayed) ?? 0) + 1);
  }

  static Future<void> resetProgress() async {
    final p = await _prefs;
    await p.remove(kBestScore);
    await p.remove(kMaxLevel);
    await p.remove(kRunsPlayed);
  }
}

class ShipSpec {
  final String asset;
  final String name;
  final String role;
  final int firepower;
  final int speed;
  final int armor;
  const ShipSpec({
    required this.asset,
    required this.name,
    required this.role,
    required this.firepower,
    required this.speed,
    required this.armor,
  });
}

/// Global SFX gate: Settings toggles flip these live; game code calls
/// [Sfx.play] instead of `FlameAudio.play` so mute actually works.
abstract final class Sfx {
  static bool enabled = true;
  static bool bgmEnabled = true;

  static Future<void> loadFromPrefs() async {
    final p = await SharedPreferences.getInstance();
    enabled = p.getBool(AstroDesign.kSfxEnabled) ?? true;
    bgmEnabled = p.getBool(AstroDesign.kBgmEnabled) ?? true;
  }

  static Future<void> setEnabled(bool value) async {
    enabled = value;
    (await SharedPreferences.getInstance())
        .setBool(AstroDesign.kSfxEnabled, value);
  }

  static Future<void> setBgmEnabled(bool value) async {
    bgmEnabled = value;
    (await SharedPreferences.getInstance())
        .setBool(AstroDesign.kBgmEnabled, value);
    if (!value) {
      await FlameAudio.bgm.stop();
    }
  }

  static void play(String file, {double volume = 1.0}) {
    if (!enabled) return;
    FlameAudio.play(file, volume: volume);
  }
}
