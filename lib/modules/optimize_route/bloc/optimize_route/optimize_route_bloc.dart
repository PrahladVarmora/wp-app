import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/dashboard/view/tabs/tab_home.dart';
import 'package:we_pro/modules/optimize_route/repository/repository_optimize_route.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'optimize_route_event.dart';

part 'optimize_route_state.dart';

/// Notifies the [OptimizeRouteBloc] of a new [OptimizeRouteEvent] which triggers
/// [RepositoryOptimizeRoute] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class OptimizeRouteBloc extends Bloc<OptimizeRouteEvent, OptimizeRouteState> {
  OptimizeRouteBloc({
    required RepositoryOptimizeRoute repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryOptimizeRoute = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(OptimizeRouteInitial()) {
    on<SaveOptimizedRoute>(_onOptimizeRoute);
  }

  final RepositoryOptimizeRoute mRepositoryOptimizeRoute;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onOptimizeRoute] of a new [OptimizeRouteOptimizeRoute] which triggers
  void _onOptimizeRoute(
    SaveOptimizedRoute event,
    Emitter<OptimizeRouteState> emit,
  ) async {
    emit(OptimizeRouteLoading());
    try {
      /// This is a way to handle the response from the API call.

      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryOptimizeRoute.callOptimizeRouteApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          ToastController.showToastMessage(
              APPStrings.textRouteUpdated.translate(),
              getNavigatorKeyContext(),
              true);
          TabHomeState.refreshJobDataExternal();

          emit(OptimizeRouteResponse(mModelOptimizeRoute: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(OptimizeRouteFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(OptimizeRouteFailure(
          mError: ValidationString.validationNoInternetFound.translate()));
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
        emit(const OptimizeRouteFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('OptimizeRouteFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const OptimizeRouteFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
