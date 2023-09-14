import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/bloc/send_otp/otp_send_bloc.dart';
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

part 'verify_otp_event.dart';

part 'verify_otp_state.dart';

/// Notifies the [VerifyOtpBloc] of a new [VerifyOtpEvent] which triggers
/// [RepositoryVerifyOtp] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  VerifyOtpBloc({
    required RepositoryAuth repositoryVerifyOtp,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryVerifyOtp = repositoryVerifyOtp,
        mApiProvider = apiProvider,
        mClient = client,
        super(VerifyOtpInitial()) {
    on<VerifyOtpUser>(_onVerifyOtpNewUser);
    on<VerifyOtpUserSMS>(_onVerifyOtpUserSMS);
  }

  final RepositoryAuth mRepositoryVerifyOtp;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onVerifyOtpNewUser is a function that takes an VerifyOtpUser event, an Emitter<VerifyOtpState> emit, and returns
  /// a Future<void> that emits an VerifyOtpLoading state, and then either an VerifyOtpResponse state or an
  /// VerifyOtpFailure state
  ///
  /// Args:
  ///   event (VerifyOtpUser): The event that was dispatched.
  ///   emit (Emitter<VerifyOtpState>): This is the function that you use to emit events.
  void _onVerifyOtpNewUser(
    VerifyOtpUser event,
    Emitter<VerifyOtpState> emit,
  ) async {
    /// Emitting an VerifyOtpLoading state.
    emit(VerifyOtpLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryVerifyOtp.callPostVerifyOtpApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          BlocProvider.of<OtpSendBloc>(getNavigatorKeyContext())
              .add(OtpSendUserContact(url: AppUrls.apiSendOTPApi, body: const {
            ApiParams.paramVerifyBy: 'sms',
          }));
          emit(VerifyOtpResponse(mModelVerifyOtp: success));
        },
        (error) {
          ToastController.showToast(
              error.message ?? '', getNavigatorKeyContext(), false);
          emit(VerifyOtpFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const VerifyOtpFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const VerifyOtpFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const VerifyOtpFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }

  void _onVerifyOtpUserSMS(
    VerifyOtpUserSMS event,
    Emitter<VerifyOtpState> emit,
  ) async {
    /// Emitting an VerifyOtpLoading state.
    emit(VerifyOtpLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryVerifyOtp.callPostVerifyOtpApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          Navigator.pushNamedAndRemoveUntil(getNavigatorKeyContext(),
              AppRoutes.routesProfileCompletion, (route) => false);
          emit(VerifyOtpResponse(mModelVerifyOtp: success));
        },
        (error) {
          ToastController.showToast(
              error.message ?? '', getNavigatorKeyContext(), false);
          emit(VerifyOtpFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const VerifyOtpFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const VerifyOtpFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const VerifyOtpFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
