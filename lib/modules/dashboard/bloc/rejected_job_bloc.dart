import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

import '../../core/utils/api_import.dart';

part 'rejected_job_event.dart';

part 'rejected_job_state.dart';

/// Notifies the [RejectedJobBloc] of a new [RejectedJobEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class RejectedJobBloc extends Bloc<RejectedJobEvent, RejectedJobState> {
  RejectedJobBloc({
    required RepositoryJob repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryRejectedJob = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(RejectedJobInitial()) {
    on<RejectedJobList>(_onJobReject);
  }

  final RepositoryJob mRepositoryRejectedJob;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onJobReject] of a new [RejectedJobRejectedJob] which triggers
  void _onJobReject(
    RejectedJobList event,
    Emitter<RejectedJobState> emit,
  ) async {
    emit(RejectedJobLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryRejectedJob.callPostRejectedJobApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          Navigator.pushNamedAndRemoveUntil(
            getNavigatorKeyContext(),
            AppRoutes.routesDashboard,
            (route) => false,
          );

          /// Navigate to another screen
          emit(RejectedJobResponse(mModelRejectedJob: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(RejectedJobFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const RejectedJobFailure(
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
        emit(const RejectedJobFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const RejectedJobFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
