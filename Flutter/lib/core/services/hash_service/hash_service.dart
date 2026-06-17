import 'dart:convert';
import 'dart:developer';

import 'package:argon2/argon2.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'base_hash_service.dart';

@LazySingleton(as: BaseHashService)
class HashService implements BaseHashService {
  static const String hashSalt = 'payon_static_salt_12345678';
  static const int hashIterations = 2;
  static const int hashMemoryPower = 16;
  static const int hashLength = 32;

  @override
  Future<String> hash(String text) async {
    return _hashInBackground(text);
  }

  String _hashInBackground(String password) {
    final salt = Uint8List.fromList(hashSalt.codeUnits);
    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_i,
      salt,
      iterations: hashIterations,
      memoryPowerOf2: hashMemoryPower,
    );

    final generator = Argon2BytesGenerator()..init(parameters);
    final result = Uint8List(hashLength);
    generator.generateBytes(utf8.encode(password), result, 0, result.length);

    log('Hash Password ===> ${result.toHexString()}');
    return result.toHexString();
  }
}
