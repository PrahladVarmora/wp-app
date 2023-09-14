import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/model/model_get_profile.dart';
import 'package:we_pro/modules/profile/repository/repository_profile.dart';

part 'get_profile_event.dart';

part 'get_profile_state.dart';

/// Notifies the [GetProfileBloc] of a new [GetProfileEvent] which triggers
/// [RepositoryProfile] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {
  GetProfileBloc({
    required RepositoryProfile repositoryGetProfile,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryGetProfile = repositoryGetProfile,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetProfileInitial()) {
    on<GetProfileUser>(_onGetProfileNewUser);
  }

  final RepositoryProfile mRepositoryGetProfile;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onGetProfileNewUser is a function that takes an GetProfileUser event, an Emitter<GetProfileState> emit, and returns
  /// a Future<void> that emits an GetProfileLoading state, and then either an GetProfileResponse state or an
  /// GetProfileFailure state
  ///
  /// Args:
  ///   event (GetProfileUser): The event that was dispatched.
  ///   emit (Emitter<GetProfileState>): This is the function that you use to emit events.
  void _onGetProfileNewUser(
    GetProfileUser event,
    Emitter<GetProfileState> emit,
  ) async {
    /// Emitting an GetProfileLoading state.
    emit(GetProfileLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelGetProfile, ModelCommonAuthorised> response =
          await mRepositoryGetProfile.callGetProfile(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          PreferenceHelper.setString(
              PreferenceHelper.userGetProfileData, json.encode(success));
          PreferenceHelper.getString(PreferenceHelper.userGetProfileData);

          emit(GetProfileResponse(modelGetProfile: success));
        },
        (error) {
          emit(GetProfileFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(ValidationString.validationNoInternetFound,
          getNavigatorKeyContext(), false);
      emit(const GetProfileFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      ToastController.showToast(e.toString(), getNavigatorKeyContext(), false);
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const GetProfileFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('error----$e');
        emit(const GetProfileFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}

class GetProfileLocationBloc extends GetProfileBloc {
  GetProfileLocationBloc(
      {required super.repositoryGetProfile,
      required super.apiProvider,
      required super.client});
}
