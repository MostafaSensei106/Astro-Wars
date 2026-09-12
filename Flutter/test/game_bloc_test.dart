import 'package:astro/core/constants/types/type_def.dart';
import 'package:astro/core/utils/result/result.dart';
import 'package:astro/modules/game/data/models/run_request_body.dart';
import 'package:astro/modules/game/logic/bloc/game_bloc.dart';
import 'package:astro/modules/game/logic/repositories/game_repository.dart';
import 'package:astro/modules/game/logic/usecases/submit_run_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements GameRepository {
  RunRequestBody? lastBody;
  @override
  Future<ApiResult> submitRun(RunRequestBody body) async {
    lastBody = body;
    return const Result.success(data: null);
  }
}

GameBloc _bloc(_FakeRepo repo) => GameBloc(SubmitRunUseCase(repo));

void main() {
  group('GameBloc HP model (single source of truth, clamped 0..5)', () {
    test('starts with score 0, health 3, alive', () {
      final bloc = _bloc(_FakeRepo());
      expect(bloc.state.entity.score, 0);
      expect(bloc.state.entity.health, 3);
      expect(bloc.state.entity.isGameOver, isFalse);
      return bloc.close();
    });

    test('score accumulates while playing', () async {
      final bloc = _bloc(_FakeRepo());
      bloc.add(const GameEvent.scoreIncreased(10));
      bloc.add(const GameEvent.scoreIncreased(200));
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<GameState>((s) => s.entity.score == 210)),
      );
      await bloc.close();
    });

    test('three hits kill the run (no double-damage)', () async {
      final repo = _FakeRepo();
      final bloc = _bloc(repo);
      bloc.add(const GameEvent.playerDamaged(1));
      bloc.add(const GameEvent.playerDamaged(1));
      bloc.add(const GameEvent.playerDamaged(1));
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<GameState>(
            (s) => s.entity.isGameOver && s.entity.health == 0,
          ),
        ),
      );
      expect(repo.lastBody, isNotNull);
      await bloc.close();
    });

    test('heal is +1 clamped to max (no god-mode)', () async {
      final bloc = _bloc(_FakeRepo());
      bloc.add(const GameEvent.playerDamaged(1)); // 3 -> 2
      bloc.add(const GameEvent.playerDamaged(-1)); // 2 -> 3
      bloc.add(const GameEvent.playerDamaged(-5)); // overheal -> 5 max
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<GameState>((s) => s.entity.health == GameBloc.maxHealth),
        ),
      );
      await bloc.close();
    });

    test('boss kills are counted in the submitted run', () async {
      final repo = _FakeRepo();
      final bloc = _bloc(repo);
      bloc.add(const GameEvent.bossDefeated());
      bloc.add(const GameEvent.playerDamaged(99));
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<GameState>((s) => s.entity.isGameOver)),
      );
      expect(repo.lastBody?.bossesDefeated, 1);
      await bloc.close();
    });

    test('restart resets the run', () async {
      final bloc = _bloc(_FakeRepo());
      bloc.add(const GameEvent.scoreIncreased(500));
      bloc.add(const GameEvent.gameRestarted());
      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<GameState>(
            (s) =>
                s.entity.score == 0 &&
                s.entity.health == 3 &&
                !s.entity.isGameOver,
          ),
        ),
      );
      await bloc.close();
    });
  });
}
