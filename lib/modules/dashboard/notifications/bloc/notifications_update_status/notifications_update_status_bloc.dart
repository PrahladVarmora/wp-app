import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/notifications/bloc/notifications_list/notifications_list_bloc.dart';
import 'package:we_pro/modules/dashboard/notifications/modal/modal_notification_list.dart';
import 'package:we_pro/modules/dashboard/notifications/repository/repository_notification.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';
import 'package:we_pro/modules/dashboard/view/screen_dashboard.dart';

part 'notifications_update_status_event.dart';

part 'notifications_update_status_state.dart';

/// Notifies the [NotificationsUpdateStatusBloc] of a new [NotificationsUpdateStatusEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class NotificationsUpdateStatusBloc extends Bloc<NotificationsUpdateStatusEvent,
    NotificationsUpdateStatusState> {
  NotificationsUpdateStatusBloc({
    required RepositoryNotification repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryNotificationsUpdateStatus = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(NotificationsUpdateStatusInitial()) {
    on<NotificationsUpdateStatus>(_onNotificationsUpdateStatus);
  }

  final RepositoryNotification mRepositoryNotificationsUpdateStatus;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onNotificationsUpdateStatus] of a new [NotificationsUpdateStatusNotificationsUpdateStatus] which triggers
  void _onNotificationsUpdateStatus(
    NotificationsUpdateStatus event,
    Emitter<NotificationsUpdateStatusState> emit,
  ) async {
    emit(NotificationsUpdateStatusLoading(
        id: event.mModalNotificationData.id ?? ''));
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryNotificationsUpdateStatus
              .callNotificationsUpdateStatusApi(
                  event.url,
                  event.body,
                  await mApiProvider.getHeaderValueWithUserToken(),
                  mApiProvider,
                  mClient);
      response.fold(
        (success) {
          if (event.mModalNotificationData.actions == 'Yes') {
            notificationRedirection(event.mModalNotificationData);
            BlocProvider.of<NotificationsListBloc>(getNavigatorKeyContext())
                .notificationDataList
                .remove(event.mModalNotificationData);
          }
          emit(NotificationsUpdateStatusResponse(
              mModalNotificationData: event.mModalNotificationData));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(NotificationsUpdateStatusFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const NotificationsUpdateStatusFailure(
          mError: ValidationString.validationNoInternetFound));
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const NotificationsUpdateStatusFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const NotificationsUpdateStatusFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }

  void notificationRedirection(ModalNotificationData mModalNotificationData) {
    BuildContext context = getNavigatorKeyContext();
    switch (mModalNotificationData.type) {
      case notificationJob:
        //TODO: Change Status and Id
        Navigator.pushNamed(context, AppRoutes.routesJobDetail, arguments: {
          AppConfig.jobStatus: statusJobAcceptReject,
          AppConfig.jobId: mModalNotificationData.typeId,
        });
        break;
      case notificationAdminChat:
        ScreenDashboardState.changeTab(1);
        Navigator.popAndPushNamed(context, AppRoutes.routesMessageAdminDetails);
        break;
      case notificationChat:
        ScreenDashboardState.changeTab(1);
        Navigator.popAndPushNamed(context, AppRoutes.routesMessageDetails,
            arguments: {
              'jobId': mModalNotificationData.typeId,
              'clientName': 'Client Name',
              'chat_type': 'Client',
              'compId': mModalNotificationData.compId ?? "",
              'company': mModalNotificationData.company ?? "",
            });
        break;
      case notificationCompanyChat:
        ScreenDashboardState.changeTab(1);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.routesMessageDetails,
          arguments: {
            'jobId': mModalNotificationData.typeId,
            'clientName': mModalNotificationData.company,
            'chat_type': 'Company',
            'compId': mModalNotificationData.compId ?? "",
            'company': mModalNotificationData.company ?? "",
          },
          (route) => route.settings.name == AppRoutes.routesDashboard,
        );
        break;
      case notificationWallet:
        //TODO: Change clientName and Id
        Navigator.pop(context);
        ScreenDashboardState.changeTab(2);
        break;
      case notificationPayment:
        //TODO: notificationPayment Redirection
        // ScreenDashboardState.changeTab(2);
        break;
      default:
        // Navigator.pushNamedAndRemoveUntil(
        //     context, AppRoutes.routesDashboard, (route) => false);
        break;
    }
  }
}
