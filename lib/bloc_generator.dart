import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/bloc/delete_account/delete_account_bloc.dart';
import 'package:we_pro/modules/auth/bloc/forgot_password/forgot_pass_verify_otp_bloc.dart';
import 'package:we_pro/modules/auth/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:we_pro/modules/auth/bloc/logout/logout_bloc.dart';
import 'package:we_pro/modules/auth/bloc/renew_and_verify_access_token/renew_access_token_bloc.dart';
import 'package:we_pro/modules/auth/bloc/renew_and_verify_access_token/verify_access_token_bloc.dart';
import 'package:we_pro/modules/auth/bloc/reset_password/reset_password_bloc.dart';
import 'package:we_pro/modules/auth/bloc/send_otp/otp_send_bloc.dart';
import 'package:we_pro/modules/auth/bloc/signIn/auth_bloc.dart';
import 'package:we_pro/modules/auth/bloc/signUp/sign_up_bloc.dart';
import 'package:we_pro/modules/auth/bloc/skills/skills_bloc.dart';
import 'package:we_pro/modules/auth/bloc/verify_otp/verify_otp_bloc.dart';
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/change_password/bloc/change_password_bloc.dart';
import 'package:we_pro/modules/change_password/repository/repository_change_password.dart';
import 'package:we_pro/modules/core/common/widgets/set_address/set_address_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/add_image/add_image_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/add_invoice/add_invoice_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/add_job/add_job_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/call_customer_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/change_priority/change_priority_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/clock_in_out/clock_in_out_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/collect_invoice/collect_invoice_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/job_close/job_close_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/job_detail_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/job_types_filter/job_types_filter_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/my_job_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/rejected_job_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/send_invoice/send_invoice_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/sub_status_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/tag_notes_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/update_dispatcher/update_dispatcher_bloc.dart';
import 'package:we_pro/modules/dashboard/bloc/update_job_bloc.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_admin_send/message_admin_send_bloc.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_chat_admin_detail/message_admin_detail_bloc.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_chat_detail/message_detail_bloc.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_chat_list/message_bloc.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_send/message_send_bloc.dart';
import 'package:we_pro/modules/dashboard/messages/repositry/repository_message.dart';
import 'package:we_pro/modules/dashboard/notifications/bloc/notifications_clear_list/notifications_clear_list_bloc.dart';
import 'package:we_pro/modules/dashboard/notifications/bloc/notifications_list/notifications_list_bloc.dart';
import 'package:we_pro/modules/dashboard/notifications/bloc/notifications_update_status/notifications_update_status_bloc.dart';
import 'package:we_pro/modules/dashboard/notifications/repository/repository_notification.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/add_money/add_money_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/approve_request/approve_request_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/request_money/request_money_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/transactions/transactions_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/bloc/transactions_download/transactions_download_bloc.dart';
import 'package:we_pro/modules/dashboard/wallet/repository/repository_wallet.dart';
import 'package:we_pro/modules/job_history/bloc/job_history_bloc.dart';
import 'package:we_pro/modules/masters/get_status/get_status_bloc.dart';
import 'package:we_pro/modules/masters/repository/repository_master.dart';
import 'package:we_pro/modules/masters/skill/bloc/skill_bloc.dart';
import 'package:we_pro/modules/masters/sources/bloc/assigned_sources_providers/sources_bloc.dart';
import 'package:we_pro/modules/masters/sources/bloc/category_types/category_types_bloc.dart';
import 'package:we_pro/modules/masters/sources/bloc/sources_categories/sources_categories_bloc.dart';
import 'package:we_pro/modules/masters/sources/bloc/type_subtypes/type_subtypes_bloc.dart';
import 'package:we_pro/modules/optimize_route/bloc/google_optimize_route/google_optimize_route_bloc.dart';
import 'package:we_pro/modules/optimize_route/bloc/optimize_route/optimize_route_bloc.dart';
import 'package:we_pro/modules/optimize_route/repository/repository_optimize_route.dart';
import 'package:we_pro/modules/profile/bloc/add_companies/add_companies_bloc.dart';
import 'package:we_pro/modules/profile/bloc/get_companies/get_companies_bloc.dart';
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/bloc/setup_stripe/setup_stripe_bloc.dart';
import 'package:we_pro/modules/profile/bloc/skills/industry/industry_bloc.dart';
import 'package:we_pro/modules/profile/bloc/skills/job_types/job_types_bloc.dart';
import 'package:we_pro/modules/profile/bloc/skills/make_model_year/make_model_year_bloc.dart';
import 'package:we_pro/modules/profile/bloc/update_availability/update_availability_bloc.dart';
import 'package:we_pro/modules/profile/bloc/update_live_location/update_live_location_bloc.dart';
import 'package:we_pro/modules/profile/bloc/update_personal_profile/update_personal_profile_bloc.dart';
import 'package:we_pro/modules/profile/bloc/update_profile/update_profile_bloc.dart';
import 'package:we_pro/modules/profile/repository/repository_profile.dart';
import 'package:we_pro/modules/profile/repository/repository_skills.dart';

