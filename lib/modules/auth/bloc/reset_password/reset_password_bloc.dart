import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

/// Notifies the [ResetPasswordBloc] of a new [ResetPasswordEvent] which triggers
/// [RepositoryAuth] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    required RepositoryAuth repositoryResetPassword,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryResetPassword = repositoryResetPassword,
        mApiProvider = apiProvider,
        mClient = client,
        super(ResetPasswordInitial()) {
    on<ResetPasswordUser>(_onResetPasswordNewUser);
  }

  final RepositoryAuth mRepositoryResetPassword;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onResetPasswordNewUser is a function that takes an ResetPasswordUser event, an Emitter<ResetPasswordState> emit, and returns
  /// a Future<void> that emits an ResetPasswordLoading state, and then either an ResetPasswordResponse state or an
  /// ResetPasswordFailure state
  ///
  /// Args:
  ///   event (ResetPasswordUser): The event that was dispatched.
  ///   emit (Emitter<ResetPasswordState>): This is the function that you use to emit events.
  void _onResetPasswordNewUser(
    ResetPasswordUser event,
    Emitter<ResetPasswordState> emit,
  ) async {
    /// Emitting an ResetPasswordLoading state.
    emit(ResetPasswordLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryResetPassword.callPostResetPasswordApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithAccessToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          PreferenceHelper.setString(PreferenceHelper.accessToken, '');

          /// Navigate to another screen
          ToastController.showToast(
              success.message!, getNavigatorKeyContext(), true);
          NavigatorKey.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            AppRoutes.routesSignIn,
            (route) => false,
          );

          emit(ResetPasswordResponse(mModelCommonAuthorised: success));
        },
        (error) {
          emit(ResetPasswordFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const ResetPasswordFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const ResetPasswordFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const ResetPasswordFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
