import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'add_job_event.dart';

part 'add_job_state.dart';

/// Notifies the [AddJobBloc] of a new [AddJobEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class AddJobBloc extends Bloc<AddJobEvent, AddJobState> {
  AddJobBloc({
    required RepositoryJob repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAddJob = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(AddJobInitial()) {
    on<AddJob>(_onAddJob);
  }

  final RepositoryJob mRepositoryAddJob;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onAddJob] of a new [AddJob] which triggers
  void _onAddJob(
    AddJob event,
    Emitter<AddJobState> emit,
  ) async {
    emit(AddJobLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryAddJob.callPostAddJobApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          ToastController.showToast(
              success.message.toString(), getNavigatorKeyContext(), false,
              okBtnFunction: () {
            Navigator.pop(getNavigatorKeyContext());
            Navigator.pop(getNavigatorKeyContext());
          });

          emit(AddJobResponse(mModelAddJob: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(AddJobFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const AddJobFailure(
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
        emit(const AddJobFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const AddJobFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
