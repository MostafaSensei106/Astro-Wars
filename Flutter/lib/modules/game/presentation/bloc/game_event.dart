part of 'game_bloc.dart';

@freezed
class GameEvent with _$GameEvent {
  const factory GameEvent.scoreIncreased(int amount) = _ScoreIncreased;
  const factory GameEvent.playerDamaged(int damage) = _PlayerDamaged;
  const factory GameEvent.gameRestarted() = _GameRestarted;
}