import 'modules/core/api_service/api_provider.dart';
import 'modules/core/utils/core_import.dart';
import 'modules/job_detail/bloc/resend_receipt_bloc.dart';
import 'modules/job_history/repository/repository_job_history.dart';

class BlocGenerator {
  static generateBloc(
    ApiProvider apiProvider,
    http.Client client,
  ) {
    return [
      BlocProvider<SignUpBloc>(
        create: (BuildContext context) => SignUpBloc(
            apiProvider: apiProvider,
            client: client,
            repositorySignUp: RepositoryAuth()),
      ),
      BlocProvider<SourcesProvidersBloc>(
        create: (BuildContext context) => SourcesProvidersBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryMaster()),
      ),
      BlocProvider<SourcesCategoriesBloc>(
        create: (BuildContext context) => SourcesCategoriesBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryMaster()),
      ),
      BlocProvider<CategoryTypesBloc>(
        create: (BuildContext context) => CategoryTypesBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryMaster()),
      ),
      BlocProvider<TypeSubtypesBloc>(
        create: (BuildContext context) => TypeSubtypesBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryMaster()),
      ),
      BlocProvider<SkillBloc>(
        create: (BuildContext context) => SkillBloc(
            apiProvider: apiProvider,
            client: client,
            repositorySkill: RepositoryMaster()),
      ),
      BlocProvider<AuthBloc>(
        create: (BuildContext context) => AuthBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryAuth: RepositoryAuth()),
      ),
      BlocProvider<LogoutBloc>(
        create: (BuildContext context) => LogoutBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryLogout: RepositoryAuth()),
      ),
      BlocProvider<ForgotPasswordBloc>(
        create: (BuildContext context) => ForgotPasswordBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryForgotPassword: RepositoryAuth()),
      ),
      BlocProvider<OtpSendBloc>(
        create: (BuildContext context) => OtpSendBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryOtpSend: RepositoryAuth()),
      ),
      BlocProvider<VerifyOtpBloc>(
        create: (BuildContext context) => VerifyOtpBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryVerifyOtp: RepositoryAuth()),
      ),
      BlocProvider<ResetPasswordBloc>(
        create: (BuildContext context) => ResetPasswordBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryResetPassword: RepositoryAuth()),
      ),
      BlocProvider<VerifyOtpBloc>(
        create: (BuildContext context) => VerifyOtpBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryVerifyOtp: RepositoryAuth()),
      ),
      BlocProvider<VerifyAccessTokenBloc>(
        create: (BuildContext context) => VerifyAccessTokenBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryVerifyAccessToken: RepositoryAuth()),
      ),
      BlocProvider<RenewAccessTokenBloc>(
        create: (BuildContext context) => RenewAccessTokenBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryRenewAccessToken: RepositoryAuth()),
      ),
      BlocProvider<ForgotPassVerifyOtpBloc>(
        create: (BuildContext context) => ForgotPassVerifyOtpBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryForgotPassVerifyOtp: RepositoryAuth()),
      ),
      BlocProvider<GetProfileBloc>(
        create: (BuildContext context) => GetProfileBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryGetProfile: RepositoryProfile()),
      ),
      BlocProvider<UpdateProfileBloc>(
        create: (BuildContext context) => UpdateProfileBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryUpdateProfile: RepositoryProfile()),
      ),
      BlocProvider<MyJobBloc>(
        create: (BuildContext context) => MyJobBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryMyJob: RepositoryJob()),
      ),
      BlocProvider<UpdateJobBloc>(
        create: (BuildContext context) => UpdateJobBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryUpdateJob: RepositoryJob()),
      ),
      BlocProvider<JobDetailBloc>(
        create: (BuildContext context) => JobDetailBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryJobDetail: RepositoryJob()),
      ),
      BlocProvider<SubStatusBloc>(
        create: (BuildContext context) => SubStatusBloc(
            apiProvider: apiProvider,
            client: client,
            repositorySubStatus: RepositoryJob()),
      ),
      BlocProvider<RejectedJobBloc>(
        create: (BuildContext context) => RejectedJobBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryJob()),
      ),
      BlocProvider<GetStatusBloc>(
        create: (BuildContext context) => GetStatusBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryMaster()),
      ),
      BlocProvider<UpdateDispatcherBloc>(
        create: (BuildContext context) => UpdateDispatcherBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryUpdateDispatcher: RepositoryJob()),
      ),
      BlocProvider<CallCustomerBloc>(
        create: (BuildContext context) => CallCustomerBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryCallCustomer: RepositoryJob()),
      ),
      BlocProvider<ChangePasswordBloc>(
        create: (BuildContext context) => ChangePasswordBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryChangePassword: RepositoryChangePassword()),
      ),
      BlocProvider<TagNotesBloc>(
        create: (BuildContext context) => TagNotesBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryTagNotes: RepositoryJob()),
      ),
      BlocProvider<ClockInOutBloc>(
        create: (BuildContext context) => ClockInOutBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryProfile()),
      ),
      BlocProvider<IndustryBloc>(
        create: (BuildContext context) => IndustryBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositorySkills()),
      ),
      BlocProvider<JobTypesBloc>(
        create: (BuildContext context) => JobTypesBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositorySkills()),
      ),
      BlocProvider<MakeModelYearBloc>(
        create: (BuildContext context) => MakeModelYearBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositorySkills()),
      ),
      BlocProvider<UpdateAvailabilityBloc>(
        create: (BuildContext context) => UpdateAvailabilityBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryProfile()),
      ),
      BlocProvider<AddInvoiceBloc>(
        create: (BuildContext context) => AddInvoiceBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryJob()),
      ),
      BlocProvider<SetAddressBloc>(
        create: (BuildContext context) => SetAddressBloc(),
      ),
      BlocProvider<AddJobBloc>(
        create: (BuildContext context) => AddJobBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryJob()),
      ),
      BlocProvider<ChangePriorityBloc>(
        create: (BuildContext context) => ChangePriorityBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryJob()),
      ),
      BlocProvider<AddCompaniesBloc>(
        create: (BuildContext context) => AddCompaniesBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryProfile()),
      ),
      BlocProvider<SendInvoiceBloc>(
        create: (BuildContext context) => SendInvoiceBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryJob()),
      ),
      BlocProvider<AddImageBloc>(
        create: (BuildContext context) => AddImageBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryJob()),
      ),
      BlocProvider<JobHistoryBloc>(
        create: (BuildContext context) => JobHistoryBloc(
          repositoryJobHistory: RepositoryJobHistory(),
          apiProvider: apiProvider,
          client: client,
        ),
      ),
      BlocProvider<UpdateLiveLocationBloc>(
        create: (BuildContext context) => UpdateLiveLocationBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryProfile()),
      ),
      BlocProvider<GetCompaniesBloc>(
        create: (BuildContext context) => GetCompaniesBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryProfile()),
      ),
      BlocProvider<CollectInvoiceBloc>(
        create: (BuildContext context) => CollectInvoiceBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryJob()),
      ),
      BlocProvider<JobTypesFilterBloc>(
        create: (BuildContext context) => JobTypesFilterBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryMaster()),
      ),
      BlocProvider<JobCloseBloc>(
        create: (BuildContext context) => JobCloseBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryJob()),
      ),
      BlocProvider<UpdatePersonalProfileBloc>(
        create: (BuildContext context) => UpdatePersonalProfileBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryProfile()),
      ),
      BlocProvider<SkillsBloc>(
        create: (BuildContext context) => SkillsBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryAuth: RepositoryAuth()),
      ),
      BlocProvider<MessageBloc>(
        create: (BuildContext context) => MessageBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryMessage: RepositoryMessage()),
      ),
      BlocProvider<MessageDetailBloc>(
        create: (BuildContext context) => MessageDetailBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryMessage: RepositoryMessage()),
      ),
      BlocProvider<MessageSendBloc>(
        create: (BuildContext context) => MessageSendBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryMessage: RepositoryMessage()),
      ),
      BlocProvider<SetupStripeBloc>(
        create: (BuildContext context) => SetupStripeBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryProfile()),
      ),
      BlocProvider<SendAndRequestMoneyBloc>(
        create: (BuildContext context) => SendAndRequestMoneyBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryWallet()),
      ),
      BlocProvider<TransactionsBloc>(
        create: (BuildContext context) => TransactionsBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryWallet()),
      ),
      BlocProvider<TransactionsDownloadBloc>(
        create: (BuildContext context) => TransactionsDownloadBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryWallet()),
      ),
      BlocProvider<AddMoneyBloc>(
        create: (BuildContext context) => AddMoneyBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryWallet()),
      ),
      BlocProvider<MessageAdminDetailBloc>(
        create: (BuildContext context) => MessageAdminDetailBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryMessage: RepositoryMessage()),
      ),
      BlocProvider<MessageAdminSendBloc>(
        create: (BuildContext context) => MessageAdminSendBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryMessage: RepositoryMessage()),
      ),
      BlocProvider<ApproveRequestBloc>(
        create: (BuildContext context) => ApproveRequestBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryWallet()),
      ),
      BlocProvider<ResendReceiptBloc>(
        create: (BuildContext context) => ResendReceiptBloc(
            apiProvider: apiProvider,
            client: client,
            repositoryJobHistory: RepositoryJobHistory()),
      ),
      BlocProvider<NotificationsListBloc>(
        create: (BuildContext context) => NotificationsListBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryNotification()),
      ),
      BlocProvider<NotificationsUpdateStatusBloc>(
        create: (BuildContext context) => NotificationsUpdateStatusBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryNotification()),
      ),
      BlocProvider<NotificationsClearListBloc>(
        create: (BuildContext context) => NotificationsClearListBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryNotification()),
      ),
      BlocProvider<GoogleOptimizeRouteBloc>(
        create: (BuildContext context) => GoogleOptimizeRouteBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryOptimizeRoute()),
      ),
      BlocProvider<OptimizeRouteBloc>(
        create: (BuildContext context) => OptimizeRouteBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryOptimizeRoute()),
      ),
      BlocProvider<DeleteAccountBloc>(
        create: (BuildContext context) => DeleteAccountBloc(
            apiProvider: apiProvider,
            client: client,
            repository: RepositoryAuth()),
      ),
    ];
  }
}
