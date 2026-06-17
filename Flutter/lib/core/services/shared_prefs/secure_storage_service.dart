import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'base_pref_storage_service.dart';

@lazySingleton
class SecureStorageService implements BasePrefStorageService {
  const SecureStorageService(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }

  @override
  Future<T?> getData<T>({required String key}) async {
    final value = await _secureStorage.read(key: key);
    if (value == null) return null;
    return value as T;
  }

  @override
  Future<bool> removeData({required String key}) async {
    try {
      await _secureStorage.delete(key: key);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> setData<T>({required String key, required T value}) async {
    if (value is String) {
      await _secureStorage.write(key: key, value: value);
    } else {
      throw Exception('SecureStorageService only supports String values');
    }
  }
}
