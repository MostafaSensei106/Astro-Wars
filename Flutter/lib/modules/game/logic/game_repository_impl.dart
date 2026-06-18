import 'package:astro/core/networking/api_service/api_service.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/error/failures.dart';
import '../../../core/utils/result/result.dart';
import 'repositories/game_repository.dart';
import '../data/models/run_request_body.dart';

@Injectable(as: GameRepository)
class GameRepositoryImpl implements GameRepository {
  final ApiService _api;

  GameRepositoryImpl(this._api);

  @override
  Future<Result<void, Failures>> submitRun(RunRequestBody request) async {
    return Result.tryCatching<void, Failures>(
      action: () async {
        await _api.submitRun(request);
      },
      onError: (e) {
        return ServerFailure(e.toString());
      },
    );
  }
}
