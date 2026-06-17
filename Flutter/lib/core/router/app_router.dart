import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes/auth_routes.dart';
import 'routes/main_shell_routes.dart';
import 'routes/misc_routes.dart';
import 'routes_names.dart';

export 'routes/auth_routes.dart' hide $appRoutes;
export 'routes/main_shell_routes.dart' hide $appRoutes;
export 'routes/misc_routes.dart';

final class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RoutesNames.welcome,
    debugLogDiagnostics: true,
    routes: [...authRoutes, ...mainShellRoutes, ...miscRoutes],
  );
}
