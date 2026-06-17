import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../../constants/validation_regex.dart';
import '../../extensions/extensions.dart';
import 'base/validation_pipeline.dart';

enum FullNameError { empty, maxLenth255Characters, hasSpecialCharacters }

final class FullName extends FormzInput<String, FullNameError> {
  const FullName.pure() : super.pure('');
  const FullName.dirty([super.value = '']) : super.dirty();

  @override
  FullNameError? validator(String value) {
    return ValidationPipeline<FullNameError>(value)
        .required(FullNameError.empty)
        .notMatches(
          ValidationRegex.invalidSpecialCharsRegExp,
          FullNameError.hasSpecialCharacters,
        )
        .maxLength(255, FullNameError.maxLenth255Characters)
        .evaluate();
  }
}

extension FullNameValidationExtension on FullNameError {
  String message(BuildContext context) {
    final l = context.localeKeys;
    return switch (this) {
      FullNameError.empty => l.error_full_name_cant_be_empty,
      FullNameError.maxLenth255Characters =>
        l.error_full_name_too_long_max_255_chars,
      FullNameError.hasSpecialCharacters =>
        l.error_full_name_invalid_characters,
    };
  }
}
