import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../logic/astro_wars_game.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: AstroWarsGame(),
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.purpleAccent),
        ),
      ),
    );
  }
}
