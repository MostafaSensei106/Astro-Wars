import 'biometrics_service.dart';

final class FaceIdService implements BiometricsService {
  @override
  Future<bool> authenticate({required String message}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> isBiometricsAvailable() {
    throw UnimplementedError();
  }
}
