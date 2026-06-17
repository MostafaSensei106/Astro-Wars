import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

import 'biometrics_service.dart';

@LazySingleton(as: BiometricsService)
final class FingerprintService implements BiometricsService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Future<bool> authenticate({required String message}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: message,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isBiometricsAvailable() async {
    try {
      final canCheck = Platform.isAndroid || Platform.isIOS
          ? await _localAuth.canCheckBiometrics
          : false;
      if (!canCheck) return false;
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      return availableBiometrics.isNotEmpty;
    } on PlatformException catch (_) {
      return false;
    }
  }
}
