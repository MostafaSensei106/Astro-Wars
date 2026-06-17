import '../../../../core/utils/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../data/models/run_request_model.dart';

abstract class GameRepository {
  Future<Result<void, Failures>> submitRun(RunRequestModel request);
}
