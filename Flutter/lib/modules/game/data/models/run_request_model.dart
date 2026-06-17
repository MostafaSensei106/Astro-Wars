class RunRequestModel {
  final int score;
  final int duration;
  final String causeOfDeath;
  final String stageReached;
  final int bugsSquashed;
  final int bossesDefeated;
  final int maxFlowState;
  final double accuracy;
  final int coffeeCups;

  RunRequestModel({
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

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'duration': duration,
      'cause_of_death': causeOfDeath,
      'stage_reached': stageReached,
      'bugs_squashed': bugsSquashed,
      'bosses_defeated': bossesDefeated,
      'max_flow_state': maxFlowState,
      'accuracy': accuracy,
      'coffee_cups': coffeeCups,
    };
  }
}
