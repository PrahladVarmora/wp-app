import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/masters/model/model_sources_categories.dart';
import 'package:we_pro/modules/masters/repository/repository_master.dart';

import '../../../../core/utils/api_import.dart';

part 'sources_categories_event.dart';

part 'sources_categories_state.dart';

/// Notifies the [SourcesCategoriesBloc] of a new [SourcesCategoriesEvent] which triggers
/// [RepositoryMaster] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class SourcesCategoriesBloc
    extends Bloc<SourcesCategoriesEvent, SourcesCategoriesState> {
  SourcesCategoriesBloc({
    required RepositoryMaster repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySources = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(SourcesCategoriesInitial()) {
    on<GetSourcesCategoriesList>(_onGetSourcesCategoriesList);
  }

  List<SourcesCategories> categories = [];
  final RepositoryMaster mRepositorySources;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onGetSourcesCategoriesList] of a new [SourcesLogin] which triggers
  void _onGetSourcesCategoriesList(
    GetSourcesCategoriesList event,
    Emitter<SourcesCategoriesState> emit,
  ) async {
    emit(SourcesCategoriesLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelSourcesCategories, ModelCommonAuthorised> response =
          await mRepositorySources.callGetSourcesCategoriesListApi(
              event.url,
              event.mBody,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          categories = success.categories ?? [];
          emit(SourcesCategoriesResponse(mSourcesCategories: success));
        },
        (error) {
          ToastController.showToast(
              error.message!, getNavigatorKeyContext(), false);
          emit(SourcesCategoriesFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const SourcesCategoriesFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const SourcesCategoriesFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const SourcesCategoriesFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
