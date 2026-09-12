part of 'game_bloc.dart';

@freezed
abstract class GameEvent with _$GameEvent {
  const factory GameEvent.scoreIncreased(int amount) = _ScoreIncreased;
  const factory GameEvent.playerDamaged(int damage) = _PlayerDamaged;
  const factory GameEvent.bossDefeated() = _BossDefeated;
  const factory GameEvent.gameRestarted() = _GameRestarted;
  // Final boss (sector 3) defeated → story victory. [sector] is 1-based.
  const factory GameEvent.victory(int sector) = _Victory;
  // Continue into endless mode after the story victory.
  const factory GameEvent.continueEndless() = _ContinueEndless;
}
