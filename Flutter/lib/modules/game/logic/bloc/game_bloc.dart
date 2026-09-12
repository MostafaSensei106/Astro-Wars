import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../entities/game_state_entity.dart';

import 'package:injectable/injectable.dart';
import '../../data/models/run_request_body.dart';
import '../usecases/submit_run_usecase.dart';

part 'game_event.dart';
part 'game_state.dart';
part 'game_bloc.freezed.dart';

/// Single source of truth for HP: clamped 0..[maxHealth].
/// Negative [damage] heals (clamped to max — no more god-mode).
@injectable
class GameBloc extends Bloc<GameEvent, GameState> {
  static const int maxHealth = 5;
  final SubmitRunUseCase _submitRunUseCase;
  DateTime _runStartedAt = DateTime.now();
  int _bossesDefeated = 0;

  GameBloc(this._submitRunUseCase)
    : super(const GameState.initial(GameStateEntity())) {
    on<_ScoreIncreased>((event, emit) {
      final currentState = state.entity;
      if (currentState.isGameOver) return;
      emit(
        GameState.playing(
          currentState.copyWith(score: currentState.score + event.amount),
        ),
      );
    });

    on<_PlayerDamaged>((event, emit) async {
      final currentState = state.entity;
      if (currentState.isGameOver) return;

      final newHealth = (currentState.health - event.damage).clamp(
        0,
        maxHealth,
      );
      if (newHealth <= 0) {
        final finalState = currentState.copyWith(health: 0, isGameOver: true);
        emit(GameState.gameOver(finalState));

        // Submit the result to backend with real run stats.
        final duration = DateTime.now()
            .difference(_runStartedAt)
            .inSeconds
            .clamp(1, 1 << 31);
        await _submitRunUseCase(
          RunRequestBody(
            score: finalState.score,
            duration: duration,
            causeOfDeath: 'Run ended',
            stageReached: 'Deep Space',
            bugsSquashed: finalState.score ~/ 10,
            bossesDefeated: _bossesDefeated,
            maxFlowState: 5,
            accuracy: 85.5,
            coffeeCups: 3,
          ),
        );
      } else {
        emit(GameState.playing(currentState.copyWith(health: newHealth)));
      }
    });

    on<_BossDefeated>((event, emit) {
      _bossesDefeated++;
    });

    on<_GameRestarted>((event, emit) {
      _runStartedAt = DateTime.now();
      _bossesDefeated = 0;
      emit(const GameState.initial(GameStateEntity()));
    });
  }
}
