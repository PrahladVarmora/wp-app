import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/model/model_user.dart';
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

part 'renew_access_token_event.dart';

part 'renew_access_token_state.dart';

/// Notifies the [RenewAccessTokenBloc] of a new [RenewAccessTokenEvent] which triggers
/// [RepositoryAuth] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class RenewAccessTokenBloc
    extends Bloc<RenewAccessTokenEvent, RenewAccessTokenState> {
  RenewAccessTokenBloc({
    required RepositoryAuth repositoryRenewAccessToken,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryRenewAccessToken = repositoryRenewAccessToken,
        mApiProvider = apiProvider,
        mClient = client,
        super(RenewAccessTokenInitial()) {
    on<RenewAccessTokenUser>(_onRenewAccessTokenNewUser);
  }

  final RepositoryAuth mRepositoryRenewAccessToken;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onRenewAccessTokenNewUser is a function that takes an RenewAccessTokenUser event, an Emitter<RenewAccessTokenState> emit, and returns
  /// a Future<void> that emits an RenewAccessTokenLoading state, and then either an RenewAccessTokenResponse state or an
  /// RenewAccessTokenFailure state
  ///
  /// Args:
  ///   event (RenewAccessTokenUser): The event that was dispatched.
  ///   emit (Emitter<RenewAccessTokenState>): This is the function that you use to emit events.
  void _onRenewAccessTokenNewUser(
    RenewAccessTokenUser event,
    Emitter<RenewAccessTokenState> emit,
  ) async {
    /// Emitting an RenewAccessTokenLoading state.
    emit(RenewAccessTokenLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelUser, ModelCommonAuthorised> response =
          await mRepositoryRenewAccessToken.callPostRenewAccessTokenApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithAccessToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          printWrapped('mModelUser.accessToken-----${success.accessToken}');
          PreferenceHelper.setString(
              PreferenceHelper.authToken, success.accessToken ?? '');
          PreferenceHelper.setString(
              PreferenceHelper.userData, json.encode(success));
          PreferenceHelper.getString(PreferenceHelper.userData);
          emit(RenewAccessTokenResponse(mRenewAccessToken: success));
        },
        (error) {
          emit(RenewAccessTokenFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const RenewAccessTokenFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const RenewAccessTokenFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const RenewAccessTokenFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
