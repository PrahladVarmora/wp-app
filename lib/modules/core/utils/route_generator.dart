import 'package:we_pro/modules/auth/view/contact_otp_verification.dart';
import 'package:we_pro/modules/auth/view/email_otp_verification.dart';
import 'package:we_pro/modules/auth/view/screen_add_company_code.dart';
import 'package:we_pro/modules/auth/view/screen_add_skills.dart';
import 'package:we_pro/modules/auth/view/screen_car_info.dart';
import 'package:we_pro/modules/auth/view/screen_profile_completion.dart';
import 'package:we_pro/modules/auth/view/screen_select_industry.dart';
import 'package:we_pro/modules/auth/view/screen_select_job_types.dart';
import 'package:we_pro/modules/auth/view/screen_select_make.dart';
import 'package:we_pro/modules/auth/view/screen_select_model.dart';
import 'package:we_pro/modules/auth/view/screen_select_year.dart';
import 'package:we_pro/modules/auth/view/screen_sign_in.dart';
import 'package:we_pro/modules/auth/view/screen_sign_up.dart';
import 'package:we_pro/modules/change_password/screen_change_password.dart';
import 'package:we_pro/modules/charge_now/screen_charge_now.dart';
import 'package:we_pro/modules/cms/view/screen_cms.dart';
import 'package:we_pro/modules/dashboard/job/invoice/view/screen_add_invoice.dart';
import 'package:we_pro/modules/dashboard/job/invoice/view/screen_invoice_list.dart';
import 'package:we_pro/modules/dashboard/job/invoice/view/screen_job_invoice.dart';
import 'package:we_pro/modules/dashboard/job/view/screen_add_job.dart';
import 'package:we_pro/modules/dashboard/job/view/screen_send_job_updates.dart';
import 'package:we_pro/modules/dashboard/messages/view/screen_admin_message_details.dart';
import 'package:we_pro/modules/dashboard/messages/view/screen_message_details.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/dashboard/notifications/view/screen_notifications.dart';
import 'package:we_pro/modules/dashboard/view/screen_jobs_map_view.dart';
import 'package:we_pro/modules/dashboard/view/screen_preview_map.dart';
import 'package:we_pro/modules/forgot_password/screen_forgot_password.dart';
import 'package:we_pro/modules/job_detail/view/screen_accept_job.dart';
import 'package:we_pro/modules/job_detail/view/screen_add_partial_payment.dart';
import 'package:we_pro/modules/job_detail/view/screen_check_payment_status.dart';
import 'package:we_pro/modules/job_detail/view/screen_close_job.dart';
import 'package:we_pro/modules/job_detail/view/screen_collect_payment.dart';
import 'package:we_pro/modules/job_detail/view/screen_job_accepted_successfully.dart';
import 'package:we_pro/modules/job_detail/view/screen_job_detail.dart';
import 'package:we_pro/modules/job_detail/view/screen_job_history_detail.dart';
import 'package:we_pro/modules/job_detail/view/screen_job_images.dart';
import 'package:we_pro/modules/job_detail/view/screen_payment_successfully.dart';
import 'package:we_pro/modules/job_detail/view/screen_reject_service.dart';
import 'package:we_pro/modules/job_detail/view/screen_send_message_customer.dart';
import 'package:we_pro/modules/kyc/view/screen_profile_successfully.dart';
import 'package:we_pro/modules/kyc/view/screen_send_request_kyc.dart';
import 'package:we_pro/modules/profile/model/model_get_profile.dart';
import 'package:we_pro/modules/profile/model/skills/model_industry_navigation.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_car_info.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_industry.dart';
import 'package:we_pro/modules/profile/view/screen_edit_professional_detail.dart';
import 'package:we_pro/modules/profile/view/screen_edit_profile_detail.dart';
import 'package:we_pro/modules/profile/view/screen_my_profile.dart';
import 'package:we_pro/modules/profile/view/screen_setup_stripe.dart';
import 'package:we_pro/modules/reset_password/screen_reset_password.dart';
import 'package:we_pro/modules/splash/view/screen_splash.dart';

