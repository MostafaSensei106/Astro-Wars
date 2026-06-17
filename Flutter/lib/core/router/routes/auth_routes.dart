import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../modules/fingerprint_auth/logic/cubit/security_cubit.dart';
import '../../../modules/fingerprint_auth/ui/page/fingerprint_auth_page.dart';
import '../../../modules/forget_password/ui/page/forget_password_page.dart';
import '../../../modules/get_started/logic/cubit/account_type/account_type_cubit.dart';
import '../../../modules/get_started/logic/cubit/otp/otp_cubit.dart';
import '../../../modules/get_started/logic/cubit/register/register_cubit.dart';
import '../../../modules/get_started/ui/pages/get_started_page.dart';
import '../../../modules/login/logic/cubit/login_cubit.dart';
import '../../../modules/login/ui/pages/login_page.dart';
import '../../../modules/security_alerts/ui/page/security_alerts_page.dart';
import '../../../modules/two_factor_auth/ui/page/two_factor_auth.dart';
import '../../../modules/welcome/ui/pages/welcome_page.dart';
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
  $twoFactorAuthRoute,
  $fingerprintAuthRoute,
  $securityAlertsRoute,
];

@TypedGoRoute<WelcomeRoute>(path: RoutesNames.welcome)
final class WelcomeRoute extends CupertinoRouteData with $WelcomeRoute {
  const WelcomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WelcomePage();
}

@TypedGoRoute<LoginRoute>(path: RoutesNames.login)
final class LoginRoute extends CupertinoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (_) => getIt<LoginCubit>(),
    child: const LoginPage(),
  );
}

@TypedGoRoute<GetStartedRoute>(path: RoutesNames.getStarted)
final class GetStartedRoute extends CupertinoRouteData with $GetStartedRoute {
  const GetStartedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<RegisterCubit>()),
      BlocProvider(create: (_) => getIt<AccountTypeCubit>()),
      BlocProvider(create: (_) => getIt<OtpCubit>()),
    ],
    child: const GetStartedPage(),
  );
}

@TypedGoRoute<ForgetPasswordRoute>(path: RoutesNames.forgetPassword)
final class ForgetPasswordRoute extends CupertinoRouteData
    with $ForgetPasswordRoute {
  const ForgetPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgetPasswordPage();
}

@TypedGoRoute<ChangePasswordRoute>(path: RoutesNames.changePassword)
final class ChangePasswordRoute extends CupertinoRouteData
    with $ChangePasswordRoute {
  const ChangePasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgetPasswordPage();
}

@TypedGoRoute<TwoFactorAuthRoute>(path: RoutesNames.twoFactorAuth)
final class TwoFactorAuthRoute extends CupertinoRouteData
    with $TwoFactorAuthRoute {
  const TwoFactorAuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TwoFactorAuth();
}

@TypedGoRoute<FingerprintAuthRoute>(path: RoutesNames.fingerprintAuth)
final class FingerprintAuthRoute extends CupertinoRouteData
    with $FingerprintAuthRoute {
  const FingerprintAuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (_) => getIt<SecurityCubit>(),
    child: const FingerprintAuthPage(),
  );
}

@TypedGoRoute<SecurityAlertsRoute>(path: RoutesNames.securityAlerts)
final class SecurityAlertsRoute extends CupertinoRouteData
    with $SecurityAlertsRoute {
  const SecurityAlertsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SecurityAlertsPage();
}
