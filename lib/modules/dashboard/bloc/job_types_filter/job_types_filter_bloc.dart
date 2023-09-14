import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/model/model_job_types_history_filter.dart';
import 'package:we_pro/modules/masters/repository/repository_master.dart';

part 'job_types_filter_event.dart';

part 'job_types_filter_state.dart';

/// Notifies the [JobTypesFilterBloc] of a new [JobTypesFilterEvent] which triggers
/// [RepositoryMaster] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class JobTypesFilterBloc
    extends Bloc<JobTypesFilterEvent, JobTypesFilterState> {
  JobTypesFilterBloc({
    required RepositoryMaster repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryJobTypesFilter = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(JobTypesFilterInitial()) {
    on<JobTypesFilterList>(_onJobTypesFilter);
  }

  final RepositoryMaster mRepositoryJobTypesFilter;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onJobTypesFilter] of a new [JobTypesFilterLogin] which triggers
  void _onJobTypesFilter(
    JobTypesFilterList event,
    Emitter<JobTypesFilterState> emit,
  ) async {
    emit(JobTypesFilterLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelJobTypesHistoryFilter, ModelCommonAuthorised> response =
          await mRepositoryJobTypesFilter.callJobTypesFilterListApi(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          PreferenceHelper.setString(
              PreferenceHelper.jobTypesHistoryFilter, json.encode(success));
          PreferenceHelper.getString(PreferenceHelper.jobTypesHistoryFilter);
          emit(JobTypesFilterResponse(mJobTypesFilter: success));
        },
        (error) {
          ToastController.showToast(
              error.message!, getNavigatorKeyContext(), false);
          emit(JobTypesFilterFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const JobTypesFilterFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const JobTypesFilterFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const JobTypesFilterFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
