import 'package:astro/core/router/app_router.dart';
import 'package:astro/core/utils/theme/app_theme.dart';
import 'package:astro/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AstroWarsApp extends StatelessWidget {
  const AstroWarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Astro Wars',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightNeumorphicTheme,
      darkTheme: AppTheme.darkNeumorphicTheme,
      themeMode: ThemeMode.system,
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
