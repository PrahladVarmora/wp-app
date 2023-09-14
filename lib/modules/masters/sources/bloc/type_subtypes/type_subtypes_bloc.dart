import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/masters/model/model_sources_subtypes.dart';
import 'package:we_pro/modules/masters/repository/repository_master.dart';

import '../../../../core/utils/core_import.dart';

part 'type_subtypes_event.dart';

part 'type_subtypes_state.dart';

/// Notifies the [TypeSubtypesBloc] of a new [TypeSubtypesEvent] which triggers
/// [RepositoryMaster] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class TypeSubtypesBloc extends Bloc<TypeSubtypesEvent, TypeSubtypesState> {
  TypeSubtypesBloc({
    required RepositoryMaster repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySources = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(TypeSubtypesInitial()) {
    on<GetTypeSubtypesList>(_onGetTypeSubtypesList);
  }

  final RepositoryMaster mRepositorySources;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onGetTypeSubtypesList] of a new [SourcesLogin] which triggers
  void _onGetTypeSubtypesList(
    GetTypeSubtypesList event,
    Emitter<TypeSubtypesState> emit,
  ) async {
    emit(TypeSubtypesLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelSourcesSubtypes, ModelCommonAuthorised> response =
          await mRepositorySources.callGetTypeSubtypesListApi(
              event.url,
              event.mBody,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          emit(
              TypeSubtypesResponse(mTypeSubtypes: success, index: event.index));
        },
        (error) {
          ToastController.showToast(
              error.message!, getNavigatorKeyContext(), false);
          emit(TypeSubtypesFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const TypeSubtypesFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const TypeSubtypesFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const TypeSubtypesFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
