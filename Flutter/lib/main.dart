import 'package:astro/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'core/utils/sys_init/sys_init.dart';
import 'core/utils/theme/app_theme.dart';

void main() async {
  await SysInit.startDaemons();
  runApp(const AstroWarsApp());
}

class AstroWarsApp extends StatelessWidget {
  const AstroWarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Astro Wars',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkNeumorphicTheme,
      routerConfig: AppRouter.router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
