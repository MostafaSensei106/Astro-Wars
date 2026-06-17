import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../../constants/validation_regex.dart';
import '../../extensions/extensions.dart';
import 'base/validation_pipeline.dart';

enum EmailValidationError {
  empty,
  invalid,
  invalidCharacters,
  missingAtSign,
  notInLowerCase,
  arabicNotAllowed,
  emojiNotAllowed,
}

final class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String value) {
    return ValidationPipeline<EmailValidationError>(value)
        .required(EmailValidationError.empty)
        .contains('@', EmailValidationError.missingAtSign)
        .isLowerCase(EmailValidationError.notInLowerCase)
        .matches(ValidationRegex.emailRegExp, EmailValidationError.invalid)
        .notMatches(
          ValidationRegex.arabicRegExp,
          EmailValidationError.arabicNotAllowed,
        )
        .notMatches(
          ValidationRegex.emojiRegExp,
          EmailValidationError.emojiNotAllowed,
        )
        .evaluate();
  }
}

extension EmailValidationErrorExtension on EmailValidationError {
  String message(BuildContext context) {
    final l = context.localeKeys;
    return switch (this) {
      EmailValidationError.empty => l.error_email_cant_be_empty,
      EmailValidationError.invalid => l.error_email_not_invalid_format,
      EmailValidationError.invalidCharacters =>
        l.error_email_contains_invalid_characters,
      EmailValidationError.missingAtSign =>
        l.error_email_must_contain_at_symbol,
      EmailValidationError.notInLowerCase => l.error_email_must_be_in_lowercase,
      EmailValidationError.arabicNotAllowed => l.error_arabic_not_allowed,
      EmailValidationError.emojiNotAllowed => l.error_email_emoji_not_allowed,
    };
  }
}
