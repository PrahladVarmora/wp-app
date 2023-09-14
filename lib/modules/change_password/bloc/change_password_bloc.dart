import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/bloc/logout/logout_bloc.dart';
import 'package:we_pro/modules/change_password/repository/repository_change_password.dart';

import '../../core/utils/api_import.dart';
import '../../core/utils/core_import.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

/// Notifies the [ChangePasswordBloc] of a new [ChangePasswordEvent] which triggers
/// [RepositoryChangePassword] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc({
    required RepositoryChangePassword repositoryChangePassword,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryChangePassword = repositoryChangePassword,
        mApiProvider = apiProvider,
        mClient = client,
        super(ChangePasswordInitial()) {
    on<ChangePasswordUser>(_onChangePasswordNewUser);
  }

  final RepositoryChangePassword mRepositoryChangePassword;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onChangePasswordNewUser is a function that takes an ChangePasswordUser event, an Emitter<ChangePasswordState> emit, and returns
  /// a Future<void> that emits an ChangePasswordLoading state, and then either an ChangePasswordResponse state or an
  /// ChangePasswordFailure state
  ///
  /// Args:
  ///   event (ChangePasswordUser): The event that was dispatched.
  ///   emit (Emitter<ChangePasswordState>): This is the function that you use to emit events.
  void _onChangePasswordNewUser(
    ChangePasswordUser event,
    Emitter<ChangePasswordState> emit,
  ) async {
    /// Emitting an ChangePasswordLoading state.
    emit(ChangePasswordLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryChangePassword.callPostChangePasswordApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          printWrapped('mModelUser.message-----${success.message}');
          ToastController.showToast(
              success.message.toString(), getNavigatorKeyContext(), true);
          Navigator.pop(getNavigatorKeyContext());
          BlocProvider.of<LogoutBloc>(getNavigatorKeyContext())
              .add(LogoutUser(body: const {}, url: AppUrls.apLogoutApi));
          emit(const ChangePasswordResponse());
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);
          emit(ChangePasswordFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const ChangePasswordFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const ChangePasswordFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const ChangePasswordFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
