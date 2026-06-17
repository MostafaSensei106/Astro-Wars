import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_header.dart';
import '../constants/app_config.dart';
import '../di/di.dart';
import '../services/shared_prefs/base_pref_storage_service.dart';
import '../utils/localization/logic/cubit/localization_cubit.dart';
import '../utils/network/logic/cubit/network_cubit.dart';
import 'dio_connectivity_request_retrier.dart';
import 'dio_locale_interceptor.dart';
import 'dio_token_interceptor.dart';
import 'network_info/interface/base_network_info.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

  static Future<Dio> getDio({
    required LocalizationCubit localizationCubit,
    required BasePrefStorageService prefStorageService,
    required BaseNetworkInfo networkInfo,
    required NetworkCubit networkCubit,
  }) async {
    if (dio == null) {
      dio = Dio();
      dio!
        ..options.headers[ApiHeader.accept] = ApiHeader.applicationJson
        ..options.headers[ApiHeader.contentType] = ApiHeader.applicationJson
        ..options.connectTimeout = AppConfig.dioTimeOut
        ..options.receiveTimeout = AppConfig.dioTimeOut;
      addDioInterceptors(
        localizationCubit: localizationCubit,
        prefStorageService: prefStorageService,
        networkInfo: networkInfo,
        networkCubit: networkCubit,
      );
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioInterceptors({
    required LocalizationCubit localizationCubit,
    required BasePrefStorageService prefStorageService,
    required BaseNetworkInfo networkInfo,
    required NetworkCubit networkCubit,
  }) {
    // dio?.interceptors.add(DioCertificatePinningInterceptor());
    dio?.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    );
    dio?.interceptors.add(DioLocaleInterceptor(localizationCubit));
    dio?.interceptors.add(DioTokenInterceptor(prefStorageService));
    dio?.interceptors.add(
      DioConnectivityInterceptor(
        dio: dio!,
        networkInfo: getIt<BaseNetworkInfo>(),
        onConnectionChanged: (isConnected) {
          getIt<NetworkCubit>().forceUpdateStatus(isConnected: isConnected);
        },
      ),
    );
  }
}
