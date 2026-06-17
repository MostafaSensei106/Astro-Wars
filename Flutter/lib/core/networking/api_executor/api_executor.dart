import '../../constants/types/type_def.dart';
import '../api_error_handler.dart';

final class ApiExecutor {
  static Future<ApiResult<T>> execute<T>({
    required Future<T> Function() action,
  }) => Result.tryCatching(
    action: action,
    onError: (e) => APIErrorHandler.handle(e),
  );
}
