// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunRequestBody _$RunRequestBodyFromJson(Map<String, dynamic> json) =>
    RunRequestBody(
      score: (json['score'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      causeOfDeath: json['causeOfDeath'] as String,
      stageReached: json['stageReached'] as String,
      bugsSquashed: (json['bugsSquashed'] as num).toInt(),
      bossesDefeated: (json['bossesDefeated'] as num).toInt(),
      maxFlowState: (json['maxFlowState'] as num).toInt(),
      accuracy: (json['accuracy'] as num).toDouble(),
      coffeeCups: (json['coffeeCups'] as num).toInt(),
    );

Map<String, dynamic> _$RunRequestBodyToJson(RunRequestBody instance) =>
    <String, dynamic>{
      'score': instance.score,
      'duration': instance.duration,
      'causeOfDeath': instance.causeOfDeath,
      'stageReached': instance.stageReached,
      'bugsSquashed': instance.bugsSquashed,
      'bossesDefeated': instance.bossesDefeated,
      'maxFlowState': instance.maxFlowState,
      'accuracy': instance.accuracy,
      'coffeeCups': instance.coffeeCups,
    };
