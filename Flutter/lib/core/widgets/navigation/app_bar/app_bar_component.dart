import 'dart:ui';

import 'package:flutter/material.dart';

/// A custom app bar widget with a transparent background and a centered title.
class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an [AppBarComponent].
  ///
  /// The [title] parameter is required.
  const AppBarComponent({required this.title, super.key, this.bottom});

  /// The title to display in the app bar.
  final String title;

  /// An optional bottom widget, typically a TabBar.
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(final BuildContext context) => AppBar(
    flexibleSpace: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(color: Colors.transparent),
      ),
    ),
    title: Text(title),
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 0,
    bottom: bottom,
  );
}
