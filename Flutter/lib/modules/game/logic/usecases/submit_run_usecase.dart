import 'package:astro/core/utils/use_case/base_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../data/models/run_request_body.dart';
import '../repositories/game_repository.dart';

@injectable
class SubmitRunUseCase implements BaseUseCase<void, RunRequestBody> {
  final GameRepository _repository;

  SubmitRunUseCase(this._repository);

  @override
  Future<Result<void, Failures>> call(RunRequestBody params) {
    return _repository.submitRun(params);
  }
}
