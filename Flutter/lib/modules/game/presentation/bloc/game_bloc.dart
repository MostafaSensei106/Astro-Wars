import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/game_state_entity.dart';

import 'package:injectable/injectable.dart';
import '../../data/models/run_request_model.dart';
import '../../domain/usecases/submit_run_usecase.dart';

part 'game_event.dart';
part 'game_state.dart';
part 'game_bloc.freezed.dart';

@injectable
class GameBloc extends Bloc<GameEvent, GameState> {
  final SubmitRunUseCase _submitRunUseCase;

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

      final newHealth = currentState.health - event.damage;
      if (newHealth <= 0) {
        final finalState = currentState.copyWith(health: 0, isGameOver: true);
        emit(GameState.gameOver(finalState));

        // Submit the result to backend
        await _submitRunUseCase(
          RunRequestModel(
            score: finalState.score,
            duration: 60, // Ideally track session time
            causeOfDeath: 'Bug Swarm',
            stageReached: 'Staging Environment',
            bugsSquashed: finalState.score ~/ 10,
            bossesDefeated: 0,
            maxFlowState: 5,
            accuracy: 85.5,
            coffeeCups: 3,
          ),
        );
      } else {
        emit(GameState.playing(currentState.copyWith(health: newHealth)));
      }
    });

    on<_GameRestarted>((event, emit) {
      emit(const GameState.initial(GameStateEntity()));
    });
  }
}
