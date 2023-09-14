import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/api_service/api_provider.dart';
import 'package:we_pro/modules/core/common/modelCommon/model_common_authorised.dart';
import 'package:we_pro/modules/job_detail/bloc/resend_receipt_status_event.dart';
import 'package:we_pro/modules/job_detail/bloc/resend_receipt_status_state.dart';
import 'package:we_pro/modules/job_history/repository/repository_job_history.dart';

import '../../core/api_service/common_service.dart';
import '../../core/common/widgets/toast_controller.dart';

class ResendReceiptBloc
    extends Bloc<ResendReceiptStatusEvent, ResendReceiptStatusState> {
  /* JobHistoryBloc({required RepositoryJobHistory repositoryJobHistory,
      required ApiProvider apiProvider,
      required http.Client client})
      : mRepositoryJobHistory = repositoryJobHistory,
        mClient = client,
        mApiProvider = apiProvider, super(JobHistoryInitial()){
    on<GetJobHistory>(_getJobHistory());
  };*/

  ResendReceiptBloc({
    required RepositoryJobHistory repositoryJobHistory,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryJobHistory = repositoryJobHistory,
        mApiProvider = apiProvider,
        mClient = client,
        super(ResendReceiptInitial()) {
    on<ResendReceipt>(_sendReceipt);
  }

  final RepositoryJobHistory mRepositoryJobHistory;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  void _sendReceipt(
      ResendReceipt event, Emitter<ResendReceiptStatusState> emit) async {
    emit(ResendReceiptLoading());
    try {
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryJobHistory.callResendReceiptApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// my job list response
          printWrapped('JobHistoryResponse----');
          emit(ResendReceiptResponse(mModelCommonAuthorised: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(ResendReceiptFailure(mError: error.message!));
        },
      );
    } catch (e) {
      printWrapped('JobHistoryFailure=---$e');
      emit(ResendReceiptFailure(mError: e.toString()));
    }
  }
}
