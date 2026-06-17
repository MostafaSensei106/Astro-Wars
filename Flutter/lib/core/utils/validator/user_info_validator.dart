import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import '../../extensions/extensions.dart';
import 'base/validation_pipeline.dart';

enum UserInfoError { empty }

final class UserInfo extends FormzInput<String, UserInfoError> {
  const UserInfo.pure() : super.pure('');
  const UserInfo.dirty([super.value = '']) : super.dirty();

  @override
  UserInfoError? validator(String value) {
    return ValidationPipeline<UserInfoError>(
      value,
    ).required(UserInfoError.empty).evaluate();
  }
}

extension UserInfoExtension on UserInfoError {
  String message(BuildContext context) {
    final l = context.localeKeys;
    return switch (this) {
      UserInfoError.empty => l.error_cant_be_empty,
    };
  }
}
