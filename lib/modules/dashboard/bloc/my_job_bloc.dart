import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

part 'my_job_event.dart';

part 'my_job_state.dart';

/// Notifies the [MyJobBloc] of a new [MyJobEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class MyJobBloc extends Bloc<MyJobEvent, MyJobState> {
  MyJobBloc({
    required RepositoryJob repositoryMyJob,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryMyJob = repositoryMyJob,
        mApiProvider = apiProvider,
        mClient = client,
        super(MyJobInitial()) {
    on<MyJobMyJob>(_onJobList);
    on<NewJobMyJob>(_onNewJobList);
  }

  final RepositoryJob mRepositoryMyJob;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onJobList] of a new [MyJobMyJob] which triggers
  void _onJobList(
    MyJobMyJob event,
    Emitter<MyJobState> emit,
  ) async {
    emit(MyJobLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelMyJob, ModelCommonAuthorised> response =
          await mRepositoryMyJob.callPostMyJobApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          emit(MyJobResponse(mModelMyJob: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);
          emit(MyJobFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const MyJobFailure(
          mError: ValidationString.validationNoInternetFound));
    } on HttpException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const MyJobFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const MyJobFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const MyJobFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }

  /// Notifies the [_onNewJobList] of a new [MyJobMyJob] which triggers
  void _onNewJobList(
    NewJobMyJob event,
    Emitter<MyJobState> emit,
  ) async {
    emit(NewJobLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelMyJob, ModelCommonAuthorised> response =
          await mRepositoryMyJob.callPostMyJobApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// my job list response
          emit(NewJobResponse(mModelNewJob: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(MyJobFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const MyJobFailure(
          mError: ValidationString.validationNoInternetFound));
    } on HttpException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const MyJobFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const MyJobFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const MyJobFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
