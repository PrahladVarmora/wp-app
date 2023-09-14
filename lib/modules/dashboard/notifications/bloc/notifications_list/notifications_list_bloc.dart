import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/notifications/modal/modal_notification_list.dart';
import 'package:we_pro/modules/dashboard/notifications/repository/repository_notification.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

part 'notifications_list_event.dart';

part 'notifications_list_state.dart';

/// Notifies the [NotificationsListBloc] of a new [NotificationsListEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class NotificationsListBloc
    extends Bloc<NotificationsListEvent, NotificationsListState> {
  NotificationsListBloc({
    required RepositoryNotification repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryNotificationsList = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(NotificationsListInitial()) {
    on<GetNotificationsList>(_onGetNotificationsList);
  }

  final RepositoryNotification mRepositoryNotificationsList;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  List<ModalNotificationData> notificationDataList = [];

  /// Notifies the [_onGetNotificationsList] of a new [GetNotificationsList] which triggers
  void _onGetNotificationsList(
    GetNotificationsList event,
    Emitter<NotificationsListState> emit,
  ) async {
    emit(NotificationsListLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelNotificationsList, ModelCommonAuthorised> response =
          await mRepositoryNotificationsList.callNotificationsListApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          if (event.body[ApiParams.paramPage] == '1') {
            notificationDataList = [];
          }
          notificationDataList.addAll(success.notificationDataList ?? []);
          emit(NotificationsListResponse(mModelNotificationsList: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(NotificationsListFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const NotificationsListFailure(
          mError: ValidationString.validationNoInternetFound));
    } on HttpException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const NotificationsListFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const NotificationsListFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const NotificationsListFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
