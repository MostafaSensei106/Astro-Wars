/// Central asset catalog — single source of truth for every bundled file.
///
/// * Flame (`loadSprite`, `ParallaxImageData`, `FlameAudio`) takes the
///   **bare filename** (e.g. `AssetsImages.shipSleek`).
/// * Widgets (`Image.asset`, `AssetImage`, `rootBundle`) take the
///   **full path** via [AssetsImages.path] / [AssetsMissions.sector].
/// Add new files here instead of scattering string literals.
final class AssetsImages {
  static const String _dir = 'assets/images';

  /// Full widget path for a bare image filename.
  static String path(String file) => '$_dir/$file';

  // --- Backgrounds ---
  static const String spaceBg = 'space_bg.jpg';
  static const String spaceBgPath = 'assets/images/space_bg.jpg';
  static const String parallaxFar = 'parallax_far.png';
  static const String parallaxMid = 'parallax_mid.png';
  static const String parallaxNear = 'parallax_near.png';

  // --- Player ships (Flame bare names) ---
  static const String shipSleek = 'ship_sleek.png';
  static const String shipHeavy = 'ship_heavy.png';
  static const String shipPixel = 'ship_pixel.png';
  static const String shipCipher = 'ship_cipher.png';
  static const List<String> ships = [
    shipSleek,
    shipHeavy,
    shipPixel,
    shipCipher,
  ];

  // --- Enemies ---
  static const String enemyBug = 'enemy_bug.png';
  static const String enemyNoodle = 'enemy_noodle.png';
  static const String enemyChick = 'enemy_chick.png';
  static const String enemyUfo = 'enemy_ufo.png';
  static const String enemyCrab = 'enemy_crab.png';
  static const String enemyJelly = 'enemy_jelly.png';
  static const String enemyMetal = 'enemy_metal.png';
  static const String enemyGhost = 'enemy_ghost.png';
  static const List<String> enemies = [
    enemyBug,
    enemyNoodle,
    enemyChick,
    enemyUfo,
    enemyCrab,
    enemyJelly,
    enemyMetal,
    enemyGhost,
  ];

  // --- Bosses ---
  static const String bossDreadnought = 'boss_dreadnought.png';
  static const String bossMothership = 'boss_mothership.png';
  static const String bossYolk = 'boss_yolk.png';
  static const String bossWorm = 'boss_worm.png';
  static const List<String> bosses = [
    bossDreadnought,
    bossMothership,
    bossYolk,
    bossWorm,
  ];

  // --- Supply-crate gifts ---
  static const String giftFlutter = 'gift_flutter.png';
  static const String giftBackend = 'gift_backend.png';
  static const String giftShield = 'gift_shield.png';
  static const String giftStun = 'gift_stun.png';
  static const String giftHeal = 'gift_heal.png';
  static const String giftMissile = 'gift_missile.png';
  static const String giftCoolant = 'gift_coolant.png';
}

/// Central audio catalog (bare filenames for `FlameAudio` / [Sfx]).
final class AssetsAudio {
  static const String laser = 'laser.wav';
  static const String laserEnemy = 'laser_enemy.wav';
  static const String explosion = 'explosion.wav';
  static const String hit = 'hit.wav';
  static const String eggSplat = 'egg_splat.wav';
  static const String featherPop = 'feather_pop.wav';
  static const String cluck = 'cluck.wav';
  static const String bossRoar = 'boss_roar.wav';
  static const String powerup = 'powerup.wav';
  static const String giftPickup = 'gift_pickup.wav';
  static const String coolant = 'coolant.wav';
  static const String overheatWarn = 'overheat_warn.wav';
  static const String overheatLock = 'overheat_lock.wav';
  static const String missileLaunch = 'missile_launch.wav';
  static const String levelup = 'levelup.wav';
  static const String waveClear = 'wave_clear.wav';
  static const String gameover = 'gameover.wav';
  static const String bgm = 'bgm.wav';
  static const String bgmMission = 'bgm_mission.wav';
  static const String bgmBoss = 'bgm_boss.wav';

  /// Everything the game preloads in [AstroGame.onLoad].
  static const List<String> preload = [
    laser,
    explosion,
    laserEnemy,
    powerup,
    hit,
    gameover,
    levelup,
    bgm,
    bgmMission,
    bgmBoss,
    cluck,
    eggSplat,
    featherPop,
    giftPickup,
    coolant,
    overheatWarn,
    overheatLock,
    missileLaunch,
    waveClear,
    bossRoar,
  ];
}

/// Mission JSON catalog (`assets/missions/sector_<n>.json`).
final class AssetsMissions {
  static const String _dir = 'assets/missions';

  /// Full bundle path for a sector mission file.
  static String sector(int sector) => '$_dir/sector_$sector.json';
}
