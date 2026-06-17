part of 'game_bloc.dart';

@freezed
class GameState with _$GameState {
  const factory GameState.initial(GameStateEntity entity) = _Initial;
  const factory GameState.playing(GameStateEntity entity) = _Playing;
  const factory GameState.gameOver(GameStateEntity entity) = _GameOver;
}
