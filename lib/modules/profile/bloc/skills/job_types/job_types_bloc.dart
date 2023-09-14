import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_job_types.dart';
import 'package:we_pro/modules/profile/repository/repository_skills.dart';

import '../../../../core/utils/core_import.dart';

part 'job_types_event.dart';

part 'job_types_state.dart';

/// Notifies the [JobTypesBloc] of a new [JobTypesEvent] which triggers
/// [RepositoryMaster] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class JobTypesBloc extends Bloc<JobTypesEvent, JobTypesState> {
  JobTypesBloc({
    required RepositorySkills repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySkills = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(JobTypesInitial()) {
    printWrapped('JobTypesInitial');
    on<GetJobTypesList>(_onGetJobTypesList);
  }

  List<JobTypesData> jobTypes = [];
  final RepositorySkills mRepositorySkills;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onGetJobTypesList] of a new [JobTypesLogin] which triggers
  void _onGetJobTypesList(
    GetJobTypesList event,
    Emitter<JobTypesState> emit,
  ) async {
    emit(JobTypesLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelJobTypes, ModelCommonAuthorised> response =
          await mRepositorySkills.callGetJobTypes(
              event.url,
              event.mBody,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          jobTypes = success.jobTypes ?? [];

          emit(JobTypesResponse(mJobTypes: success));
        },
        (error) {
          ToastController.showToast(
              error.message!, getNavigatorKeyContext(), false);
          emit(JobTypesFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const JobTypesFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const JobTypesFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const JobTypesFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
