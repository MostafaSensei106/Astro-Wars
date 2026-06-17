import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_pref_storage_service.dart';

@lazySingleton
class SharedPrefsService implements BasePrefStorageService {
  const SharedPrefsService(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  @override
  Future<T?> getData<T>({required String key}) async {
    final value = _prefs.get(key);
    if (value == null) return null;
    if (value is T) {
      return value as T;
    }
    if (value is List && T == List<String>) {
      return value.cast<String>() as T;
    }
    return value as T;
  }

  @override
  Future<bool> removeData({required String key}) async {
    return await _prefs.remove(key);
  }

  @override
  Future<void> setData<T>({required String key, required T value}) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw Exception('Unsupported type');
    }
  }
}
