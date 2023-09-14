import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

import '../../../core/utils/core_import.dart';

part 'change_priority_event.dart';

part 'change_priority_state.dart';

/// Notifies the [ChangePriorityBloc] of a new [ChangePriorityEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class ChangePriorityBloc
    extends Bloc<ChangePriorityEvent, ChangePriorityState> {
  ChangePriorityBloc({
    required RepositoryJob repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryChangePriority = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(ChangePriorityInitial()) {
    on<ChangePriority>(_onChangePriority);
  }

  final RepositoryJob mRepositoryChangePriority;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onChangePriority] of a new [ChangePriorityChangePriority] which triggers
  void _onChangePriority(
    ChangePriority event,
    Emitter<ChangePriorityState> emit,
  ) async {
    emit(ChangePriorityLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryChangePriority.callPostChangePriorityApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// Navigate to another screen
          ToastController.showToastMessage(
              APPStrings.textRouteUpdated.translate(),
              getNavigatorKeyContext(),
              true);
          emit(ChangePriorityResponse(mModelChangePriority: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(ChangePriorityFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const ChangePriorityFailure(
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
        emit(const ChangePriorityFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('ChangePriorityFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const ChangePriorityFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
