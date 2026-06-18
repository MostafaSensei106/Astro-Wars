import 'package:astro/core/constants/types/type_def.dart';

import '../../data/models/run_request_body.dart';

abstract class GameRepository {
  Future<ApiResult> submitRun(RunRequestBody body);
}
