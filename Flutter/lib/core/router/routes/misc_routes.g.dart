// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $addAccountKycRoute,
  $createWalletRoute,
  $createWalletPinRoute,
  $profileRoute,
  $changeLanguageRoute,
  $changeThemeRoute,
  $notificationsRoute,
  $commonQuestionsRoute,
  $privacyPolicyRoute,
  $contactUsRoute,
  $sendMoneyRoute,
  $requestMoneyRoute,
  $aboutAppRoute,
  $developerTeamRoute,
  $termsAndConditionsRoute,
];

RouteBase get $addAccountKycRoute => GoRouteData.$route(
  path: '/add-account-kyc',
  factory: $AddAccountKycRoute._fromState,
);

mixin $AddAccountKycRoute on GoRouteData {
  static AddAccountKycRoute _fromState(GoRouterState state) =>
      const AddAccountKycRoute();

  @override
  String get location => GoRouteData.$location('/add-account-kyc');

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

RouteBase get $createWalletRoute => GoRouteData.$route(
  path: '/create-wallet/:accountId',
  factory: $CreateWalletRoute._fromState,
);

mixin $CreateWalletRoute on GoRouteData {
  static CreateWalletRoute _fromState(GoRouterState state) =>
      CreateWalletRoute(accountId: state.pathParameters['accountId']!);

  CreateWalletRoute get _self => this as CreateWalletRoute;

  @override
  String get location => GoRouteData.$location(
    '/create-wallet/${Uri.encodeComponent(_self.accountId)}',
  );

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

RouteBase get $createWalletPinRoute => GoRouteData.$route(
  path: '/create-wallet-pin/:accountId',
  factory: $CreateWalletPinRoute._fromState,
);

mixin $CreateWalletPinRoute on GoRouteData {
  static CreateWalletPinRoute _fromState(GoRouterState state) =>
      CreateWalletPinRoute(accountId: state.pathParameters['accountId']!);

  CreateWalletPinRoute get _self => this as CreateWalletPinRoute;

  @override
  String get location => GoRouteData.$location(
    '/create-wallet-pin/${Uri.encodeComponent(_self.accountId)}',
  );

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

RouteBase get $profileRoute =>
    GoRouteData.$route(path: '/profile', factory: $ProfileRoute._fromState);

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

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

RouteBase get $changeLanguageRoute => GoRouteData.$route(
  path: '/language',
  factory: $ChangeLanguageRoute._fromState,
);

mixin $ChangeLanguageRoute on GoRouteData {
  static ChangeLanguageRoute _fromState(GoRouterState state) =>
      const ChangeLanguageRoute();

  @override
  String get location => GoRouteData.$location('/language');

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

RouteBase get $changeThemeRoute =>
    GoRouteData.$route(path: '/theme', factory: $ChangeThemeRoute._fromState);

mixin $ChangeThemeRoute on GoRouteData {
  static ChangeThemeRoute _fromState(GoRouterState state) =>
      const ChangeThemeRoute();

  @override
  String get location => GoRouteData.$location('/theme');

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

RouteBase get $notificationsRoute => GoRouteData.$route(
  path: '/notifications',
  factory: $NotificationsRoute._fromState,
);

mixin $NotificationsRoute on GoRouteData {
  static NotificationsRoute _fromState(GoRouterState state) =>
      const NotificationsRoute();

  @override
  String get location => GoRouteData.$location('/notifications');

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

RouteBase get $commonQuestionsRoute => GoRouteData.$route(
  path: '/common-questions',
  factory: $CommonQuestionsRoute._fromState,
);

mixin $CommonQuestionsRoute on GoRouteData {
  static CommonQuestionsRoute _fromState(GoRouterState state) =>
      const CommonQuestionsRoute();

  @override
  String get location => GoRouteData.$location('/common-questions');

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

RouteBase get $privacyPolicyRoute => GoRouteData.$route(
  path: '/privacy-policy',
  factory: $PrivacyPolicyRoute._fromState,
);

mixin $PrivacyPolicyRoute on GoRouteData {
  static PrivacyPolicyRoute _fromState(GoRouterState state) =>
      const PrivacyPolicyRoute();

  @override
  String get location => GoRouteData.$location('/privacy-policy');

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

RouteBase get $contactUsRoute => GoRouteData.$route(
  path: '/contact-us',
  factory: $ContactUsRoute._fromState,
);

mixin $ContactUsRoute on GoRouteData {
  static ContactUsRoute _fromState(GoRouterState state) =>
      const ContactUsRoute();

  @override
  String get location => GoRouteData.$location('/contact-us');

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

RouteBase get $sendMoneyRoute => GoRouteData.$route(
  path: '/send-money',
  factory: $SendMoneyRoute._fromState,
);

mixin $SendMoneyRoute on GoRouteData {
  static SendMoneyRoute _fromState(GoRouterState state) => SendMoneyRoute(
    walletIndex:
        _$convertMapValue(
          'wallet-index',
          state.uri.queryParameters,
          int.parse,
        ) ??
        0,
    initialReceiver: state.uri.queryParameters['initial-receiver'],
  );

  SendMoneyRoute get _self => this as SendMoneyRoute;

  @override
  String get location => GoRouteData.$location(
    '/send-money',
    queryParams: {
      if (_self.walletIndex != 0) 'wallet-index': _self.walletIndex.toString(),
      if (_self.initialReceiver != null)
        'initial-receiver': _self.initialReceiver,
    },
  );

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

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

RouteBase get $requestMoneyRoute => GoRouteData.$route(
  path: '/request-money',
  factory: $RequestMoneyRoute._fromState,
);

mixin $RequestMoneyRoute on GoRouteData {
  static RequestMoneyRoute _fromState(GoRouterState state) =>
      const RequestMoneyRoute();

  @override
  String get location => GoRouteData.$location('/request-money');

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

RouteBase get $aboutAppRoute => GoRouteData.$route(
  path: '/app-version',
  factory: $AboutAppRoute._fromState,
);

mixin $AboutAppRoute on GoRouteData {
  static AboutAppRoute _fromState(GoRouterState state) => const AboutAppRoute();

  @override
  String get location => GoRouteData.$location('/app-version');

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

RouteBase get $developerTeamRoute => GoRouteData.$route(
  path: '/developer-team',
  factory: $DeveloperTeamRoute._fromState,
);

mixin $DeveloperTeamRoute on GoRouteData {
  static DeveloperTeamRoute _fromState(GoRouterState state) =>
      const DeveloperTeamRoute();

  @override
  String get location => GoRouteData.$location('/developer-team');

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

RouteBase get $termsAndConditionsRoute => GoRouteData.$route(
  path: '/terms-and-conditions',
  factory: $TermsAndConditionsRoute._fromState,
);

mixin $TermsAndConditionsRoute on GoRouteData {
  static TermsAndConditionsRoute _fromState(GoRouterState state) =>
      const TermsAndConditionsRoute();

  @override
  String get location => GoRouteData.$location('/terms-and-conditions');

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
