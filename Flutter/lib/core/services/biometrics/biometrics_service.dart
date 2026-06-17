abstract class BiometricsService {
  Future<bool> isBiometricsAvailable();
  Future<bool> authenticate({required String message});
}
