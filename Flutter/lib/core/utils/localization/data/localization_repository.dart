import 'dart:ui' as ui;

import 'package:injectable/injectable.dart';

import '../../../constants/pref_keys.dart';
import '../../../services/l10n/l10n_service.dart';
import '../../../services/shared_prefs/base_pref_storage_service.dart';
import 'base_localization_repository.dart';

@LazySingleton(as: BaseLocalizationRepository)
class LocalizationRepository implements BaseLocalizationRepository {
  LocalizationRepository({required this._storage, required this._l10nService});

  final BasePrefStorageService _storage;
  final L10nService _l10nService;

  @override
  Future<void> cacheLanguageCode(String langCode) async {
    await _storage.setData<String>(key: PrefKeys.language, value: langCode);
  }

  @override
  Future<String> getLanguageCode() async {
    final cachedLanguage = await _storage.getData<String>(
      key: PrefKeys.language,
    );
    if (cachedLanguage != null) {
      return cachedLanguage;
    }

    final systemLangCode = ui.PlatformDispatcher.instance.locale.languageCode;

    if (_l10nService.supportedLocales
        .map((e) => e.languageCode)
        .contains(systemLangCode)) {
      return systemLangCode;
    }

    return _l10nService.supportedLocales.first.languageCode;
  }
}
