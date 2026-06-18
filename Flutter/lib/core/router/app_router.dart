import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes/auth_routes.dart';
import 'routes/game_routes.dart';
import 'routes/settings_routes.dart';

import 'routes_names.dart';

export 'routes/auth_routes.dart' hide $appRoutes;

final class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RoutesNames.game,
    debugLogDiagnostics: true,
    routes: [...authRoutes, ...gameRoutes, ...settingsRoutes],
  );
}
