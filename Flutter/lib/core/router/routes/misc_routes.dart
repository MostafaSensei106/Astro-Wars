import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../modules/about_app/logic/cubit/about_app_cubit.dart';
import '../../../modules/about_app/ui/page/about_app_page.dart';
import '../../../modules/common_questions/ui/page/common_questions_page.dart';
import '../../../modules/contact_us/ui/page/contact_us_page.dart';
import '../../../modules/create_wallet/logic/cubit/create_wallet_cubit.dart';
import '../../../modules/create_wallet/ui/pages/create_wallet_page.dart';
import '../../../modules/create_wallet/ui/pages/create_wallet_pin_page.dart';
import '../../../modules/developer_team/ui/page/developer_team_page.dart';
import '../../../modules/home/logic/cubit/home_cubit.dart';
import '../../../modules/home/ui/pages/add_account_kyc_page.dart';
import '../../../modules/language/ui/page/change_language_page.dart';
import '../../../modules/notifications/ui/notifications_page.dart';
import '../../../modules/privacy_policy/ui/privacy_policy_page.dart';
import '../../../modules/profile/logic/cubit/user_profile_cubit.dart';
import '../../../modules/profile/ui/pages/profile_page.dart';
import '../../../modules/request_money/logic/cubit/request_money_cubit.dart';
import '../../../modules/request_money/ui/page/request_money_page.dart';

import '../../../modules/send_money/logic/cubit/send_money_cubit.dart';
import '../../../modules/send_money/logic/cubit/user_favorites_cubit.dart';
import '../../../modules/send_money/ui/page/send_money_page.dart';
import '../../../modules/terms_and_conditions/ui/page/terms_and_conditions_page.dart';
import '../../../modules/theme/ui/page/theme.dart';
import '../../di/di.dart';
import '../cupertion_route_data.dart';
import '../routes_names.dart';

part 'misc_routes.g.dart';

List<RouteBase> get miscRoutes => [
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
  $createWalletRoute,
  $createWalletPinRoute,
  $addAccountKycRoute,
];

@TypedGoRoute<AddAccountKycRoute>(path: RoutesNames.addAccountKyc)
final class AddAccountKycRoute extends CupertinoRouteData
    with $AddAccountKycRoute {
  const AddAccountKycRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider.value(
    value: getIt<HomeCubit>(),
    child: const AddAccountKycPage(),
  );
}

@TypedGoRoute<CreateWalletRoute>(path: '${RoutesNames.createWallet}/:accountId')
final class CreateWalletRoute extends CupertinoRouteData
    with $CreateWalletRoute {
  const CreateWalletRoute({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => getIt<CreateWalletCubit>()),
      BlocProvider.value(value: getIt<UserProfileCubit>()),
    ],
    child: CreateWalletPage(accountId: accountId),
  );
}

@TypedGoRoute<CreateWalletPinRoute>(
  path: '${RoutesNames.createWalletPin}/:accountId',
)
final class CreateWalletPinRoute extends CupertinoRouteData
    with $CreateWalletPinRoute {
  const CreateWalletPinRoute({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => getIt<CreateWalletCubit>()),
      BlocProvider.value(value: getIt<HomeCubit>()),
    ],
    child: CreateWalletPinPage(accountId: accountId),
  );
}

@TypedGoRoute<ProfileRoute>(path: RoutesNames.profile)
final class ProfileRoute extends CupertinoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider.value(
    value: getIt<UserProfileCubit>(),
    child: const ProfilePage(),
  );
}

@TypedGoRoute<ChangeLanguageRoute>(path: RoutesNames.language)
final class ChangeLanguageRoute extends CupertinoRouteData
    with $ChangeLanguageRoute {
  const ChangeLanguageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChangeLanguagePage();
}

@TypedGoRoute<ChangeThemeRoute>(path: RoutesNames.theme)
final class ChangeThemeRoute extends CupertinoRouteData with $ChangeThemeRoute {
  const ChangeThemeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChangeThemePage();
}

@TypedGoRoute<NotificationsRoute>(path: RoutesNames.notifications)
final class NotificationsRoute extends CupertinoRouteData
    with $NotificationsRoute {
  const NotificationsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NotificationsPage();
}

@TypedGoRoute<CommonQuestionsRoute>(path: RoutesNames.commonQuestions)
final class CommonQuestionsRoute extends CupertinoRouteData
    with $CommonQuestionsRoute {
  const CommonQuestionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CommonQuestionsPage();
}

@TypedGoRoute<PrivacyPolicyRoute>(path: RoutesNames.privacyPolicy)
final class PrivacyPolicyRoute extends CupertinoRouteData
    with $PrivacyPolicyRoute {
  const PrivacyPolicyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PrivacyPolicyPage();
}

@TypedGoRoute<ContactUsRoute>(path: RoutesNames.contactUs)
final class ContactUsRoute extends CupertinoRouteData with $ContactUsRoute {
  const ContactUsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ContactUsPage();
}

@TypedGoRoute<SendMoneyRoute>(path: RoutesNames.sendMoney)
final class SendMoneyRoute extends CupertinoRouteData with $SendMoneyRoute {
  const SendMoneyRoute({this.walletIndex = 0, this.initialReceiver});

  final int walletIndex;
  final String? initialReceiver;

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) {
          final cubit = getIt<SendMoneyCubit>();
          if (initialReceiver != null && initialReceiver!.isNotEmpty) {
            cubit.onUserInfChanged(initialReceiver!);
          }
          return cubit;
        },
      ),
      BlocProvider(create: (context) => getIt<UserFavoritesCubit>()),
    ],
    child: SendMoneyPage(walletIndex: walletIndex),
  );
}

@TypedGoRoute<RequestMoneyRoute>(path: RoutesNames.requestMoney)
final class RequestMoneyRoute extends CupertinoRouteData
    with $RequestMoneyRoute {
  const RequestMoneyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<RequestMoneyCubit>()),
      BlocProvider(create: (_) => getIt<UserFavoritesCubit>()),
    ],
    child: const RequestMoneyPage(),
  );
}

@TypedGoRoute<AboutAppRoute>(path: RoutesNames.appVersion)
final class AboutAppRoute extends CupertinoRouteData with $AboutAppRoute {
  const AboutAppRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => BlocProvider(
    create: (context) => getIt<AboutAppCubit>()..getAppDetails(),
    child: const AboutAppPage(),
  );
}

@TypedGoRoute<DeveloperTeamRoute>(path: RoutesNames.developerTeam)
final class DeveloperTeamRoute extends CupertinoRouteData
    with $DeveloperTeamRoute {
  const DeveloperTeamRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DeveloperTeamPage();
}

@TypedGoRoute<TermsAndConditionsRoute>(path: RoutesNames.termsAndConditions)
final class TermsAndConditionsRoute extends CupertinoRouteData
    with $TermsAndConditionsRoute {
  const TermsAndConditionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TermsAndConditionsPage();
}
