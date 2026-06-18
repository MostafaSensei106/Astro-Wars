import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_request_body.g.dart';

@JsonSerializable()
class RunRequestBody {
  final int score;
  final int duration;
  final String causeOfDeath;
  final String stageReached;
  final int bugsSquashed;
  final int bossesDefeated;
  final int maxFlowState;
  final double accuracy;
  final int coffeeCups;

  const RunRequestBody({
    required this.score,
    required this.duration,
    required this.causeOfDeath,
    required this.stageReached,
    required this.bugsSquashed,
    required this.bossesDefeated,
    required this.maxFlowState,
    required this.accuracy,
    required this.coffeeCups,
  });

  factory RunRequestBody.fromJson(Map<String, dynamic> json) => _$RunRequestBodyFromJson(json);
  Map<String, dynamic> toJson() => _$RunRequestBodyToJson(this);
}
