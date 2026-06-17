import 'package:injectable/injectable.dart';

import '../../constants/pref_keys.dart';
import 'base_pref_storage_service.dart';
import 'secure_storage_service.dart';
import 'shared_prefs_service.dart';

@LazySingleton(as: BasePrefStorageService)
class StorageFacade implements BasePrefStorageService {
  const StorageFacade({
    required this._sharedPrefsService,
    required this._secureStorageService,
  });

  final SharedPrefsService _sharedPrefsService;
  final SecureStorageService _secureStorageService;

  static const _secureKeys = {PrefKeys.userToken};

  BasePrefStorageService _getService(String key) {
    if (_secureKeys.contains(key)) {
      return _secureStorageService;
    }
    return _sharedPrefsService;
  }

  Future<void> clearSecureStorage() async {
    await _secureStorageService.clearAll();
  }

  Future<void> clearSharedPrefs() async {
    await _sharedPrefsService.clearAll();
  }

  @override
  Future<void> clearAll() async {
    await Future.wait([
      _sharedPrefsService.clearAll(),
      _secureStorageService.clearAll(),
    ]);
  }

  @override
  Future<T?> getData<T>({required String key}) async {
    return await _getService(key).getData<T>(key: key);
  }

  @override
  Future<bool> removeData({required String key}) async {
    return await _getService(key).removeData(key: key);
  }

  @override
  Future<void> setData<T>({required String key, required T value}) async {
    await _getService(key).setData<T>(key: key, value: value);
  }
}
