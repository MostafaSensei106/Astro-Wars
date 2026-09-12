import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class GameView extends StatefulWidget {
  final int startLevel;
  const GameView({super.key, this.startLevel = 1});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late final AstroGame _game;
  late final GameBloc _bloc;
  int _best = 0;
  bool _bestLoaded = false;
  StreamSubscription? _blocSub;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<GameBloc>();
    // Single game instance for the whole route (fixes rebuild recreation).
    _game = AstroGame(gameBloc: _bloc, startLevel: widget.startLevel);
    _loadBest();
    _blocSub = _bloc.stream.listen((state) async {
      if (state.entity.isGameOver) {
        // Persist best score, unlocked levels and run count in one place.
        await AstroDesign.recordRun(
          score: state.entity.score,
          levelReached: _game.currentLevel,
        );
        final best = await AstroDesign.bestScore();
        if (mounted) setState(() => _best = best);
      }
    });
  }

  Future<void> _loadBest() async {
    final best = await AstroDesign.bestScore();
    if (!mounted) return;
    setState(() {
      _best = best;
      _bestLoaded = true;
    });
  }

  @override
  void dispose() {
    _blocSub?.cancel();
    super.dispose();
  }

  void _showPauseMenu() {
    _game.pause();
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
              const Text('PAUSED',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4)),
              const SizedBox(height: 8),
              Text('LEVEL ${_game.currentLevel}  •  SCORE ${_bloc.state.entity.score}',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 24),
              ElevatedButtonComponent(
                  label: 'Resume',
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _game.resume();
                  }),
              const SizedBox(height: 12),
              ElevatedButtonComponent(
                  label: 'Restart',
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await _game.reset();
                  }),
              const SizedBox(height: 12),
              ElevatedButtonComponent(
                  label: 'Quit to Base',
                  onPressed: () => context.pop()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget(game: _game),
          // Live HUD — polls lightweight game fields at 5Hz.
          StreamBuilder(
            stream: Stream.periodic(const Duration(milliseconds: 200)),
            builder: (context, _) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: BlocBuilder<GameBloc, GameState>(
                  builder: (context, state) {
                    final bosses =
                        _game.children.whereType<BossEntity>().toList();
                    final bossHp = bosses.isEmpty
                        ? 0.0
                        : (bosses.first.health / bosses.first.maxHealth)
                            .clamp(0.0, 1.0);
                    return Column(
                      children: [
                        Row(
                          children: [
                            _HudButton(
                                icon: Icons.pause_rounded,
                                onTap: _showPauseMenu),
                            const SizedBox(width: 8),
                            _Pill(
                                text: 'LV ${_game.currentLevel}',
                                color: Colors.deepPurpleAccent),
                            const Spacer(),
                            if (_game.comboMultiplier > 1)
                              _Pill(
                                  text:
                                      'x${_game.comboMultiplier} COMBO',
                                  color: Colors.orangeAccent),
                            if (_game.comboMultiplier > 1)
                              const SizedBox(width: 8),
                            Text('${state.entity.score}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    shadows: [
                                      Shadow(
                                          blurRadius: 12,
                                          color: Colors.cyanAccent)
                                    ])),
                          ],
                        ),
                        if (_game.comboCount > 0)
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 120,
                              child: LinearProgressIndicator(
                                value: _game.comboProgress,
                                minHeight: 4,
                                backgroundColor: Colors.white24,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ),
                        if (bosses.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text('⚠ BOSS ⚠',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3)),
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
                              children: List.generate(
                                  GameBloc.maxHealth, (i) {
                                final filled =
                                    i < state.entity.health;
                                return Icon(
                                    filled
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: filled
                                        ? Colors.redAccent
                                        : Colors.white30,
                                    size: 26);
                              }),
                            ),
                            const Spacer(),
                            if (_bestLoaded && _best > 0)
                              Text('BEST $_best',
                                  style: const TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          // Game Over overlay
          BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (!state.entity.isGameOver) return const SizedBox.shrink();
              final isRecord =
                  _bestLoaded && state.entity.score >= _best && state.entity.score > 0;
              return Container(
                color: Colors.black54,
                child: Center(
                  child: CardComponent(
                    color: const Color(0xF2141626),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('GAME OVER',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3)),
                        if (isRecord)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text('★ NEW RECORD ★',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2)),
                          ),
                        const SizedBox(height: 16),
                        Text('${state.entity.score}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w900)),
                        Text('BEST  •  ${_best > state.entity.score ? _best : state.entity.score}',
                            style: const TextStyle(color: Colors.white54)),
                        const SizedBox(height: 8),
                        Text('REACHED LEVEL ${_game.currentLevel}',
                            style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 24),
                        ElevatedButtonComponent(
                            label: 'Retry',
                            onPressed: () => _game.reset()),
                        const SizedBox(height: 12),
                        ElevatedButtonComponent(
                            label: 'Back to Base',
                            onPressed: () => context.pop()),
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
      child: Text(text,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
