import 'package:dio/dio.dart';

import '../constants/api_header.dart';
import '../utils/localization/logic/cubit/localization_cubit.dart';

final class DioLocaleInterceptor extends Interceptor {
  DioLocaleInterceptor(this._cubit);

  final LocalizationCubit _cubit;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final lang = _cubit.state.langCode;
    options.headers[ApiHeader.locale] = lang;
    options.headers[ApiHeader.acceptLanguage] = lang;
    handler.next(options);
  }
}
