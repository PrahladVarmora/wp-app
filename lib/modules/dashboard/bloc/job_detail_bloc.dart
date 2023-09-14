import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

part 'job_detail_event.dart';

part 'job_detail_state.dart';

/// Notifies the [JobDetailBloc] of a new [JobDetailEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class JobDetailBloc extends Bloc<JobDetailEvent, JobDetailState> {
  JobDetailBloc({
    required RepositoryJob repositoryJobDetail,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryJobDetail = repositoryJobDetail,
        mApiProvider = apiProvider,
        mClient = client,
        super(JobDetailInitial()) {
    on<JobDetail>(_onJobDetail);
  }

  final RepositoryJob mRepositoryJobDetail;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onJobDetail] of a new [JobDetailJobDetail] which triggers
  void _onJobDetail(
    JobDetail event,
    Emitter<JobDetailState> emit,
  ) async {
    emit(JobDetailLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelMyJob, ModelCommonAuthorised> response =
          await mRepositoryJobDetail.callPostJobDetailApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          emit(JobDetailResponse(mModelJobDetail: success));
        },
        (error) {
          if (error.status == "401") {
            ToastController.showToastMessage(
                error.message.toString(), getNavigatorKeyContext(), false);
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(getNavigatorKeyContext());
            });
          }
          // ToastController.showToastMessage(
          //     error.message.toString(), getNavigatorKeyContext(), false);
          // Future.delayed(const Duration(seconds: 2), () {
          //   Navigator.pop(getNavigatorKeyContext());
          // });

          emit(JobDetailFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const JobDetailFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const JobDetailFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const JobDetailFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
