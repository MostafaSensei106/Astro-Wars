import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../constants/app_config.dart';
import '../../di/di.dart';
import '../../services/theme/theme_service.dart';
import '../navigation/app_bar/side_page_app_bar_component.dart';

extension BottomSheetExtension on BuildContext {
  Future<T?> showBottomSheetComponent<T>({
    required String title,
    required Widget child,
  }) {
    return showCupertinoModalBottomSheet<T>(
      context: this,
      isDismissible: true,
      useRootNavigator: true,
      backgroundColor: getIt<ThemeService>().get(this).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConfig.outBorderRadius),
        ),
      ),

      builder: (context) => Material(
        child: Scaffold(
          appBar: SidePageAppBarComponent(title: title),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConfig.padding,
              vertical: AppConfig.paddingHalf,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
