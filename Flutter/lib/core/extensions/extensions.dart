import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../di/di.dart';
import '../services/l10n/l10n_service.dart';
import '../services/theme/theme_service.dart';
import '../services/toast/base_toast_service.dart';
import '../widgets/feedback/dialog/dialog_component.dart';

extension LocalizationExtensions on BuildContext {
  AppLocalizations get localeKeys => getIt<L10nService>().get(this);
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}

extension ToastExtensions on BuildContext {
  BaseToastService get toast => getIt<BaseToastService>();
}

extension ThemeExtensions on BuildContext {
  ColorScheme get colorScheme => getIt<ThemeService>().get(this);
}

extension TextThemeExtensions on BuildContext {
  TextTheme get textTheme => getIt<ThemeService>().getTextTheme(this);
}

extension Uint8ListExtension on Uint8List {
  String toHexString() {
    return map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}

extension DialogExtensions on BuildContext {
  DialogProxy get dialog => DialogProxy(this);
}

class DialogProxy {
  DialogProxy(this.context);
  final BuildContext context;

  Future<T?> showDialog<T>({
    required Widget title,
    required List<Widget> actions,
    Widget? content,
    Widget? icon,
  }) {
    return DialogComponent.showCustom<T>(
      context: context,
      title: title,
      content: content,
      actions: actions,
      icon: icon,
    );
  }

  Future<T?> showConfirmation<T>({
    required String title,
    required String body,
    required VoidCallback onConfirm,
  }) {
    return DialogComponent.showConfirmation<T>(
      context: context,
      title: title,
      body: body,
      onConfirm: onConfirm,
    );
  }

  void showLoading() {
    DialogComponent.showLoading(context);
  }

  Future<void> showInfo({required String title, required String body}) {
    return DialogComponent.showInfo(context: context, title: title, body: body);
  }

  Future<void> showError({required String title, required String error}) {
    return DialogComponent.showError(
      context: context,
      title: title,
      error: error,
    );
  }
}
