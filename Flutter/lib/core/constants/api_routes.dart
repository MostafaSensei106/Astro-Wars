final class ApiRoutes {
  static const String apiBaseURL =
      'https://mahmoudappis-001-site1.jtempurl.com/api/';

  /// Account
  static const String accountGetAccountTypes = 'Account/GetAccountTypes';
  static const String accountGetAccountFiles = 'Account/GetAccountFiles';
  static const String accountSetDefaultAccount = 'Account/SetDefaultAccount';
  static const String accountGetInvitationCode = 'Account/GetInvitationCode';
  static const String accountApplyReferralCode = 'Account/ApplyReferralCode';
  static const String accountGetPendingRewardUsers =
      'Account/GetPendingRewardUsers';
  static const String accountGetRewardUsers = 'Account/GetRewardUsers';
  static const String accountGetRequiredFiles = 'Account/GetRequiredFiles';
  static const String accountUploadFiles = 'Account/UploadFiles';
  static const String accountGetUserProfile = 'Account/GetUserProfile';
  static const String accountChangeCategory = 'Account/ChangeCategory';
  static const String accountGetWallets = 'Account/GetWallets';
  static const String accountGetWalletsForWeb = 'Account/GetWalletsForWeb';
  static const String accountCreateWallet = 'Account/CreateWallet';
  static const String accountCreateAccount = 'Auth/CreateAccount';
  static const String accountCreateWalletPin = 'Account/CreateWalletPin';
  static const String accountEditWalletPin = 'Account/EditWalletPin';
  static const String accountGetUserFavorites = 'Account/GetUserFavorites';
  static const String accountGetNotifications = 'Account/GetNotifications';
  static const String accountTest = 'Account/test';
  static const String accountMarkAsRead = 'Account/MarkAsRead';
  static const String accountAddToFavorite = 'Account/AddToFavorite';
  static const String accountEditOnFavorite = 'Account/EditOnFavorite';
  static const String accountRemoveFromFavorite = 'Account/RemoveFromFavorite';
  static const String accountGetCurrencies = 'Account/GetCurrencies';
  static const String accountSetAccountStatus = 'Account/SetAccountStatus';
  static const String accountReviewAccount = 'Account/ReviewAccount';
  static const String accountGetAllAccountsForAdmin =
      'Account/GetAllAccountsForAdmin';
  static const String accountGetAllAccountsWithoutAdmin =
      'Account/GetAllAccountsWithoutAdmin';
  static const String accountGetAllAccountsTempForAdmin =
      'Account/GetAllAccountsTempForAdmin';
  static const String accountGetAllAccounts = 'Account/GetAllAccounts';
  static const String accountGetUserDocuments = 'Account/GetUserDocuments';
  static const String accountApproveFile = 'Account/ApproveFile';
  static const String accountForgetPin = 'Account/ForgetPin';
  static const String accountResetPin = 'Account/ResetPin';
  static const String accountGetAdminWallet = 'Account/GetAdminWallet';
  static const String accountGetNumberOfUsers = 'Account/GetNumberOfUsers';
  static const String accountGetUserStatusCounts =
      'Account/GetUserStatusCounts';
  static const String accountGetAllUser = 'Account/getAllUser';
  static const String accountSetParentForUser = 'Account/SetParentForUser';
  static const String accountGetAccountsByParentId =
      'Account/GetAccountsByParentId';
  static const String accountGetCountries = 'Admin/GetAllCountries';
  static const String accountGetAccountCategories =
      'Account/GetAccountCategories';
  static const String accountUpdateAccountCategory =
      'Account/UpdateAccountCategory';
  static const String accountAddAccountCategory = 'Account/AddAccountCategory';
  static const String accountAssignAccountsToSpecificCategory =
      'Account/AssignAccountsToSpecificCategory';
  static const String accountDeleteAccountCategory =
      'Account/DeleteAccountCategory';
  static const String accountGetTotalBalance = 'Account/GetTotalBalance';
  static const String accountCategoryStatistics = 'Account/CategoryStatistics';
  static const String accountGetLimitDashboard = 'Account/GetLimitDashboard';
  static const String accountGetLimitDashboardForAdmin =
      'Account/GetLimitDashboardForAdmin';
  static const String accountGetCommissionDashboard =
      'Account/GetCommissionDashboard';
  static const String accountGetInvitationList = 'Account/GetInvitationList';

  /// Auth
  static const String authLogin = 'Auth/Login';
  static const String authLogout = 'Auth/Logout';
  static const String authRegister = 'Auth/Register';
  static const String authAssignRolesToUsers = 'Auth/AssignRoleToUsers';
  static const String authGetRoles = 'Auth/GetRoles';
  static const String authSwitchToMerchantRole = 'Auth/SwitchToMerchantRole';
  static const String authRestPassword = 'Auth/RestPassword';
  static const String authChangePassword = 'Auth/ChangePassword';
  static const String authSendOTP = 'Auth/SendOTP';
  static const String authVerifyOTP = 'Auth/VerifyOTP';
  static const String authVerifySecondOTP = 'Auth/VerifySecondOTP';

  /// Invitation
  static const String invitationSend = 'invitation/send';
  static const String invitationGet = 'invitation/validate';

  /// Profile
  static const String profileEditUserProfile = 'Profile/EditUserProfile';
  static const String profileUploadImage = 'Profile/UploadImage';
  static const String profileUpdateUser = 'Profile/updateUser';

  /// SafeGuard
  static const String safeGuardCreatSafeGuardTransaction =
      'SafeGuard/CreateSafeGuardTransaction';
  static const String safeGuardGetSafeGuardTransactions =
      'SafeGuard/GetSafeGuardTransactions';
  static const String safeGuardGetSafeGuardTransactionStats =
      'SafeGuard/GetSafeGuardTransactionStats';

  ///Services
  static const String serviceGetProvidersAsync = 'Services/GetProvidersAsync';

  /// Transaction
  static const String transactionCreateTransactionDraft =
      'Transaction/CreateTransactionDraft';
  static const String transactionCreateClientPayment =
      'Transaction/CreateClientPayment';
  static const String transactionCreatePayment = 'Transaction/CreatePayment';
  static const String transactionCreateAuthorizedPayment =
      'Transaction/CreateAuthorizedPayment';
  static const String transactionUpdatePaymentLink =
      'Transaction/UpdatePaymentLink';
  static const String transactionGetMerchanOrders =
      'Transaction/GetMechanOrders';
  static const String transactionGetPaymentDetails =
      'Transaction/GetPaymentDetails';
  static const String transactionGetPaymentDetailsMoblie =
      'Transaction/GetPaymentDetailsMobile';
  static const String transactionCreateTransactionDraftForPayment =
      'Transaction/CreateTransactionDraftForPayment';
  static const String transactionCheckWalletPinForPayment =
      'Transaction/CheckWalletPinForPayment';
  static const String transactionSavePayment = 'Transaction/SavePayment';
  static const String transactionSaveTransaction =
      'Transaction/SaveTransaction';
  static const String transactionRequestPayment = 'Transaction/RequestPayment';
  static const String transactionCheckWalletPin = 'Transaction/CheckWalletPin';
  static const String transactionGetTransactions =
      'Transaction/GetTransactions';
  static const String transactionCheckWallet = 'Transaction/CheckWallet';
  static const String transactionGetTransactionsTypes =
      'Transaction/GetTransactionsTypes';
  static const String transactionGetTransactionsAdmin =
      'Transaction/GetTransactionsAdmin';
  static const String transactionGetTransactionDraftsAdmin =
      'Transaction/GetTransactionDraftsAdmin';
  static const String transactionGetAllTransactions =
      'Transaction/GetAllTransactions';
  static const String transactionGetTransactionDraft =
      'Transaction/GetTransactionDraft';
  static const String transactionSetTransactionStatus =
      'Transaction/SetTransactionStatus';
  static const String transactionGetPendingTransactions =
      'Transaction/GetPendingTransactions';
  static const String transactionTopUsers = 'Transaction/TopUsers';
  static const String transactionTransactionStatistics =
      'Transaction/TransactionStatistics';
  static const String transactionMonthlyTransactionStatistics =
      'Transaction/MonthlyTransactionStatistics';
  static const String transactionGetNumberOfTransactions =
      'Transaction/GetNumberOfTransactions';
  static const String transactionGetNumberOfTransactionForAdmin =
      'Transaction/GetNumberOfTransactionForAdmin';
  static const String transactionGetNumberOfTransactionByWeak =
      'Transaction/GetNumberOfTransactionByWeak';
  static const String transactionGetTransactionStatesLastSixMonths =
      'Transaction/GetTransactionStatesLastSixMonths';
  static const String transactionGetTransactionsByPaymentMethod =
      'Transaction/GetTransactionsByPaymentMethod';
  static const String transactionGetTransactionsSummary =
      'Transaction/GetTransactionsSummary';
  static const String transactionGetAccountStatement =
      'Transaction/GetAccountStatement';
  static const String transactionTransactionTypeStatistics =
      'Transaction/TransactionTypeStatistics';
  static const String transactionMerchantAndAgentStatistics =
      'Transaction/MerchantAndAgentStatistics';
  static const String transactionGetExchangeRate =
      'Transaction/GetExchangeRate';
  static const String transactionCurrencyExchangeDraft =
      'Transaction/CurrencyExchangeDraft';
  static const String transactionBuyCurrency = 'Transaction/BuyCurrency';
  static const String transactionGetUserTransactionsGraph =
      'Transaction/GetUserTransactionsGraph';
  static const String transactionGetUserNumberOfTransactions =
      'Transaction/GetUserNumberOfTransactions';
  static const String transactionDeleteTransactionDrafts =
      'Transaction/DeleteTransactionDrafts';
}
