import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../modules/home/logic/cubit/home_cubit.dart';
import '../../../modules/home/ui/pages/home_page.dart';
import '../../../modules/main/ui/pages/main_page.dart';
import '../../../modules/profile/logic/cubit/user_profile_cubit.dart';
import '../../../modules/scan_qrcode/ui/page/scan_qrcode_page.dart';
import '../../../modules/settings/ui/pages/settings_page.dart';
import '../../di/di.dart';
import '../cupertion_route_data.dart';
import '../routes_names.dart';

part 'main_shell_routes.g.dart';

List<RouteBase> get mainShellRoutes => [$mainShellRouteData];

@TypedStatefulShellRoute<MainShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRoute>(path: RoutesNames.home),
      ],
    ),
    TypedStatefulShellBranch<ScanQrCodeBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ScanQrCodeRoute>(path: RoutesNames.scanQrCode),
      ],
    ),
    // TypedStatefulShellBranch<HistoryBranchData>(
    //   routes: <TypedRoute<RouteData>>[
    //     TypedGoRoute<HistoryRoute>(path: RoutesNames.history),
    //   ],
    // ),
    TypedStatefulShellBranch<SettingsBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<SettingsRoute>(path: RoutesNames.settings),
      ],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  const MainShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<HomeCubit>()),

        BlocProvider(create: (_) => getIt<UserProfileCubit>()),
      ],
      child: MainPage(navigationShell: navigationShell),
    );
  }
}

class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();
}

class HomeRoute extends CupertinoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

class ScanQrCodeBranchData extends StatefulShellBranchData {
  const ScanQrCodeBranchData();
}

class ScanQrCodeRoute extends CupertinoRouteData with $ScanQrCodeRoute {
  const ScanQrCodeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ScanQrcodePage();
}

// class HistoryBranchData extends StatefulShellBranchData {
//   const HistoryBranchData();
// }

// class HistoryRoute extends CupertinoRouteData with $HistoryRoute {
//   const HistoryRoute();

//   @override
//   Widget build(BuildContext context, GoRouterState state) =>
//       const HistoryPage();
// }

class SettingsBranchData extends StatefulShellBranchData {
  const SettingsBranchData();
}

class SettingsRoute extends CupertinoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}
