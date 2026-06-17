import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/game_state_entity.dart';

part 'game_event.dart';
part 'game_state.dart';
part 'game_bloc.freezed.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState.initial(GameStateEntity())) {
    on<_ScoreIncreased>((event, emit) {
      final currentState = state.entity;
      if (currentState.isGameOver) return;
      emit(GameState.playing(currentState.copyWith(score: currentState.score + event.amount)));
    });

    on<_PlayerDamaged>((event, emit) {
      final currentState = state.entity;
      if (currentState.isGameOver) return;
      
      final newHealth = currentState.health - event.damage;
      if (newHealth <= 0) {
        emit(GameState.gameOver(currentState.copyWith(health: 0, isGameOver: true)));
      } else {
        emit(GameState.playing(currentState.copyWith(health: newHealth)));
      }
    });

    on<_GameRestarted>((event, emit) {
      emit(const GameState.initial(GameStateEntity()));
    });
  }
}
