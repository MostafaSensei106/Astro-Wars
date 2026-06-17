import 'package:injectable/injectable.dart';

import '../../../../core/utils/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../data/models/run_request_model.dart';
import '../repositories/game_repository.dart';

@injectable
class SubmitRunUseCase {
  final GameRepository _repository;

  SubmitRunUseCase(this._repository);

  Future<Result<void, Failures>> call(RunRequestModel request) async {
    return _repository.submitRun(request);
  }
}
