import 'package:injectable/injectable.dart';

import '../../../../core/utils/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_remote_datasource.dart';
import '../models/run_request_model.dart';

@Injectable(as: GameRepository)
class GameRepositoryImpl implements GameRepository {
  final GameRemoteDataSource _remoteDataSource;

  GameRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<void, Failures>> submitRun(RunRequestModel request) async {
    return Result.tryCatching<void, Failures>(
      action: () async {
        await _remoteDataSource.submitRun(request);
      },
      onError: (e) {
        return ServerFailure(e.toString());
      },
    );
  }
}
