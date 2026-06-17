import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../di/di.dart';
import '../cupertion_route_data.dart';
import '../routes_names.dart';

part 'auth_routes.g.dart';

List<RouteBase> get authRoutes => [
  $welcomeRoute,
  $loginRoute,
  $getStartedRoute,
  $forgetPasswordRoute,
  $changePasswordRoute,
];

@TypedGoRoute<WelcomeRoute>(path: RoutesNames.welcome)
final class WelcomeRoute extends CupertinoRouteData with $WelcomeRoute {
  const WelcomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Scaffold(body: Center(child: Text('Welcome')));
}

@TypedGoRoute<LoginRoute>(path: RoutesNames.login)
final class LoginRoute extends CupertinoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Scaffold(body: Center(child: Text('Login')));
}

@TypedGoRoute<GetStartedRoute>(path: RoutesNames.getStarted)
final class GetStartedRoute extends CupertinoRouteData with $GetStartedRoute {
  const GetStartedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Scaffold(body: Center(child: Text('Get Started')));
}

@TypedGoRoute<ForgetPasswordRoute>(path: RoutesNames.forgetPassword)
final class ForgetPasswordRoute extends CupertinoRouteData
    with $ForgetPasswordRoute {
  const ForgetPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Scaffold(body: Center(child: Text('Forget Password')));
}

@TypedGoRoute<ChangePasswordRoute>(path: RoutesNames.changePassword)
final class ChangePasswordRoute extends CupertinoRouteData
    with $ChangePasswordRoute {
  const ChangePasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const Scaffold(body: Center(child: Text('Change Password')));
}
