import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import '../../../extensions/extensions.dart';
import '../base/validation_pipeline.dart';

enum LoginPhoneValidationError { empty }

final class LoginPhoneValidator
    extends FormzInput<String, LoginPhoneValidationError> {
  const LoginPhoneValidator.pure() : super.pure('');
  const LoginPhoneValidator.dirty([super.value = '']) : super.dirty();

  @override
  LoginPhoneValidationError? validator(String value) {
    return ValidationPipeline<LoginPhoneValidationError>(
      value,
    ).required(LoginPhoneValidationError.empty).evaluate();
  }
}

extension LoginPhoneValidationErrorExtension on LoginPhoneValidationError {
  String message(BuildContext context) {
    return context.localeKeys.error_phone_number_cant_be_empty;
  }
}

enum LoginPasswordValidationError { empty }

final class LoginPasswordValidator
    extends FormzInput<String, LoginPasswordValidationError> {
  const LoginPasswordValidator.pure() : super.pure('');
  const LoginPasswordValidator.dirty([super.value = '']) : super.dirty();

  @override
  LoginPasswordValidationError? validator(String value) {
    return ValidationPipeline<LoginPasswordValidationError>(
      value,
    ).required(LoginPasswordValidationError.empty).evaluate();
  }
}

extension LoginPasswordValidationErrorExtension
    on LoginPasswordValidationError {
  String message(BuildContext context) {
    return context.localeKeys.error_password_cant_be_empty;
  }
}
