abstract class BaseLocalizationRepository {
  Future<void> cacheLanguageCode(String langCode);
  Future<String> getLanguageCode();
}
