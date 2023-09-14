import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';
import 'package:we_pro/modules/dashboard/view/tabs/tab_home.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'job_close_event.dart';

part 'job_close_state.dart';

/// Notifies the [JobCloseBloc] of a new [JobCloseEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class JobCloseBloc extends Bloc<JobCloseEvent, JobCloseState> {
  JobCloseBloc({
    required RepositoryJob repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryJobClose = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(JobCloseInitial()) {
    on<JobClose>(_onJobClose);
  }

  final RepositoryJob mRepositoryJobClose;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onJobClose] of a new [JobCloseJobClose] which triggers
  void _onJobClose(
    JobClose event,
    Emitter<JobCloseState> emit,
  ) async {
    emit(JobCloseLoading());
    try {
      /// This is a way to handle the response from the API call.

      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryJobClose.callJobCloseApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// Navigate to another screen

          ToastController.showToast(
              success.message.toString(), getNavigatorKeyContext(), true,
              okBtnFunction: () {
            TabHomeState.refreshJobDataExternal();
            Navigator.popUntil(getNavigatorKeyContext(),
                (route) => route.settings.name == AppRoutes.routesDashboard);
          });

          emit(JobCloseResponse(mModelJobClose: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(JobCloseFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(JobCloseFailure(
          mError: ValidationString.validationNoInternetFound.translate()));
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
        emit(const JobCloseFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('JobCloseFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const JobCloseFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
