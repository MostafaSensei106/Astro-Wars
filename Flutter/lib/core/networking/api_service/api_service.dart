import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../modules/add_money/data/models/get_providers_response_body.dart';
import '../../../modules/change_password/data/change_password_request_body.dart';
import '../../../modules/create_wallet/data/models/create_wallet_pin_request_body.dart';
import '../../../modules/create_wallet/data/models/create_wallet_pin_response_body.dart';
import '../../../modules/create_wallet/data/models/create_wallet_request_body.dart';
import '../../../modules/create_wallet/data/models/create_wallet_response_body.dart';
import '../../../modules/create_wallet/data/models/get_currencies_response_body.dart';
import '../../../modules/forget_password/data/reset_password_request_body.dart';
import '../../../modules/get_started/data/models/account_type/account_type_response_body.dart';
import '../../../modules/get_started/data/models/get_all_countries/get_all_countries_response_body.dart';
import '../../../modules/get_started/data/models/register/create_account_request_body.dart';
import '../../../modules/get_started/data/models/register/create_account_response_body.dart';
import '../../../modules/get_started/data/models/register/register_request_body.dart';
import '../../../modules/get_started/data/models/register/register_response_body.dart';
import '../../../modules/get_started/data/models/required_files/get_required_files_response_body.dart';
import '../../../modules/get_started/data/models/send_otp/send_otp_request_body.dart';
import '../../../modules/get_started/data/models/send_otp/send_otp_response_body.dart';
import '../../../modules/get_started/data/models/verify_otp/verify_otp_request_body.dart';
import '../../../modules/get_started/data/models/verify_otp/verify_otp_response_body.dart';
import '../../../modules/home/data/models/get_transaction_response_body.dart';
import '../../../modules/home/data/models/get_wallets_response_body.dart';
import '../../../modules/login/data/models/login_request_body.dart';
import '../../../modules/login/data/models/login_response_body.dart';
import '../../../modules/profile/data/models/edit_user_porfile_response_body.dart';
import '../../../modules/profile/data/models/edit_user_profile_request_body.dart';
import '../../../modules/profile/data/models/get_user_profile_response_body.dart';
import '../../../modules/request_money/data/models/get_pending_reward_users_response_body.dart';
import '../../../modules/request_money/data/models/set_transaction_status_request_body.dart';
import '../../../modules/send_money/data/models/check_wallet/check_wallet_request_body.dart';
import '../../../modules/send_money/data/models/check_wallet/check_wallet_response_body.dart';
import '../../../modules/send_money/data/models/check_wallet_pin/check_wallet_pin_request_body.dart';
import '../../../modules/send_money/data/models/check_wallet_pin/check_wallet_pin_rsponse_body.dart';
import '../../../modules/send_money/data/models/create_transaction_draft/create_transaction_draft_request_body.dart';
import '../../../modules/send_money/data/models/create_transaction_draft/create_transaction_draft_response_body.dart';
import '../../../modules/send_money/data/models/get_favorites/get_user_favorites_response_body.dart';
import '../../../modules/send_money/data/models/save_transaction/save_transaction_request_body.dart';
import '../../../modules/send_money/data/models/save_transaction/save_transaction_response_body.dart';
import '../../constants/api_routes.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiRoutes.apiBaseURL)
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;
}
