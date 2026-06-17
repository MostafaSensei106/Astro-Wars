import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../../di/di.dart';
import '../../services/l10n/l10n_service.dart';
import 'base/validation_pipeline.dart';

enum PasswordError { empty, minLength, hasEmojes, invalid, hasSpaces }

final class Password extends FormzInput<String, PasswordError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordError? validator(String value) {
    return ValidationPipeline<PasswordError>(value)
        .required(PasswordError.empty)
        .notMatches(RegExp(r'\s'), PasswordError.hasSpaces)
        .minLength(8, PasswordError.minLength)
        .evaluate();
  }
}

extension PasswordErrorExtension on PasswordError {
  String message(BuildContext context) {
    final l10n = getIt<L10nService>().get(context);
    switch (this) {
      case PasswordError.empty:
        return l10n.error_password_empty;
      case PasswordError.minLength:
        return l10n.error_password_too_short_min_8_chars;
      case PasswordError.hasEmojes:
        return l10n.error_password_emojis;
      case PasswordError.hasSpaces:
        return l10n.error_password_spaces;
      case PasswordError.invalid:
        return l10n.error_password_invalid;
    }
  }
}
