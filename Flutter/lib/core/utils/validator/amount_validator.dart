import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import '../../extensions/extensions.dart';

enum AmountError { empty, invalid }

final class Amount extends FormzInput<String, AmountError> {
  const Amount.pure() : super.pure('');
  const Amount.dirty([super.value = '']) : super.dirty();

  @override
  AmountError? validator(String value) {
    if (value.isEmpty) return AmountError.empty;

    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) return AmountError.invalid;

    return null;
  }
}

extension AmountExtension on AmountError {
  String message(BuildContext context) {
    final l = context.localeKeys;
    return switch (this) {
      AmountError.empty => l.error_cant_be_empty,
      AmountError.invalid => 'القيمة غير صالحة', //
    };
  }
}
