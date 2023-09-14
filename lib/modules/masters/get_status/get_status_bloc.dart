import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/masters/model/model_get_status.dart';
import 'package:we_pro/modules/masters/repository/repository_master.dart';

part 'get_status_event.dart';

part 'get_status_state.dart';

/// Notifies the [GetStatusBloc] of a new [GetStatusEvent] which triggers
/// [RepositoryMaster] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class GetStatusBloc extends Bloc<GetStatusEvent, GetStatusState> {
  GetStatusBloc({
    required RepositoryMaster repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryGetStatus = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetStatusInitial()) {
    on<GetStatusList>(_onGetStatus);
  }

  final RepositoryMaster mRepositoryGetStatus;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onGetStatus] of a new [GetStatusLogin] which triggers
  void _onGetStatus(
    GetStatusList event,
    Emitter<GetStatusState> emit,
  ) async {
    emit(GetStatusLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelGetStatus, ModelCommonAuthorised> response =
          await mRepositoryGetStatus.callGetStatusListApi(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          PreferenceHelper.setString(
              event.isUpdateDispatchStatus
                  ? PreferenceHelper.userGetUpdateDispatchStatusList
                  : PreferenceHelper.userGetStatusList,
              json.encode(success));
          emit(GetStatusResponse(mGetStatus: success));
        },
        (error) {
          ToastController.showToast(
              error.message!, getNavigatorKeyContext(), false);
          emit(GetStatusFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const GetStatusFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const GetStatusFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const GetStatusFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
