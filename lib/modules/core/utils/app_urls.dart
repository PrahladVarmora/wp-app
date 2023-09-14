import 'package:flutter_flavor/flutter_flavor.dart';

/// It's a Dart class that contains nothing
class AppUrls {
  static String base = FlavorConfig.instance.variables["base"] ?? '';
  static String apiBase = FlavorConfig.instance.variables["api_base"] ?? '';
  static String baseUrl = '$base$apiBase';

  // static String baseTermsAndConditions = '${base}cms/terms-and-conditions/en/';
  static String baseTermsAndConditions = 'https://wepro.ai/terms-conditions/';
  static String basePrivacyPolicy = 'https://wepro.ai/privacy-policy/';
  static String baseFAQ = 'https://wepro.ai/list-of-faqs/';
  static String apiComputeRoutes =
      'https://routes.googleapis.com/directions/v2:computeRoutes';

  /// API
  static String apiUserLogin = '${base}technicians/auth/login/';
  static String apiDeleteAccount = '${base}technicians/users/delete_account';

  static String apiSourcesDispatchApi = '${base}dispatch/sources/assigned';
  static String apiSourcesCategoriesDispatchApi =
      '${base}dispatch/sources/categories';
  static String apiSourcesCategoryTypesApi =
      '${base}dispatch/sources/category_types';
  static String apiSourcesSubTypesApi = '${base}dispatch/sources/type_subtypes';

  static String apLogoutApi = '${base}technicians/users/logout/';
  static String apSignUpApi = '${base}technicians/auth/register/';
  static String apiForgotPasswordApi =
      '${base}technicians/auth/forgotPasswordEmail/';
  static String apiSendOTPApi = '${base}technicians/users/sendotp/';
  static String apiVerifyOTPApi = '${base}technicians/users/verifyotp/';
  static String apiResetPasswordApi = '${base}technicians/auth/resetPassword/';
  static String apiVerifyAccessTokenApi =
      '${base}technicians/users/accessToken/';
  static String apiRenewAccessTokenApi =
      '${base}technicians/users/renewAccessToken/';
  static String apiOTPVerifyForgotApi = '${base}technicians/auth/verifyotp/';
  static String apiGetProfileApi = '${base}technicians/users/profile/';
  static String apiPictureUpdateProfile =
      '${base}technicians/users/update_profile_picture/';
  static String apiDrivingLicence =
      '${base}technicians/users/update_drivinglicense/';
  static String apiUpdateProfessionalProfile =
      '${base}technicians/users/update_profile/';
  static String apiJobs = '${base}jobs/jobs/';
  static String apiUpdateJob = '${base}jobs/update_job/';
  static String apiSubStatus = '${base}jobs/sub_status';
  static String apiTagsNotes = '${base}jobs/tags_notes';
  static String apiGetStatusApi = '${base}jobs/job_status';
  static String apiCallJobUpdateApi = '${base}jobs/update_job_call';
  static String apiSendMessageApi = '${base}jobs/send_message';
  static String apiAddInvoiceApi = '${base}jobs/add_invoice';
  static String apiChangePassword = '${base}technicians/users/change_password';
  static String apiClockInOut = '${base}technicians/users/clock_in_out';
  static String apiClockInStatus = '${base}technicians/users/clockin_status';
  static String apiDispatchSourcesIndustry = '${base}dispatch/sources/industry';
  static String apiDispatchSourcesIndustryJobTypes =
      '${base}dispatch/sources/industry_job_types';
  static String apiDispatchSourcesCarInfo = '${base}dispatch/sources/car_info';
  static String apiTechniciansUsersUpdateAvailability =
      '${base}technicians/users/update_availability';
  static String apiJobsAddJobApi = '${base}jobs/add_job';
  static String apiChangePriority = '${base}jobs/change_priority';
  static String apiAddCompanies = '${base}technicians/users/add_companies';
  static String apiSendInvoice = '${base}jobs/send_invoice';
  static String apiResendReceipt = '${base}jobs/resend_receipt';
  static String apiAddImage = '${base}jobs/add_image';
  static String apiUpdateLiveLocation =
      '${base}technicians/users/update_live_location';
  static String apiGetCompanies = '${base}technicians/users/get_companies';
  static String apiGetUpdateDispatchStatusApi =
      '${base}jobs/job_status_update_dispatch';
  static String apiJobHistory = '${base}jobs/jobs_history';
  static String apiCollectInvoicePayment = '${base}jobs/collect_invoice';
  static String apiJobTypesHistoryFilter = '${base}jobs/job_types_filter';
  static String apiGetSkill = '${base}technicians/users/get_skills';
  static String apiSetSkill = '${base}technicians/users/save_skills';
  static String apiJobClose = '${base}jobs/job_close';
  static String apiOptimizeRoute = '${base}jobs/optimize_route';
  static String apiUpdatePersonalProfile =
      '${base}technicians/users/update_personal_profile';
  static String apiGetClientChatList = '${base}technicians/chats/clients';

  /// Wallet
  static String apiSetupStripe = '${base}technicians/users/setup_stripe';
  static String apiAddMoney = '${base}technicians/wallet/add_money';
  static String apiRequestMoney = '${base}technicians/wallet/request_money';
  static String apiAcceptRejectRequest =
      '${base}technicians/wallet/approve_request';
  static String apiSendMoney = '${base}technicians/wallet/send_money';
  static String apiTransactionsHistory =
      '${base}technicians/wallet/transactions';
  static String apiTransactionDownload =
      '${base}technicians/wallet/transactions_download';

  ///Chat
  static String apiChatHistory = '${base}technicians/chats/clients_history';
  static String apiSendMessage = '${base}technicians/chats/client_send';
  static String apiChatAdminHistory = '${base}technicians/chats/admin_history';
  static String apiSendAdminMessage = '${base}technicians/chats/send_admin';

  /// Notification
  static String apiNotificationsList = '${base}technicians/notifications/list';
  static String apiNotificationsRead =
      '${base}technicians/notifications/update_status';
  static String apiNotificationsClearList =
      '${base}technicians/notifications/clear_list';
}
