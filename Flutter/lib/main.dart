import 'package:astro/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'core/utils/sys_init/sys_init.dart';

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
      routerConfig: AppRouter.router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
    );
  }
}
