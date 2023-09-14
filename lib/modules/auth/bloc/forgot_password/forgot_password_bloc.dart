import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/model/model_forgot_password.dart';
import 'package:we_pro/modules/auth/model/model_user.dart';
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

/// Notifies the [ForgotPasswordBloc] of a new [ForgotPasswordEvent] which triggers
/// [RepositoryForgotPassword] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required RepositoryAuth repositoryForgotPassword,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryForgotPassword = repositoryForgotPassword,
        mApiProvider = apiProvider,
        mClient = client,
        super(ForgotPasswordInitial()) {
    on<ForgotPasswordUser>(_onForgotPasswordNewUser);
  }

  final RepositoryAuth mRepositoryForgotPassword;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onForgotPasswordNewUser is a function that takes an ForgotPasswordUser event, an Emitter<ForgotPasswordState> emit, and returns
  /// a Future<void> that emits an ForgotPasswordLoading state, and then either an ForgotPasswordResponse state or an
  /// ForgotPasswordFailure state
  ///
  /// Args:
  ///   event (ForgotPasswordUser): The event that was dispatched.
  ///   emit (Emitter<ForgotPasswordState>): This is the function that you use to emit events.
  void _onForgotPasswordNewUser(
    ForgotPasswordUser event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    /// Emitting an ForgotPasswordLoading state.
    emit(ForgotPasswordLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelUser, ModelCommonAuthorised> response =
          await mRepositoryForgotPassword.callPostForgotPasswordApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithAccessToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          PreferenceHelper.setString(
              PreferenceHelper.accessToken, success.accessToken ?? '');

          /// Navigate to another screen
          if (!event.isResend) {
            NavigatorKey.navigatorKey.currentState!.pushNamed(
                AppRoutes.routesOtpEmail,
                arguments: event.body[ApiParams.paramEmail]);
          }

          emit(ForgotPasswordResponse(mModelForgotPassword: success));
        },
        (error) {
          ToastController.showToast(
              error.message!, getNavigatorKeyContext(), false);
          emit(ForgotPasswordFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const ForgotPasswordFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const ForgotPasswordFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const ForgotPasswordFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
