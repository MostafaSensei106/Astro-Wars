import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../../constants/validation_regex.dart';
import '../../extensions/extensions.dart';
import 'base/validation_pipeline.dart';

enum PhoneNumberError { invalid, empty }

final class PhoneNumber extends FormzInput<String, PhoneNumberError> {
  const PhoneNumber.pure() : super.pure('');
  const PhoneNumber.dirty([super.value = '']) : super.dirty();

  @override
  PhoneNumberError? validator(String value) {
    return ValidationPipeline<PhoneNumberError>(value)
        .required(PhoneNumberError.empty)
        .matches(ValidationRegex.phoneRegExp, PhoneNumberError.invalid)
        .evaluate();
  }
}

extension PhoneNumberValidationExtension on PhoneNumberError {
  String message(BuildContext context) {
    final l = context.localeKeys;
    return switch (this) {
      PhoneNumberError.empty => l.error_phone_number_cant_be_empty,
      PhoneNumberError.invalid => l.error_phone_number_invalid,
    };
  }
}
