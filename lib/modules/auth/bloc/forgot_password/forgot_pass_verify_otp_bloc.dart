import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/model/model_user.dart';
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

part 'forgot_pass_verify_otp_event.dart';

part 'forgot_pass_verify_otp_state.dart';

/// Notifies the [ForgotPassVerifyOtpBloc] of a new [ForgotPassVerifyOtpEvent] which triggers
/// [RepositoryForgotPassVerifyOtp] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class ForgotPassVerifyOtpBloc
    extends Bloc<ForgotPassVerifyOtpEvent, ForgotPassVerifyOtpState> {
  ForgotPassVerifyOtpBloc({
    required RepositoryAuth repositoryForgotPassVerifyOtp,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryForgotPassVerifyOtp = repositoryForgotPassVerifyOtp,
        mApiProvider = apiProvider,
        mClient = client,
        super(ForgotPassVerifyOtpInitial()) {
    on<ForgotPassVerifyOtpUser>(_onForgotPassVerifyOtp);
  }

  final RepositoryAuth mRepositoryForgotPassVerifyOtp;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onForgotPassVerifyOtpNewUser is a function that takes an ForgotPassVerifyOtpUser event, an Emitter<ForgotPassVerifyOtpState> emit, and returns
  /// a Future<void> that emits an ForgotPassVerifyOtpLoading state, and then either an ForgotPassVerifyOtpResponse state or an
  /// ForgotPassVerifyOtpFailure state
  ///
  /// Args:
  ///   event (ForgotPassVerifyOtpUser): The event that was dispatched.
  ///   emit (Emitter<ForgotPassVerifyOtpState>): This is the function that you use to emit events.
  void _onForgotPassVerifyOtp(
    ForgotPassVerifyOtpUser event,
    Emitter<ForgotPassVerifyOtpState> emit,
  ) async {
    /// Emitting an ForgotPassVerifyOtpLoading state.
    emit(ForgotPassVerifyOtpLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelUser, ModelCommonAuthorised> response =
          await mRepositoryForgotPassVerifyOtp
              .callPostOTPVerifyForgotPasswordApi(
                  event.url,
                  event.body,
                  await mApiProvider.getHeaderValueWithAccessToken(),
                  mApiProvider,
                  mClient);
      response.fold(
        (success) {
          PreferenceHelper.setString(
              PreferenceHelper.accessToken, success.accessToken ?? '');
          emit(const ForgotPassVerifyOtpResponse());
        },
        (error) {
          emit(ForgotPassVerifyOtpFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const ForgotPassVerifyOtpFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const ForgotPassVerifyOtpFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const ForgotPassVerifyOtpFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
