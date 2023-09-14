import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

part 'logout_event.dart';

part 'logout_state.dart';

/// Notifies the [LogoutBloc] of a new [LogoutEvent] which triggers
/// [RepositoryLogout] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc({
    required RepositoryAuth repositoryLogout,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryLogout = repositoryLogout,
        mApiProvider = apiProvider,
        mClient = client,
        super(LogoutInitial()) {
    on<LogoutUser>(_onLogoutNewUser);
  }

  final RepositoryAuth mRepositoryLogout;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onLogoutNewUser is a function that takes an LogoutUser event, an Emitter<LogoutState> emit, and returns
  /// a Future<void> that emits an LogoutLoading state, and then either an LogoutResponse state or an
  /// LogoutFailure state
  ///
  /// Args:
  ///   event (LogoutUser): The event that was dispatched.
  ///   emit (Emitter<LogoutState>): This is the function that you use to emit events.
  void _onLogoutNewUser(
    LogoutUser event,
    Emitter<LogoutState> emit,
  ) async {
    /// Emitting an LogoutLoading state.
    emit(LogoutLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryLogout.callPostLogoutApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          PreferenceHelper.remove(PreferenceHelper.authToken);
          PreferenceHelper.remove(PreferenceHelper.userData);
          PreferenceHelper.clear();

          /// Navigate to another screen
          NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            AppRoutes.routesSignIn,
            (route) => false,
          );

          emit(LogoutResponse(modelCommonAuthorised: success));
        },
        (error) {
          emit(LogoutFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const LogoutFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const LogoutFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const LogoutFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
