import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state_entity.freezed.dart';

@freezed
abstract class GameStateEntity with _$GameStateEntity {
  const factory GameStateEntity({
    @Default(0) int score,
    @Default(3) int health,
    @Default(false) bool isGameOver,
    @Default(false) bool isVictory,
    @Default(false) bool endlessUnlocked,
  }) = _GameStateEntity;
}
