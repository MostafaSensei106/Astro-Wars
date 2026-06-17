import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../networking/api_service/api_service.dart';
import '../networking/dio_factory.dart';
import '../networking/network_info/interface/base_network_info.dart';
import '../services/shared_prefs/base_pref_storage_service.dart';
import '../utils/localization/logic/cubit/localization_cubit.dart';
import '../utils/network/logic/cubit/network_cubit.dart';

@module
abstract class InjectionModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  SharePlus get sharePlus => SharePlus.instance;

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @preResolve
  Future<Dio> dio(
    LocalizationCubit localizationCubit,
    BasePrefStorageService prefStorageService,
    BaseNetworkInfo networkInfo,
    NetworkCubit networkCubit,
  ) => DioFactory.getDio(
    localizationCubit: localizationCubit,
    prefStorageService: prefStorageService,
    networkInfo: networkInfo,
    networkCubit: networkCubit,
  );

  @lazySingleton
  ApiService apiService(Dio dio) => ApiService(dio);
}
