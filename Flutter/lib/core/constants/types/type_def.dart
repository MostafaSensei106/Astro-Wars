import '../../utils/error/failures.dart';
import '../../utils/result/result.dart';

export '../../utils/error/failures.dart';
export '../../utils/result/result.dart';

typedef ApiResult<T> = Result<T, Failures>;
