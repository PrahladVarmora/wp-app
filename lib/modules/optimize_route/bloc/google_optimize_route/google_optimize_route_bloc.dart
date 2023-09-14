import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/optimize_route/model/model_google_optimise_route.dart';
import 'package:we_pro/modules/optimize_route/repository/repository_optimize_route.dart';

part 'google_optimize_route_event.dart';

part 'google_optimize_route_state.dart';

/// Notifies the [GoogleOptimizeRouteBloc] of a new [GoogleOptimizeRouteEvent] which triggers
/// [RepositoryOptimizeRoute] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class GoogleOptimizeRouteBloc
    extends Bloc<GoogleOptimizeRouteEvent, GoogleOptimizeRouteState> {
  GoogleOptimizeRouteBloc({
    required RepositoryOptimizeRoute repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryGoogleOptimizeRoute = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(GoogleOptimizeRouteInitial()) {
    on<GoogleOptimizeRouteGoogleOptimizeRoute>(
        _onGoogleOptimizeRouteGoogleOptimizeRoute);
  }

  final RepositoryOptimizeRoute mRepositoryGoogleOptimizeRoute;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onGoogleOptimizeRouteGoogleOptimizeRoute] of a new [GoogleOptimizeRouteGoogleOptimizeRoute] which triggers
  void _onGoogleOptimizeRouteGoogleOptimizeRoute(
    GoogleOptimizeRouteGoogleOptimizeRoute event,
    Emitter<GoogleOptimizeRouteState> emit,
  ) async {
    emit(GoogleOptimizeRouteLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelGoogleOptimizeRoute, ModelCommonAuthorised> response =
          await mRepositoryGoogleOptimizeRoute.callPostMyJobApi(
              event.url,
              event.body,
              mApiProvider.getHeaderValueForGoogleMapAPI(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          emit(GoogleOptimizeRouteResponse(mModelGoogleOptimizeRoute: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(GoogleOptimizeRouteFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const GoogleOptimizeRouteFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const GoogleOptimizeRouteFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const GoogleOptimizeRouteFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
