abstract interface class BasePrefStorageService {
  Future<void> setData<T>({required String key, required T value});
  Future<T?> getData<T>({required String key});
  Future<bool> removeData({required String key});
  Future<void> clearAll();
}
