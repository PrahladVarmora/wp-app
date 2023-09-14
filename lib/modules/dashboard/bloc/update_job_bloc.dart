import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

part 'update_job_event.dart';

part 'update_job_state.dart';

/// Notifies the [UpdateJobBloc] of a new [UpdateJobEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class UpdateJobBloc extends Bloc<UpdateJobEvent, UpdateJobState> {
  UpdateJobBloc({
    required RepositoryJob repositoryUpdateJob,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryUpdateJob = repositoryUpdateJob,
        mApiProvider = apiProvider,
        mClient = client,
        super(UpdateJobInitial()) {
    on<UpdateJobAccept>(_onUpdateJob);
    on<UpdateJobAcceptFromList>(_onUpdateJobAcceptFromList);
  }

  final RepositoryJob mRepositoryUpdateJob;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onUpdateJob] of a new [UpdateJobUpdateJob] which triggers
  void _onUpdateJob(
    UpdateJobAccept event,
    Emitter<UpdateJobState> emit,
  ) async {
    emit(UpdateJobLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryUpdateJob.callPostUpdateJobApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// Accepted Job Response
          emit(const UpdateJobAcceptResponse());
        },
        (error) {
          if (state is UpdateJobFailure) {
            ToastController.showToast(
                error.message.toString(), getNavigatorKeyContext(), false);
          }
          emit(UpdateJobFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const UpdateJobFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateJobFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateJobFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }

  /// Notifies the [_onUpdateJobAcceptFromList] of a new [UpdateJobUpdateJob] which triggers
  void _onUpdateJobAcceptFromList(
    UpdateJobAcceptFromList event,
    Emitter<UpdateJobState> emit,
  ) async {
    emit(UpdateJobLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryUpdateJob.callPostUpdateJobApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          Navigator.popAndPushNamed(
              getNavigatorKeyContext(), AppRoutes.routesJobDetail,
              arguments: {
                AppConfig.jobStatus: statusJobCollectPaymentSendInvoice,
                AppConfig.jobId: event.body[ApiParams.paramJobId]
              });
          emit(const UpdateJobAcceptResponse());
        },
        (error) {
          if (state is UpdateJobFailure) {
            ToastController.showToast(
                error.message.toString(), getNavigatorKeyContext(), false);
          }
          emit(UpdateJobFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const UpdateJobFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateJobFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateJobFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
