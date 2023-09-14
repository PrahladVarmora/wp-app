import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/masters/model/model_sources.dart';
import 'package:we_pro/modules/masters/repository/repository_master.dart';

part 'sources_event.dart';

part 'sources_state.dart';

/// Notifies the [SourcesProvidersBloc] of a new [SourcesProvidersEvent] which triggers
/// [RepositoryMaster] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class SourcesProvidersBloc
    extends Bloc<SourcesProvidersEvent, SourcesProvidersState> {
  SourcesProvidersBloc({
    required RepositoryMaster repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySources = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(SourcesProvidersInitial()) {
    on<GetSourcesList>(_onSources);
  }

  List<ModelSources> sources = [];
  final RepositoryMaster mRepositorySources;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onSources] of a new [SourcesLogin] which triggers
  void _onSources(
    GetSourcesList event,
    Emitter<SourcesProvidersState> emit,
  ) async {
    emit(SourcesProvidersLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelSourcesList, ModelCommonAuthorised> response =
          await mRepositorySources.callGetSourceListApi(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          sources = success.sources ?? [];
          emit(SourcesProvidersResponse(mSourcesProviders: success));
        },
        (error) {
          ToastController.showToast(
              error.message!, getNavigatorKeyContext(), false);
          emit(SourcesProvidersFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const SourcesProvidersFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const SourcesProvidersFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const SourcesProvidersFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
