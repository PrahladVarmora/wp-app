import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/api_service/firebase_notification_helper.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/notifications/repository/repository_notification.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

part 'notifications_clear_list_event.dart';

part 'notifications_clear_list_state.dart';

/// Notifies the [NotificationsClearListBloc] of a new [NotificationsClearListEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class NotificationsClearListBloc
    extends Bloc<NotificationsClearListEvent, NotificationsClearListState> {
  NotificationsClearListBloc({
    required RepositoryNotification repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryNotificationsClearList = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(NotificationsClearListInitial()) {
    on<NotificationsClearList>(_onNotificationsClearList);
  }

  final RepositoryNotification mRepositoryNotificationsClearList;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onNotificationsClearList] of a new [NotificationsClearListNotificationsClearList] which triggers
  void _onNotificationsClearList(
    NotificationsClearList event,
    Emitter<NotificationsClearListState> emit,
  ) async {
    emit(const NotificationsClearListLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryNotificationsClearList.callNotificationsClearListApi(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          FirebaseNotificationHelper().clearAllNotification();
          ToastController.showToast("All Notifications Successfully Cleared",
              getNavigatorKeyContext(), true);
          emit(const NotificationsClearListResponse());
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(NotificationsClearListFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const NotificationsClearListFailure(
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
        emit(const NotificationsClearListFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const NotificationsClearListFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
