import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/buttons/elevated_button/elevated_button_component.dart';
import '../../../../core/widgets/display/card/card_component.dart';
import '../../logic/bloc/game_bloc.dart';
import '../flame_game/astro_game.dart';
import '../flame_game/components/entities/boss_entity.dart';
import '../../../../core/utils/theme/astro_design.dart';

class GamePage extends StatelessWidget {
  final int startLevel;
  const GamePage({super.key, this.startLevel = 1});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GameBloc>(),
      child: GameView(startLevel: startLevel),
    );
  }
}

class GameView extends HookWidget {
  final int startLevel;
  const GameView({super.key, this.startLevel = 1});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    // Single game instance for the whole route (fixes rebuild recreation).
    final game = useMemoized(
      () => AstroGame(gameBloc: bloc, startLevel: startLevel),
      [],
    );
    final best = useState(0);
    final bestLoaded = useState(false);

    useEffect(() {
      var alive = true;
      AstroDesign.bestScore().then((b) {
        if (!alive) return;
        best.value = b;
        bestLoaded.value = true;
      });
      final sub = bloc.stream.listen((state) async {
        if (state.entity.isGameOver) {
          // Persist best score, unlocked levels and run count in one place.
          await AstroDesign.recordRun(
            score: state.entity.score,
            levelReached: game.currentLevel,
          );
          final b = await AstroDesign.bestScore();
          if (alive) best.value = b;
        }
      });
      return () {
        alive = false;
        sub.cancel();
      };
    }, const []);

    void showPauseMenu() {
      game.pause();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Center(
          child: CardComponent(
            color: const Color(0xE6141626),
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'PAUSED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'LEVEL ${game.currentLevel}  •  SCORE ${bloc.state.entity.score}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                ElevatedButtonComponent(
                  label: 'Resume',
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    game.resume();
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButtonComponent(
                  label: 'Restart',
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await game.reset();
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButtonComponent(
                  label: 'Quit to Base',
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget(game: game),
          // Live HUD — polls lightweight game fields at 5Hz.
          StreamBuilder(
            stream: Stream.periodic(const Duration(milliseconds: 200)),
            builder: (context, _) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: BlocBuilder<GameBloc, GameState>(
                  builder: (context, state) {
                    final bosses = game.children
                        .whereType<BossEntity>()
                        .toList();
                    final bossHp = bosses.isEmpty
                        ? 0.0
                        : (bosses.first.health / bosses.first.maxHealth).clamp(
                            0.0,
                            1.0,
                          );
                    return Column(
                      children: [
                        Row(
                          children: [
                            _HudButton(
                              icon: Icons.pause_rounded,
                              onTap: showPauseMenu,
                            ),
                            const SizedBox(width: 8),
                            _Pill(
                              text: 'LV ${game.currentLevel}',
                              color: Colors.deepPurpleAccent,
                            ),
                            const SizedBox(width: 8),
                            _Pill(
                              text: game.waveProgressText,
                              color: Colors.cyanAccent,
                            ),
                            const Spacer(),
                            if (game.comboMultiplier > 1)
                              _Pill(
                                text: 'x${game.comboMultiplier} COMBO',
                                color: Colors.orangeAccent,
                              ),
                            if (game.comboMultiplier > 1)
                              const SizedBox(width: 8),
                            Text(
                              '${state.entity.score}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(
                                    blurRadius: 12,
                                    color: Colors.cyanAccent,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (game.comboCount > 0)
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 120,
                              child: LinearProgressIndicator(
                                value: game.comboProgress,
                                minHeight: 4,
                                backgroundColor: Colors.white24,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ),
                        // Overheat bar (CI-style heat management).
                        if (game.player.isMounted) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                game.player.overheated
                                    ? Icons.thermostat_rounded
                                    : Icons.whatshot_rounded,
                                size: 14,
                                color: game.player.overheated
                                    ? Colors.redAccent
                                    : game.player.heat01 > 0.8
                                    ? Colors.orangeAccent
                                    : Colors.white38,
                              ),
                              const SizedBox(width: 6),
                              SizedBox(
                                width: 140,
                                child: LinearProgressIndicator(
                                  value: game.player.heat01,
                                  minHeight: 6,
                                  backgroundColor: Colors.white12,
                                  color: game.player.overheated
                                      ? Colors.redAccent
                                      : game.player.heat01 > 0.8
                                      ? Colors.orangeAccent
                                      : Colors.cyanAccent,
                                ),
                              ),
                              if (game.player.overheated) ...[
                                const SizedBox(width: 6),
                                const Text(
                                  'OVERHEATED',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                        // Weapon status: type + level pips.
                        if (game.player.isMounted &&
                            game.player.activeWeapon != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${game.player.activeWeapon!.name.toUpperCase()} LV${game.player.weaponLevel}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              SizedBox(
                                width: 90,
                                child: LinearProgressIndicator(
                                  value: game.player.weaponLevel / 10,
                                  minHeight: 4,
                                  backgroundColor: Colors.white12,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (bosses.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            '⚠ BOSS ⚠',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: bossHp,
                              minHeight: 10,
                              backgroundColor: Colors.white12,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Row(
                          children: [
                            // Hearts (max 5, starts at 3)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(GameBloc.maxHealth, (i) {
                                final filled = i < state.entity.health;
                                return Icon(
                                  filled
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: filled
                                      ? Colors.redAccent
                                      : Colors.white30,
                                  size: 26,
                                );
                              }),
                            ),
                            const Spacer(),
                            // Missile launcher (commit economy).
                            GestureDetector(
                              onTap: game.fireMissile,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: game.missiles > 0
                                          ? Colors.orangeAccent.withValues(
                                              alpha: 0.9,
                                            )
                                          : Colors.white10,
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.rocket_launch_rounded,
                                      color: game.missiles > 0
                                          ? Colors.black87
                                          : Colors.white38,
                                      size: 26,
                                    ),
                                  ),
                                  Positioned(
                                    top: -6,
                                    right: -6,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.redAccent,
                                      ),
                                      child: Text(
                                        '${game.missiles}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (bestLoaded.value && best.value > 0)
                              Text(
                                'BEST $best.value',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          // Wave / boss / sector banner.
          if (game.bannerVisible)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.cyanAccent.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Text(
                      game.bannerText ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(blurRadius: 12, color: Colors.cyanAccent),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          // Game Over overlay
          BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (!state.entity.isGameOver) return const SizedBox.shrink();
              final isRecord =
                  bestLoaded.value &&
                  state.entity.score >= best.value &&
                  state.entity.score > 0;
              return Container(
                color: Colors.black54,
                child: Center(
                  child: CardComponent(
                    color: const Color(0xF2141626),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'GAME OVER',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                        ),
                        if (isRecord)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              '★ NEW RECORD ★',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          '${state.entity.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'BEST  •  ${best.value > state.entity.score ? best.value : state.entity.score}',
                          style: const TextStyle(color: Colors.white54),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'REACHED LEVEL ${game.currentLevel}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButtonComponent(
                          label: 'Retry',
                          onPressed: () => game.reset(),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButtonComponent(
                          label: 'Back to Base',
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HudButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HudButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white10,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
