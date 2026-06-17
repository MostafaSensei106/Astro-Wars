// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $welcomeRoute,
  $loginRoute,
  $getStartedRoute,
  $forgetPasswordRoute,
  $changePasswordRoute,
  $twoFactorAuthRoute,
  $fingerprintAuthRoute,
  $securityAlertsRoute,
];

RouteBase get $welcomeRoute =>
    GoRouteData.$route(path: '/', factory: $WelcomeRoute._fromState);

mixin $WelcomeRoute on GoRouteData {
  static WelcomeRoute _fromState(GoRouterState state) => const WelcomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute =>
    GoRouteData.$route(path: '/login', factory: $LoginRoute._fromState);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $getStartedRoute => GoRouteData.$route(
  path: '/get-started',
  factory: $GetStartedRoute._fromState,
);

mixin $GetStartedRoute on GoRouteData {
  static GetStartedRoute _fromState(GoRouterState state) =>
      const GetStartedRoute();

  @override
  String get location => GoRouteData.$location('/get-started');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forgetPasswordRoute => GoRouteData.$route(
  path: '/forget-password',
  factory: $ForgetPasswordRoute._fromState,
);

mixin $ForgetPasswordRoute on GoRouteData {
  static ForgetPasswordRoute _fromState(GoRouterState state) =>
      const ForgetPasswordRoute();

  @override
  String get location => GoRouteData.$location('/forget-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $changePasswordRoute => GoRouteData.$route(
  path: '/change-password',
  factory: $ChangePasswordRoute._fromState,
);

mixin $ChangePasswordRoute on GoRouteData {
  static ChangePasswordRoute _fromState(GoRouterState state) =>
      const ChangePasswordRoute();

  @override
  String get location => GoRouteData.$location('/change-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $twoFactorAuthRoute => GoRouteData.$route(
  path: '/two-factor-auth',
  factory: $TwoFactorAuthRoute._fromState,
);

mixin $TwoFactorAuthRoute on GoRouteData {
  static TwoFactorAuthRoute _fromState(GoRouterState state) =>
      const TwoFactorAuthRoute();

  @override
  String get location => GoRouteData.$location('/two-factor-auth');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $fingerprintAuthRoute => GoRouteData.$route(
  path: '/fingerprint-auth',
  factory: $FingerprintAuthRoute._fromState,
);

mixin $FingerprintAuthRoute on GoRouteData {
  static FingerprintAuthRoute _fromState(GoRouterState state) =>
      const FingerprintAuthRoute();

  @override
  String get location => GoRouteData.$location('/fingerprint-auth');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $securityAlertsRoute => GoRouteData.$route(
  path: '/security-alerts',
  factory: $SecurityAlertsRoute._fromState,
);

mixin $SecurityAlertsRoute on GoRouteData {
  static SecurityAlertsRoute _fromState(GoRouterState state) =>
      const SecurityAlertsRoute();

  @override
  String get location => GoRouteData.$location('/security-alerts');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
