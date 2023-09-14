import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/masters/model/model_sources_category_types.dart';
import 'package:we_pro/modules/masters/repository/repository_master.dart';

import '../../../../core/utils/api_import.dart';

part 'category_types_event.dart';

part 'category_types_state.dart';

/// Notifies the [CategoryTypesBloc] of a new [CategoryTypesEvent] which triggers
/// [RepositoryMaster] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class CategoryTypesBloc extends Bloc<CategoryTypesEvent, CategoryTypesState> {
  CategoryTypesBloc({
    required RepositoryMaster repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySources = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(CategoryTypesInitial()) {
    on<GetCategoryTypesList>(_onGetCategoryTypesList);
  }

  List<CategoryTypes> categories = [];
  final RepositoryMaster mRepositorySources;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onGetCategoryTypesList] of a new [SourcesLogin] which triggers
  void _onGetCategoryTypesList(
    GetCategoryTypesList event,
    Emitter<CategoryTypesState> emit,
  ) async {
    emit(CategoryTypesLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelSourcesCategoryTypes, ModelCommonAuthorised> response =
          await mRepositorySources.callGetCategoryTypesListApi(
              event.url,
              event.mBody,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          categories = success.categoryTypes ?? [];
          emit(CategoryTypesResponse(mCategoryTypes: success));
        },
        (error) {
          ToastController.showToast(
              error.message!, getNavigatorKeyContext(), false);
          emit(CategoryTypesFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const CategoryTypesFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const CategoryTypesFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const CategoryTypesFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
