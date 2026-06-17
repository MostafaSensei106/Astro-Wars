import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:go_router/go_router.dart';
import '../../../constants/app_config.dart';

/// An app bar designed for side pages, with an optional back button and actions.
class SidePageAppBarComponent extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates a [SidePageAppBarComponent].
  ///
  /// The [title] is required. The [useBackButton] defaults to `false`.
  const SidePageAppBarComponent({
    required this.title,
    super.key,
    this.actions,
    this.bottom,
  });

  /// The title to display in the app bar.
  final String title;

  /// A list of widgets to display as actions in the app bar.
  final List<Widget>? actions;

  /// An optional bottom widget, typically a TabBar.
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  /// Navigates back to the previous screen with haptic feedback.
  void leave(final BuildContext context) {
    unawaited(HapticFeedback.vibrate());
    context.pop();
  }

  /// Checks if the current locale is Arabic.
  ///
  /// Returns `true` if the language code is 'ar', otherwise `false`.
  bool cheakLocation(final BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    return isArabic;
  }

  @override
  Widget build(final BuildContext context) => AppBar(
    flexibleSpace: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(color: Colors.transparent),
      ),
    ),
    leading: _buildSidePageAppBarIcon(
      context,
      cheakLocation(context)
          ? Icons.keyboard_double_arrow_right_rounded
          : Icons.keyboard_double_arrow_left_rounded,
    ),
    title: Text(title),
    backgroundColor: Theme.of(
      context,
    ).colorScheme.surface.withValues(alpha: 0.7),
    foregroundColor: Theme.of(context).colorScheme.onSurface,
    actionsPadding: const EdgeInsets.symmetric(horizontal: 4),
    actions: actions,
    bottom: bottom,
  );

  /// Builds the icon button for the app bar.
  Widget _buildSidePageAppBarIcon(
    final BuildContext context,
    final IconData icon,
  ) => IconButton.filled(
    style: IconButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.outBorderRadius),
      ),
      padding: const EdgeInsets.all(AppConfig.paddingQuarter),
    ),
    onPressed: () => leave(context),
    icon: Icon(icon, size: AppConfig.iconSize),
    color: Theme.of(context).colorScheme.onPrimaryContainer,
  );
}
