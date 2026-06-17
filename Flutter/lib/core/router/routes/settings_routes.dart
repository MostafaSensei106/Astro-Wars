import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../modules/settings/presentation/pages/settings_page.dart';
import '../../../modules/profile/presentation/pages/profile_page.dart';
import '../../../modules/theme/presentation/pages/theme_page.dart';
import '../../../modules/language/presentation/pages/language_page.dart';
import '../cupertion_route_data.dart';
import '../routes_names.dart';

part 'settings_routes.g.dart';

List<RouteBase> get settingsRoutes => [
  $settingsRoute,
  $profileRoute,
  $themeRoute,
  $languageRoute,
];

@TypedGoRoute<SettingsRoute>(path: RoutesNames.settings)
final class SettingsRoute extends CupertinoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}

@TypedGoRoute<ProfileRoute>(path: RoutesNames.profile)
final class ProfileRoute extends CupertinoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfilePage();
}

@TypedGoRoute<ThemeRoute>(path: RoutesNames.theme)
final class ThemeRoute extends CupertinoRouteData with $ThemeRoute {
  const ThemeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ThemePage();
}

@TypedGoRoute<LanguageRoute>(path: RoutesNames.language)
final class LanguageRoute extends CupertinoRouteData with $LanguageRoute {
  const LanguageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LanguagePage();
}
