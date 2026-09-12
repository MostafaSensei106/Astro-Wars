import 'package:astro/core/di/di.dart';
import 'package:astro/core/router/app_router.dart';
import 'package:astro/core/utils/theme/app_theme.dart';
import 'package:astro/core/utils/theme/logic/cubit/theme_cubit.dart';
import 'package:astro/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AstroWarsApp extends StatelessWidget {
  const AstroWarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ThemeCubit>(),
      child: const _ThemedApp(),
    );
  }
}

class _ThemedApp extends StatelessWidget {
  const _ThemedApp();

  @override
  Widget build(BuildContext context) {
    // ThemeCubit is now actually listened to (was hardcoded system before).
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final accent = themeState.accent;
        return MaterialApp.router(
          title: 'Astro Wars',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.neonLight(accent: accent),
          darkTheme: AppTheme.neonDark(accent: accent),
          themeMode: themeState.themeMode,
          routerConfig: AppRouter.router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
