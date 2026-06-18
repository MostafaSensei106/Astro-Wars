// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:astro/core/di/injection_module.dart' as _i840;
import 'package:astro/core/networking/api_service/api_service.dart' as _i814;
import 'package:astro/core/networking/network_info/interface/base_network_info.dart'
    as _i401;
import 'package:astro/core/networking/network_info/network_info.dart' as _i1041;
import 'package:astro/core/services/app_info/app_info_service.dart' as _i426;
import 'package:astro/core/services/app_info/interface/base_app_info_service.dart'
    as _i512;
import 'package:astro/core/services/app_info/interface/base_package_info_adapter.dart'
    as _i338;
import 'package:astro/core/services/app_info/package_info_plus_adapter.dart'
    as _i101;
import 'package:astro/core/services/l10n/l10n_service.dart' as _i181;
import 'package:astro/core/services/shared_prefs/base_pref_storage_service.dart'
    as _i955;
import 'package:astro/core/services/shared_prefs/secure_storage_service.dart'
    as _i71;
import 'package:astro/core/services/shared_prefs/shared_prefs_service.dart'
    as _i1025;
import 'package:astro/core/services/shared_prefs/storage_facade.dart' as _i108;
import 'package:astro/core/services/theme/theme_service.dart' as _i368;
import 'package:astro/core/services/toast/base_toast_service.dart' as _i14;
import 'package:astro/core/services/toast/toastification_service.dart' as _i187;
import 'package:astro/core/utils/localization/data/base_localization_repository.dart'
    as _i608;
import 'package:astro/core/utils/localization/data/localization_repository.dart'
    as _i784;
import 'package:astro/core/utils/localization/logic/cubit/localization_cubit.dart'
    as _i343;
import 'package:astro/core/utils/network/logic/cubit/network_cubit.dart'
    as _i464;
import 'package:astro/core/utils/theme/data/base_theme_repository.dart'
    as _i877;
import 'package:astro/core/utils/theme/data/theme_repository.dart' as _i297;
import 'package:astro/core/utils/theme/logic/cubit/theme_cubit.dart' as _i377;
import 'package:astro/modules/game/logic/game_repository_impl.dart' as _i259;
import 'package:astro/modules/game/logic/repositories/game_repository.dart'
    as _i311;
import 'package:astro/modules/game/logic/usecases/submit_run_usecase.dart'
    as _i494;
import 'package:astro/modules/game/logic/bloc/game_bloc.dart' as _i394;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => injectionModule.prefs(),
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => injectionModule.packageInfo(),
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => injectionModule.secureStorage(),
    );
    gh.lazySingleton<_i895.Connectivity>(() => injectionModule.connectivity());
    gh.lazySingleton<_i181.L10nService>(() => _i181.L10nService());
    gh.lazySingleton<_i368.ThemeService>(() => _i368.ThemeService());
    gh.lazySingleton<_i377.ThemeCubit>(() => _i377.ThemeCubit());
    gh.lazySingleton<_i338.BasePackageInfoAdapter>(
      () => _i101.PackageInfoPlusAdapter(gh<_i655.PackageInfo>()),
    );
    gh.lazySingleton<_i401.BaseNetworkInfo>(
      () => _i1041.NetworkInfo(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i464.NetworkCubit>(
      () => _i464.NetworkCubit(gh<_i401.BaseNetworkInfo>()),
    );
    gh.lazySingleton<_i14.BaseToastService>(
      () => _i187.ToastificationService(
        gh<_i181.L10nService>(),
        gh<_i368.ThemeService>(),
      ),
    );
    gh.lazySingleton<_i71.SecureStorageService>(
      () => _i71.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i1025.SharedPrefsService>(
      () => _i1025.SharedPrefsService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i955.BasePrefStorageService>(
      () => _i108.StorageFacade(
        sharedPrefsService: gh<_i1025.SharedPrefsService>(),
        secureStorageService: gh<_i71.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i343.LocalizationCubit>(
      () => _i343.LocalizationCubit(l10nService: gh<_i181.L10nService>()),
    );
    gh.lazySingleton<_i512.BaseAppInfoService>(
      () => _i426.AppInfoService(gh<_i338.BasePackageInfoAdapter>()),
    );
    await gh.factoryAsync<_i361.Dio>(
      () => injectionModule.dio(
        gh<_i343.LocalizationCubit>(),
        gh<_i955.BasePrefStorageService>(),
        gh<_i401.BaseNetworkInfo>(),
        gh<_i464.NetworkCubit>(),
      ),
      preResolve: true,
    );
    gh.lazySingleton<_i877.BaseThemeRepository>(
      () => _i297.ThemeRepository(gh<_i955.BasePrefStorageService>()),
    );
    gh.lazySingleton<_i608.BaseLocalizationRepository>(
      () => _i784.LocalizationRepository(
        storage: gh<_i955.BasePrefStorageService>(),
        l10nService: gh<_i181.L10nService>(),
      ),
    );
    gh.lazySingleton<_i814.ApiService>(
      () => injectionModule.apiService(gh<_i361.Dio>()),
    );
    gh.factory<_i311.GameRepository>(
      () => _i259.GameRepositoryImpl(gh<_i814.ApiService>()),
    );
    gh.factory<_i494.SubmitRunUseCase>(
      () => _i494.SubmitRunUseCase(gh<_i311.GameRepository>()),
    );
    gh.factory<_i394.GameBloc>(
      () => _i394.GameBloc(gh<_i494.SubmitRunUseCase>()),
    );
    return this;
  }

  _i181.L10nService get l10nService => get<_i181.L10nService>();

  _i368.ThemeService get themeService => get<_i368.ThemeService>();

  _i377.ThemeCubit get themeCubit => get<_i377.ThemeCubit>();

  _i101.PackageInfoPlusAdapter get packageInfoPlusAdapter =>
      get<_i101.PackageInfoPlusAdapter>();

  _i1041.NetworkInfo get networkInfo => get<_i1041.NetworkInfo>();

  _i464.NetworkCubit get networkCubit => get<_i464.NetworkCubit>();

  _i187.ToastificationService get toastificationService =>
      get<_i187.ToastificationService>();

  _i71.SecureStorageService get secureStorageService =>
      get<_i71.SecureStorageService>();

  _i1025.SharedPrefsService get sharedPrefsService =>
      get<_i1025.SharedPrefsService>();

  _i108.StorageFacade get storageFacade => get<_i108.StorageFacade>();

  _i343.LocalizationCubit get localizationCubit =>
      get<_i343.LocalizationCubit>();

  _i426.AppInfoService get appInfoService => get<_i426.AppInfoService>();

  _i297.ThemeRepository get themeRepository => get<_i297.ThemeRepository>();

  _i784.LocalizationRepository get localizationRepository =>
      get<_i784.LocalizationRepository>();

  _i259.GameRepositoryImpl get gameRepositoryImpl =>
      get<_i259.GameRepositoryImpl>();

  _i494.SubmitRunUseCase get submitRunUseCase => get<_i494.SubmitRunUseCase>();

  _i394.GameBloc get gameBloc => get<_i394.GameBloc>();
}

class _$InjectionModule extends _i840.InjectionModule {}
