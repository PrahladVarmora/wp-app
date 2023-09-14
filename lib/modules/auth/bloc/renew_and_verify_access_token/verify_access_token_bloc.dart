import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/bloc/renew_and_verify_access_token/renew_access_token_bloc.dart';
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

part 'verify_access_token_event.dart';

part 'verify_access_token_state.dart';

/// Notifies the [VerifyAccessTokenBloc] of a new [VerifyAccessTokenEvent] which triggers
/// [RepositoryAuth] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class VerifyAccessTokenBloc
    extends Bloc<VerifyAccessTokenEvent, VerifyAccessTokenState> {
  VerifyAccessTokenBloc({
    required RepositoryAuth repositoryVerifyAccessToken,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryVerifyAccessToken = repositoryVerifyAccessToken,
        mApiProvider = apiProvider,
        mClient = client,
        super(VerifyAccessTokenInitial()) {
    on<VerifyAccessTokenUser>(_onVerifyAccessTokenNewUser);
  }

  final RepositoryAuth mRepositoryVerifyAccessToken;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onVerifyAccessTokenNewUser is a function that takes an VerifyAccessTokenUser event, an Emitter<VerifyAccessTokenState> emit, and returns
  /// a Future<void> that emits an VerifyAccessTokenLoading state, and then either an VerifyAccessTokenResponse state or an
  /// VerifyAccessTokenFailure state
  ///
  /// Args:
  ///   event (VerifyAccessTokenUser): The event that was dispatched.
  ///   emit (Emitter<VerifyAccessTokenState>): This is the function that you use to emit events.
  void _onVerifyAccessTokenNewUser(
    VerifyAccessTokenUser event,
    Emitter<VerifyAccessTokenState> emit,
  ) async {
    /// Emitting an VerifyAccessTokenLoading state.
    emit(VerifyAccessTokenLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryVerifyAccessToken.callPostVerifyAccessTokenApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          emit(VerifyAccessTokenResponse(mVerifyAccessToken: success));
        },
        (error) {
          BlocProvider.of<RenewAccessTokenBloc>(getNavigatorKeyContext()).add(
              RenewAccessTokenUser(
                  body: const {}, url: AppUrls.apiRenewAccessTokenApi));
          emit(VerifyAccessTokenFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const VerifyAccessTokenFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const VerifyAccessTokenFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const VerifyAccessTokenFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
