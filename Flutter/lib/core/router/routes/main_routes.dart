import 'package:go_router/go_router.dart';
import '../../../modules/home/ui/page/home_page.dart';
import '../../../modules/profile/ui/page/profile_page.dart';
import '../../../modules/settings/ui/page/settings_page.dart';
import '../../../modules/theme/ui/page/theme_page.dart';
import '../routes_names.dart';

final List<RouteBase> mainRoutes = [
  GoRoute(
    path: RoutesNames.home,
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: RoutesNames.profile,
    builder: (context, state) => const ProfilePage(),
  ),
  GoRoute(
    path: RoutesNames.settings,
    builder: (context, state) => const SettingsPage(),
  ),
  GoRoute(
    path: RoutesNames.theme,
    builder: (context, state) => const ThemePage(),
  ),
];
