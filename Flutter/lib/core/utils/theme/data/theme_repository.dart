import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../../constants/pref_keys.dart';
import '../../../services/shared_prefs/base_pref_storage_service.dart';
import 'base_theme_repository.dart';

@LazySingleton(as: BaseThemeRepository)
class ThemeRepository implements BaseThemeRepository {
  ThemeRepository(this._storage);
  final BasePrefStorageService _storage;

  @override
  Future<void> cacheThemeMode(ThemeMode themeMode) async {
    await _storage.setData(key: PrefKeys.themeMode, value: themeMode.name);
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    final cachedThemeName = await _storage.getData<String>(
      key: PrefKeys.themeMode,
    );
    if (cachedThemeName == null) return ThemeMode.system;

    return ThemeMode.values.firstWhere(
      (e) => e.name == cachedThemeName,
      orElse: () => ThemeMode.system,
    );
  }
}