import '../../auth/view/screen_set_availability.dart';
import '../../dashboard/view/screen_dashboard.dart';
import 'core_import.dart';

/// > RouteGenerator is a class that generates routes for the application
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    printWrapped('\x1B[32m${'Navigating to ----> ${settings.name}'}\x1B[0m');
    // ignore: unused_local_variable
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.routesSplash:
        return MaterialPageRoute(
            builder: (_) => const ScreenSplash(),
            settings: const RouteSettings(name: AppRoutes.routesSplash));
      case AppRoutes.routesSignIn:
        return MaterialPageRoute(
            builder: (_) => const ScreenSignIn(),
            settings: const RouteSettings(name: AppRoutes.routesSignIn));
      case AppRoutes.routesDashboard:
        return PageRouteBuilder(
            transitionDuration: const Duration(seconds: 0),
            pageBuilder: (context, animation1, animation2) =>
                const ScreenDashboard(),
            settings: const RouteSettings(name: AppRoutes.routesDashboard));
      case AppRoutes.routesJobsMapView:

        /// Here I have user [PageRouteBuilder] because of the jerky issue for google map on navigation
        return PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                ScreenJobsMapView(mJobData: args as List<JobData>),
            transitionDuration: const Duration(seconds: 0),
            settings: const RouteSettings(name: AppRoutes.routesJobsMapView));
      case AppRoutes.routesMapPreview:

        /// Here I have user [PageRouteBuilder] because of the jerky issue for google map on navigation
        return PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                ScreenPreviewMap(mJobData: args as List<JobData>),
            transitionDuration: const Duration(seconds: 0),
            settings: const RouteSettings(name: AppRoutes.routesMapPreview));

      case AppRoutes.routesSignUp:
        return MaterialPageRoute(
            builder: (_) => const ScreenSignUp(),
            settings: const RouteSettings(name: AppRoutes.routesSignUp));
      case AppRoutes.routesAddCompanyCode:
        return MaterialPageRoute(
            builder: (_) =>
                ScreenAddCompanyCode(mAddedCompanies: args as List<String>),
            settings:
                const RouteSettings(name: AppRoutes.routesAddCompanyCode));
      case AppRoutes.routesEditCompanyCode:
        return MaterialPageRoute(
            builder: (_) => ScreenAddCompanyCode(
                isFromEdit: true, mAddedCompanies: args as List<String>),
            settings:
                const RouteSettings(name: AppRoutes.routesEditCompanyCode));
      case AppRoutes.routesOtpEmail:
        return MaterialPageRoute(
            builder: (_) => ScreenEmailOtpVerification(
                  isVerifyEmail: args as String,
                ),
            settings: const RouteSettings(name: AppRoutes.routesOtpEmail));
      case AppRoutes.routesOtpContact:
        return MaterialPageRoute(
            builder: (_) => const ScreenContactOtpVerification(),
            settings: const RouteSettings(name: AppRoutes.routesOtpContact));
      case AppRoutes.routesForgotPassword:
        return MaterialPageRoute(
            builder: (_) => const ScreenForgotPassword(),
            settings:
                const RouteSettings(name: AppRoutes.routesForgotPassword));
      case AppRoutes.routesResetPassword:
        return MaterialPageRoute(
            builder: (_) => const ScreenResetPassword(),
            settings: const RouteSettings(name: AppRoutes.routesResetPassword));
      case AppRoutes.routesSendRequestKYC:
        return MaterialPageRoute(
            builder: (_) => const ScreenSendRequestKYC(),
            settings:
                const RouteSettings(name: AppRoutes.routesSendRequestKYC));
      case AppRoutes.routesProfileSuccessfully:
        return MaterialPageRoute(
            builder: (_) => const ScreenProfileSuccessfully(),
            settings:
                const RouteSettings(name: AppRoutes.routesProfileSuccessfully));
      case AppRoutes.routesJobAccept:
        return MaterialPageRoute(
            builder: (_) => const ScreenJobAcceptedSuccessfully(),
            settings: const RouteSettings(name: AppRoutes.routesJobAccept));
      case AppRoutes.routesPaymentSuccessfully:
        return MaterialPageRoute(
            builder: (_) =>
                ScreenPaymentSuccessfully(mJobData: args as JobData),
            settings:
                const RouteSettings(name: AppRoutes.routesPaymentSuccessfully));
      case AppRoutes.routesProfileCompletion:
        return MaterialPageRoute(
            builder: (_) => ScreenProfileCompletion(
                isFromDashboard: args != null ? (args as bool) : false),
            settings:
                const RouteSettings(name: AppRoutes.routesProfileCompletion));
      case AppRoutes.routesSetAvailability:
        return MaterialPageRoute(
            builder: (_) => ScreenSetAvailability(
                mModelBusinessHours: args as List<AvailabilityHours>),
            settings:
                const RouteSettings(name: AppRoutes.routesSetAvailability));
      case AppRoutes.routesAddSkills:
        return MaterialPageRoute(
            builder: (_) => const ScreenAddSkills(),
            settings: const RouteSettings(name: AppRoutes.routesAddSkills));
      case AppRoutes.routesSelectIndustry:
        return MaterialPageRoute(
            builder: (_) => ScreenSelectIndustry(
                mIndustryDataList: args as List<IndustryData>),
            settings:
                const RouteSettings(name: AppRoutes.routesSelectIndustry));
      case AppRoutes.routesSelectJobTypes:
        return MaterialPageRoute(
            builder: (_) =>
                ScreenSelectJobTypes(mNavData: args as ModelIndustryNavigation),
            settings:
                const RouteSettings(name: AppRoutes.routesSelectJobTypes));
      case AppRoutes.routesSelectCarDetails:
        return MaterialPageRoute(
            builder: (_) => ScreenAddCarInfo(
                mJobTypeMakeModelYear: args as JobTypeMakeModelYear),
            settings:
                const RouteSettings(name: AppRoutes.routesSelectCarDetails));
      case AppRoutes.routesSelectMake:
        return MaterialPageRoute(
            builder: (_) => ScreenSelectMake(
                mModelSelectCarMakesData: args as List<CarMakesData>),
            settings: const RouteSettings(name: AppRoutes.routesSelectMake));
      case AppRoutes.routesSelectModel:
        return MaterialPageRoute(
            builder: (_) => ScreenSelectModel(
                mModelSelectCarMakesData: args as List<CarMakesData>),
            settings: const RouteSettings(name: AppRoutes.routesSelectModel));
      case AppRoutes.routesSelectYear:
        return MaterialPageRoute(
            builder: (_) => ScreenSelectYear(
                mModelSelectCarMakesData: args as List<CarMakesData>),
            settings: const RouteSettings(name: AppRoutes.routesSelectYear));
      case AppRoutes.routesChangePassword:
        return MaterialPageRoute(
            builder: (_) => const ScreenChangePassword(),
            settings:
                const RouteSettings(name: AppRoutes.routesChangePassword));
      case AppRoutes.routesCMSWebView:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ScreenCMSWebView(
                  mTitle: arguments[AppConfig.argumentsTitle],
                  mWebUrl: arguments[AppConfig.argumentsUrl],
                ),
            settings: const RouteSettings(name: AppRoutes.routesCMSWebView));
      case AppRoutes.routesChargeNowPayment:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ScreenChargeNowPayment(
                  mJobData: arguments[AppConfig.argumentsJob],
                  mWebUrl: arguments[AppConfig.argumentsUrl],
                  isPartial: arguments[AppConfig.argumentsIsPartial],
                ),
            settings:
                const RouteSettings(name: AppRoutes.routesChargeNowPayment));
      case AppRoutes.routesMyProfile:
        return MaterialPageRoute(
            builder: (_) => const ScreenMyProfile(),
            settings: const RouteSettings(name: AppRoutes.routesMyProfile));
      case AppRoutes.routesEditProfile:
        return MaterialPageRoute(
            builder: (_) => const ScreenEditProfileDetail(),
            settings: const RouteSettings(name: AppRoutes.routesEditProfile));
      case AppRoutes.routesEditProfessionalDetail:
        return MaterialPageRoute(
            builder: (_) => const ScreenEditProfessionalDetail(),
            settings: const RouteSettings(
                name: AppRoutes.routesEditProfessionalDetail));
      case AppRoutes.routesAddJob:
        return MaterialPageRoute(
            builder: (_) => const ScreenAddJob(),
            settings: const RouteSettings(name: AppRoutes.routesAddJob));
      case AppRoutes.routesMessageDetails:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ScreenMessageDetails(
                jobId: arguments['jobId'],
                name: arguments['clientName'],
                company: arguments['company'],
                chatType: arguments['chat_type'],
                companyId: arguments['compId'],
                copyData: arguments['copyData']),
            settings:
                const RouteSettings(name: AppRoutes.routesMessageDetails));
      case AppRoutes.routesMessageAdminDetails:
        return MaterialPageRoute(
            builder: (_) => const ScreenAdminMessageDetails(),
            settings:
                const RouteSettings(name: AppRoutes.routesMessageAdminDetails));
      case AppRoutes.routesMessageAdminDetailsFromJob:
        return MaterialPageRoute(
            builder: (_) => ScreenAdminMessageDetails(
                mCopyData: args != null ? (args as String) : null),
            settings:
                const RouteSettings(name: AppRoutes.routesMessageAdminDetails));
      case AppRoutes.routesAddInvoice:
        return PageRouteBuilder(
            transitionDuration: const Duration(seconds: 0),
            pageBuilder: (context, animation1, animation2) =>
                ScreenAddInvoice(mJobData: args as JobData),
            settings: const RouteSettings(name: AppRoutes.routesAddInvoice));
      case AppRoutes.routesEditInvoiceList:
        return MaterialPageRoute(
            builder: (_) =>
                ScreenAddInvoice(mJobData: args as JobData, isEdit: true),
            settings:
                const RouteSettings(name: AppRoutes.routesEditInvoiceList));
      case AppRoutes.routesInvoiceList:
        return MaterialPageRoute(
            builder: (_) => ScreenInvoiceList(mJobData: args as JobData),
            settings: const RouteSettings(name: AppRoutes.routesInvoiceList));
      case AppRoutes.routesJobInvoice:
        return MaterialPageRoute(
            builder: (_) => const ScreenJobInvoice(),
            settings: const RouteSettings(name: AppRoutes.routesJobInvoice));
      case AppRoutes.routesSendJobUpdates:
        return PageRouteBuilder(
            transitionDuration: const Duration(seconds: 0),
            pageBuilder: (context, animation1, animation2) =>
                ScreenSendJobUpdates(jobId: args as String),
            settings:
                const RouteSettings(name: AppRoutes.routesSendJobUpdates));

      case AppRoutes.routesJobDetail:
        final arguments = settings.arguments as Map<String, dynamic>;

        /*  return MaterialPageRoute(
            builder: (_) => ScreenJobDetail(status: status),
            settings: const RouteSettings(name: AppRoutes.routesJobDetail));*/

        /// Here I have user [PageRouteBuilder] because of the jerky issue for google map on navigation
        return PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (context, animation1, animation2) => ScreenJobDetail(
                status: arguments[AppConfig.jobStatus],
                jobId: arguments[AppConfig.jobId]),
            settings: const RouteSettings(name: AppRoutes.routesJobDetail));
      case AppRoutes.routesJobHistoryDetail:
        final arguments = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                ScreenJobHistoryDetail(
                    status: arguments[AppConfig.jobStatus],
                    jobId: arguments[AppConfig.jobId]),
            transitionDuration: const Duration(seconds: 0),
            settings: const RouteSettings(name: AppRoutes.routesJobDetail));
      case AppRoutes.routesSendMessageCustomer:
        return PageRouteBuilder(
            transitionDuration: const Duration(seconds: 0),
            pageBuilder: (context, animation1, animation2) =>
                ScreenSendMessageCustomer(jobId: args as String),
            settings:
                const RouteSettings(name: AppRoutes.routesSendMessageCustomer));
      case AppRoutes.routesJobImages:
        return PageRouteBuilder(
            transitionDuration: const Duration(seconds: 0),
            pageBuilder: (context, animation1, animation2) =>
                ScreenJobImages(mJobData: args as JobData),
            settings: const RouteSettings(name: AppRoutes.routesJobImages));
      case AppRoutes.routesCollectPayment:
        return PageRouteBuilder(
            transitionDuration: const Duration(seconds: 0),
            pageBuilder: (context, animation1, animation2) =>
                ScreenCollectPayment(mJobData: args as JobData),
            settings:
                const RouteSettings(name: AppRoutes.routesCollectPayment));
      case AppRoutes.routesRejectService:
        return PageRouteBuilder(
            transitionDuration: const Duration(seconds: 0),
            pageBuilder: (context, animation1, animation2) =>
                ScreenRejectService(jobID: args as String),
            settings: const RouteSettings(name: AppRoutes.routesRejectService));
      case AppRoutes.routesCloseJob:
        return MaterialPageRoute(
            builder: (_) => ScreenCloseJob(mJobData: args as JobData),
            settings: const RouteSettings(name: AppRoutes.routesCloseJob));
      case AppRoutes.routesNotifications:
        return MaterialPageRoute(
            builder: (_) => const ScreenNotifications(),
            settings: const RouteSettings(name: AppRoutes.routesNotifications));
      case AppRoutes.routesAddPartialPayment:
        return MaterialPageRoute(
            builder: (_) => ScreenAddPartialPayment(mJobData: args as JobData),
            settings:
                const RouteSettings(name: AppRoutes.routesAddPartialPayment));
      case AppRoutes.routesPartialPaymentStatus:
        return MaterialPageRoute(
            builder: (_) => ScreenCheckPaymentStatus(mJobData: args as JobData),
            settings: const RouteSettings(
                name: AppRoutes.routesPartialPaymentStatus));
      case AppRoutes.routesAcceptJobSuccessfully:
        String jobId = args as String;
        return PageRouteBuilder(
            transitionDuration: const Duration(seconds: 0),
            pageBuilder: (context, animation1, animation2) =>
                ScreenAcceptSuccessfully(jobId: jobId),
            settings: const RouteSettings(
                name: AppRoutes.routesAcceptJobSuccessfully));
      case AppRoutes.routesSetUpStripe:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ScreenSetUpStripe(
                  mWebUrl: arguments[AppConfig.argumentsUrl],
                ),
            settings: const RouteSettings(name: AppRoutes.routesSetUpStripe));

      default:
        return MaterialPageRoute(
            builder: (_) => const ScreenSplash(),
            settings: const RouteSettings(name: AppRoutes.routesSplash));
    }
  }

  /// If the current route is the home route, return the home route name, otherwise
  /// return the route name of the current route.
  ///
  /// Args:
  ///   context (BuildContext): The current context of the app.
  static String getRouteName(BuildContext context) {
    return ModalRoute.of(context)?.settings.name ?? '';
  }

  static logoutClearData(BuildContext context) {
    // String? tmp = PreferenceHelper.getString(PreferenceHelper.fcmToken) ??
    //     PreferenceHelper.fcmToken;
    PreferenceHelper.clear();
    // PreferenceHelper.setString(PreferenceHelper.fcmToken, tmp);
    // tmp = null;
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.routesSignIn, (route) => false);
  }
}
