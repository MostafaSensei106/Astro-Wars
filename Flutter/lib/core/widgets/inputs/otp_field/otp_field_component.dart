import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/app_config.dart';

final class OtpFieldComponent extends StatefulWidget {
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
  State<OtpFieldComponent> createState() => _OtpFieldComponentState();
}

class _OtpFieldComponentState extends State<OtpFieldComponent> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (final index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (final index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleChanged(final String value, final int index) {
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    final otp = _controllers.map((final e) => e.text).join();
    widget.onChanged?.call(otp);
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(final BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    spacing: AppConfig.paddingHalf,
    children: List.generate(
      widget.length,
      (final index) => SizedBox(
        width: AppConfig.otpFieldSize,
        height: AppConfig.otpFieldSize,
        child: KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (final event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.backspace &&
                _controllers[index].text.isEmpty &&
                index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
              ),
            ),
            onChanged: (final value) => _handleChanged(value, index),
          ),
        ),
      ),
    ),
  );
}
