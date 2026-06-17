import 'package:dio/dio.dart';
import '../utils/error/failures.dart';
import 'api_error_model/api_error_model.dart';

final class APIErrorHandler {
  const APIErrorHandler._();

  static Failures handle(Object error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is TypeError || error is FormatException) {
      return const ParsingFailure('Data parsing error');
    } else {
      return UnknownFailure(error.toString());
    }
  }

  static Failures _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure('Server connection timeout');

      case DioExceptionType.badResponse:
        return _parseServerResponseError(error.response);

      case DioExceptionType.cancel:
        return const ServerFailure('Request was cancelled');

      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');

      case DioExceptionType.badCertificate:
        return const ServerFailure('Bad certificate error');

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return const NetworkFailure('No internet connection');
        }
        return UnknownFailure(error.message ?? 'Unknown network error');
    }
  }

  static Failures _parseServerResponseError(Response? response) {
    if (response == null) {
      return const ServerFailure('Empty response from server');
    }

    final responseData = response.data;
    final statusCode = response.statusCode;

    if (responseData != null && responseData is Map<String, dynamic>) {
      try {
        final model = APIErrorModel.fromJson(responseData);
        final errorMessage = model.message.isNotEmpty
            ? model.message
            : responseData['error']?.toString() ??
                  responseData['message']?.toString();

        return ServerFailure(errorMessage ?? 'Server error ($statusCode)');
      } catch (_) {
        return ServerFailure('Server parsing error ($statusCode)');
      }
    } else if (responseData is String && responseData.isNotEmpty) {
      return ServerFailure(responseData);
    }

    return ServerFailure('Request failed with status code: $statusCode');
  }
}
