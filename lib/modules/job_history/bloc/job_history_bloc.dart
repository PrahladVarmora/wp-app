import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/api_service/api_provider.dart';
import 'package:we_pro/modules/core/common/modelCommon/model_common_authorised.dart';
import 'package:we_pro/modules/dashboard/model/model_job_history.dart';
import 'package:we_pro/modules/job_history/bloc/job_history_status_event.dart';
import 'package:we_pro/modules/job_history/bloc/job_history_status_state.dart';
import 'package:we_pro/modules/job_history/repository/repository_job_history.dart';

import '../../core/api_service/common_service.dart';
import '../../core/common/widgets/toast_controller.dart';

class JobHistoryBloc
    extends Bloc<JobHistoryStatusEvent, JobHistoryStatusState> {
  /* JobHistoryBloc({required RepositoryJobHistory repositoryJobHistory,
      required ApiProvider apiProvider,
      required http.Client client})
      : mRepositoryJobHistory = repositoryJobHistory,
        mClient = client,
        mApiProvider = apiProvider, super(JobHistoryInitial()){
    on<GetJobHistory>(_getJobHistory());
  };*/

  JobHistoryBloc({
    required RepositoryJobHistory repositoryJobHistory,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryJobHistory = repositoryJobHistory,
        mApiProvider = apiProvider,
        mClient = client,
        super(JobHistoryInitial()) {
    on<GetJobHistory>(_getJobHistory);
  }

  final RepositoryJobHistory mRepositoryJobHistory;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _getJobHistory(
      GetJobHistory event, Emitter<JobHistoryStatusState> emit) async {
    emit(JobHistoryLoading());
    try {
      Either<ModelJobHistory, ModelCommonAuthorised> response =
          await mRepositoryJobHistory.callJobHistoryListApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// my job list response
          printWrapped('JobHistoryResponse----');
          emit(JobHistoryResponse(mModelJobHistory: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(JobHistoryFailure(mError: error.message!));
        },
      );
    } catch (e) {
      printWrapped('JobHistoryFailure=---$e');
      emit(JobHistoryFailure(mError: e.toString()));
    }
  }
}
