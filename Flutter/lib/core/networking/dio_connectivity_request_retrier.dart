// ignore_for_file: inference_failure_on_function_return_type

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'network_info/interface/base_network_info.dart';

final class DioConnectivityInterceptor extends Interceptor {
  DioConnectivityInterceptor({
    required Dio dio,
    required this.networkInfo,
    required this.onConnectionChanged,
  }) {
    _retryInterceptor = RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 5,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 4),
        Duration(seconds: 8),
        Duration(seconds: 16),
      ],
      retryEvaluator: (DioException error, int attempt) {
        return _isNetworkError(error);
      },
    );
  }
  final BaseNetworkInfo networkInfo;
  final void Function(bool isConnected) onConnectionChanged;
  late final RetryInterceptor _retryInterceptor;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isNetworkError(err)) {
      onConnectionChanged(false);
      return _retryInterceptor.onError(err, handler);
    }
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    onConnectionChanged(true);
    return handler.next(response);
  }

  bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        (err.error != null && err.error.toString().contains('SocketException'));
  }
}
