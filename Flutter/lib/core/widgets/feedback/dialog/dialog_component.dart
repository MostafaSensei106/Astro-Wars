import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../extensions/extensions.dart';

final class DialogComponent extends StatelessWidget {
  const DialogComponent({
    required this.title,
    required this.actions,
    this.content,
    this.icon,
    super.key,
  });

  final Widget title;
  final Widget? content;
  final List<Widget> actions;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }

  static Future<T?> showConfirmation<T>({
    required BuildContext context,
    required String title,
    required String body,
    required VoidCallback onConfirm,
  }) {
    return showCupertinoDialog<T>(
      context: context,
      builder: (context) => DialogComponent(
        title: Text(title, style: context.textTheme.titleMedium),
        content: Text(body, style: context.textTheme.bodyMedium),
        actions: [
          CupertinoDialogAction(
            onPressed: () => context.pop(),
            child: Text(
              context.localeKeys.cancel,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              context.pop();
              onConfirm();
            },
            child: Text(
              context.localeKeys.confirm,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showLoading(BuildContext context) {
    unawaited(
      showCupertinoDialog(
        context: context,
        builder: (context) => PopScope(
          canPop: false,
          child: DialogComponent(
            title: Text(context.localeKeys.please_wait),
            content: const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(child: CupertinoActivityIndicator()),
            ),
            actions: const [],
          ),
        ),
      ),
    );
  }

  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String error,
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => DialogComponent(
        title: Text(title, style: context.textTheme.titleMedium),
        content: Text(error, style: context.textTheme.bodyMedium),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(context.localeKeys.ok),
          ),
        ],
      ),
    );
  }

  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String body,
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => DialogComponent(
        title: Text(title, style: context.textTheme.titleMedium),
        content: Text(body, style: context.textTheme.bodyMedium),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.localeKeys.ok,
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  static Future<T?> showCustom<T>({
    required BuildContext context,
    required Widget title,
    required List<Widget> actions,
    Widget? content,
    Widget? icon,
  }) {
    return showCupertinoDialog<T>(
      context: context,
      builder: (context) =>
          DialogComponent(title: title, content: content, actions: actions),
    );
  }
}
