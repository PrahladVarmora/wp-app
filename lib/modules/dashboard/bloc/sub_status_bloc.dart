import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/job/model/model_sub_status.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

part 'sub_status_event.dart';

part 'sub_status_state.dart';

/// Notifies the [SubStatusBloc] of a new [SubStatusEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class SubStatusBloc extends Bloc<SubStatusEvent, SubStatusState> {
  SubStatusBloc({
    required RepositoryJob repositorySubStatus,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySubStatus = repositorySubStatus,
        mApiProvider = apiProvider,
        mClient = client,
        super(SubStatusInitial()) {
    on<SubStatusList>(_onJobReject);
  }

  final RepositoryJob mRepositorySubStatus;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onJobReject] of a new [SubStatusSubStatus] which triggers
  void _onJobReject(
    SubStatusList event,
    Emitter<SubStatusState> emit,
  ) async {
    emit(SubStatusLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelJobSubStatus, ModelCommonAuthorised> response =
          await mRepositorySubStatus.callPostSubStatusApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// Navigate to another screen
          emit(SubStatusResponse(mModelSubStatus: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(SubStatusFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const SubStatusFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      printWrapped('SubStatusFailure----$e');
      ToastController.showToast(e.toString(), getNavigatorKeyContext(), false);
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const SubStatusFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const SubStatusFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
