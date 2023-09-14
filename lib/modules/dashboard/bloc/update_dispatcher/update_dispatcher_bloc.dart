import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

import '../../../core/utils/core_import.dart';

part 'update_dispatcher_event.dart';

part 'update_dispatcher_state.dart';

/// Notifies the [UpdateDispatcherBloc] of a new [UpdateDispatcherEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class UpdateDispatcherBloc
    extends Bloc<UpdateDispatcherEvent, UpdateDispatcherState> {
  UpdateDispatcherBloc({
    required RepositoryJob repositoryUpdateDispatcher,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryUpdateDispatcher = repositoryUpdateDispatcher,
        mApiProvider = apiProvider,
        mClient = client,
        super(UpdateDispatcherInitial()) {
    on<UpdateDispatcher>(_onUpdateDispatcher);
  }

  final RepositoryJob mRepositoryUpdateDispatcher;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onUpdateDispatcher] of a new [UpdateDispatcherUpdateDispatcher] which triggers
  void _onUpdateDispatcher(
    UpdateDispatcher event,
    Emitter<UpdateDispatcherState> emit,
  ) async {
    emit(UpdateDispatcherLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryUpdateDispatcher.callPostUpdateDispatcherApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);

      response.fold(
        (success) {
          /// Navigate to another screen
          ToastController.showToast(
              success.message!, getNavigatorKeyContext(), false,
              okBtnFunction: () {
            Navigator.pop(getNavigatorKeyContext());
            Navigator.pop(getNavigatorKeyContext());
          });

          emit(UpdateDispatcherResponse(mModelUpdateDispatcher: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(UpdateDispatcherFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const UpdateDispatcherFailure(
          mError: ValidationString.validationNoInternetFound));
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateDispatcherFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('UpdateDispatcherFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateDispatcherFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
