import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';

part 'delete_account_event.dart';

part 'delete_account_state.dart';

/// Notifies the [DeleteAccountBloc] of a new [DeleteAccountEvent] which triggers
/// [RepositoryDeleteAccount] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc({
    required RepositoryAuth repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryDeleteAccount = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(DeleteAccountInitial()) {
    on<DeleteAccountUser>(_onDeleteAccountNewUser);
  }

  final RepositoryAuth mRepositoryDeleteAccount;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onDeleteAccountNewUser is a function that takes an DeleteAccountUser event, an Emitter<DeleteAccountState> emit, and returns
  /// a Future<void> that emits an DeleteAccountLoading state, and then either an DeleteAccountResponse state or an
  /// DeleteAccountFailure state
  ///
  /// Args:
  ///   event (DeleteAccountUser): The event that was dispatched.
  ///   emit (Emitter<DeleteAccountState>): This is the function that you use to emit events.
  void _onDeleteAccountNewUser(
    DeleteAccountUser event,
    Emitter<DeleteAccountState> emit,
  ) async {
    /// Emitting an DeleteAccountLoading state.
    emit(DeleteAccountLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryDeleteAccount.callPostDeleteAccountApi(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          ToastController.showToastMessage(
              success.message ?? '', getNavigatorKeyContext(), true);
          PreferenceHelper.remove(PreferenceHelper.authToken);
          PreferenceHelper.remove(PreferenceHelper.userData);
          RouteGenerator.logoutClearData(getNavigatorKeyContext());

          emit(DeleteAccountResponse(modelCommonAuthorised: success));
        },
        (error) {
          RouteGenerator.logoutClearData(getNavigatorKeyContext());
          emit(DeleteAccountFailure(mError: error.message!));
        },
      );
    } on SocketException {
      RouteGenerator.logoutClearData(getNavigatorKeyContext());
      emit(const DeleteAccountFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      RouteGenerator.logoutClearData(getNavigatorKeyContext());
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const DeleteAccountFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const DeleteAccountFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
