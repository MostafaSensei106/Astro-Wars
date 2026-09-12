import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import 'routes_names.dart';
import '../../modules/game/ui/pages/game_page.dart';
import '../../modules/hangar/ui/page/hangar_page.dart';
import '../../modules/home/ui/page/home_page.dart';
import '../../modules/profile/ui/page/profile_page.dart';
import '../../modules/settings/ui/page/settings_page.dart';
import '../../modules/theme/ui/page/theme_page.dart';

final class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RoutesNames.base,
    debugLogDiagnostics: false,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: RoutesNames.base,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: RoutesNames.hangar,
            builder: (context, state) => const HangarPage(),
          ),
          GoRoute(
            path: RoutesNames.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: RoutesNames.game,
        builder: (context, state) {
          final level =
              int.tryParse(state.uri.queryParameters['level'] ?? '1') ?? 1;
          return GamePage(startLevel: level.clamp(1, 99));
        },
      ),
      GoRoute(
        path: RoutesNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RoutesNames.theme,
        builder: (context, state) => const ThemePage(),
      ),
    ],
  );
}
