import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/buttons/elevated_button/elevated_button_component.dart';
import '../../../../core/widgets/display/card/card_component.dart';
import '../../logic/bloc/game_bloc.dart';
import '../flame_game/astro_game.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GameBloc>(),
      child: const GameView(),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();

    return Scaffold(
      body: Stack(
        children: [
          // The Flame Game Layer
          GameWidget(game: AstroGame(gameBloc: gameBloc)),

          // The UI Overlay Layer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  return CardComponent(
                    color: Colors.black45,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Score: ${state.entity.score}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Health: ${state.entity.health}%',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Game Over Overlay
          BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (state.entity.isGameOver) {
                return Center(
                  child: CardComponent(
                    color: Colors.black87,
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'GAME OVER',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButtonComponent(
                          label: 'Restart',
                          onPressed: () {
                            context.read<GameBloc>().add(
                              const GameEvent.gameRestarted(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
