import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../constants/app_config.dart';

final class OtpFieldComponent extends HookWidget {
  const OtpFieldComponent({
    required this.onCompleted,
    super.key,
    this.length = 6,
    this.onChanged,
  });
  final int length;
  final void Function(String) onCompleted;
  final void Function(String)? onChanged;

  @override
  Widget build(final BuildContext context) {
    final controllers = useMemoized(
      () => List.generate(length, (final index) => TextEditingController()),
      [length],
    );
    final focusNodes = useMemoized(
      () => List.generate(length, (final index) => FocusNode()),
      [length],
    );
    useEffect(
      () => () {
        for (var controller in controllers) {
          controller.dispose();
        }
        for (var node in focusNodes) {
          node.dispose();
        }
      },
      [controllers, focusNodes],
    );

    void handleChanged(final String value, final int index) {
      if (value.length == 1 && index < length - 1) {
        focusNodes[index + 1].requestFocus();
      }

      final otp = controllers.map((final e) => e.text).join();
      onChanged?.call(otp);
      if (otp.length == length) {
        onCompleted(otp);
      }
    }

    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    spacing: AppConfig.paddingHalf,
    children: List.generate(
      length,
      (final index) => SizedBox(
        width: AppConfig.otpFieldSize,
        height: AppConfig.otpFieldSize,
        child: KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (final event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.backspace &&
                controllers[index].text.isEmpty &&
                index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          },
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
              ),
            ),
            onChanged: (final value) => handleChanged(value, index),
          ),
        ),
      ),
    ),
    );
  }
}
