import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/core/api_service/api_provider.dart';
import 'package:we_pro/modules/core/common/modelCommon/model_common_authorised.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

part 'otp_send_event.dart';

part 'otp_send_state.dart';

/// Notifies the [OtpSendBloc] of a new [OtpSendEvent] which triggers
/// [RepositoryOtpSend] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class OtpSendBloc extends Bloc<OtpSendEvent, OtpSendState> {
  OtpSendBloc({
    required RepositoryAuth repositoryOtpSend,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryOtpSend = repositoryOtpSend,
        mApiProvider = apiProvider,
        mClient = client,
        super(OtpSendInitial()) {
    on<OtpSendUser>(_onOtpSendNewUser);
    on<ResendOtpSendUser>(_onResendOtpSendUser);
    on<OtpSendUserContact>(_onOtpSendUserContact);
  }

  final RepositoryAuth mRepositoryOtpSend;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onOtpSendNewUser is a function that takes an OtpSendUser event, an Emitter<OtpSendState> emit, and returns
  /// a Future<void> that emits an OtpSendLoading state, and then either an OtpSendResponse state or an
  /// OtpSendFailure state
  ///
  /// Args:
  ///   event (OtpSendUser): The event that was dispatched.
  ///   emit (Emitter<OtpSendState>): This is the function that you use to emit events.
  void _onOtpSendNewUser(
    OtpSendUser event,
    Emitter<OtpSendState> emit,
  ) async {
    /// Emitting an OtpSendLoading state.
    emit(OtpSendLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryOtpSend.callPostOTPSendApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// Navigate to another screen
          ToastController.showToast(
              success.message ?? '', getNavigatorKeyContext(), true);
          NavigatorKey.navigatorKey.currentState!
              .pushNamed(AppRoutes.routesOtpEmail, arguments: '');

          emit(OtpSendResponse(mModelOtpSend: success));
        },
        (error) {
          emit(OtpSendFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const OtpSendFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const OtpSendFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const OtpSendFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }

  void _onResendOtpSendUser(
    ResendOtpSendUser event,
    Emitter<OtpSendState> emit,
  ) async {
    /// Emitting an OtpSendLoading state.
    emit(OtpSendLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryOtpSend.callPostOTPSendApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// Navigate to another screen
          ToastController.showToast(
              success.message ?? '', getNavigatorKeyContext(), true);
          emit(OtpSendResponse(mModelOtpSend: success));
        },
        (error) {
          emit(OtpSendFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const OtpSendFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const OtpSendFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const OtpSendFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }

  /// _onOtpSendNewUser is a function that takes an OtpSendUser event, an Emitter<OtpSendState> emit, and returns
  /// a Future<void> that emits an OtpSendLoading state, and then either an OtpSendResponse state or an
  /// OtpSendFailure state
  ///
  /// Args:
  ///   event (OtpSendUser): The event that was dispatched.
  ///   emit (Emitter<OtpSendState>): This is the function that you use to emit events.
  void _onOtpSendUserContact(
    OtpSendUserContact event,
    Emitter<OtpSendState> emit,
  ) async {
    /// Emitting an OtpSendLoading state.
    emit(OtpSendLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryOtpSend.callPostOTPSendApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// Navigate to another screen
          ToastController.showToast(
              success.message ?? '', getNavigatorKeyContext(), true);
          Navigator.pushNamedAndRemoveUntil(
              getNavigatorKeyContext(),
              AppRoutes.routesOtpContact,
              (route) => route.settings.name == AppRoutes.routesSignIn);

          emit(OtpSendResponse(mModelOtpSend: success));
        },
        (error) {
          emit(OtpSendFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const OtpSendFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const OtpSendFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const OtpSendFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
