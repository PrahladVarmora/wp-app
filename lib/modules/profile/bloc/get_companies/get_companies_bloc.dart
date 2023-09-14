import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/model/model_get_profile.dart';
import 'package:we_pro/modules/profile/repository/repository_profile.dart';

part 'get_companies_event.dart';

part 'get_companies_state.dart';

/// Notifies the [GetCompaniesBloc] of a new [GetCompaniesEvent] which triggers
/// [RepositoryProfile] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class GetCompaniesBloc extends Bloc<GetCompaniesEvent, GetCompaniesState> {
  GetCompaniesBloc({
    required RepositoryProfile repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryGetCompanies = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(GetCompaniesInitial()) {
    on<GetCompaniesUser>(_onGetCompaniesNewUser);
  }

  final RepositoryProfile mRepositoryGetCompanies;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onGetCompaniesNewUser is a function that takes an GetCompaniesUser event, an Emitter<GetCompaniesState> emit, and returns
  /// a Future<void> that emits an GetCompaniesLoading state, and then either an GetCompaniesResponse state or an
  /// GetCompaniesFailure state
  ///
  /// Args:
  ///   event (GetCompaniesUser): The event that was dispatched.
  ///   emit (Emitter<GetCompaniesState>): This is the function that you use to emit events.
  void _onGetCompaniesNewUser(
    GetCompaniesUser event,
    Emitter<GetCompaniesState> emit,
  ) async {
    /// Emitting an GetCompaniesLoading state.
    emit(GetCompaniesLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<Companies, ModelCommonAuthorised> response =
          await mRepositoryGetCompanies.callGetCompanies(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          ModelGetProfile mProfile = getProfileData();
          mProfile.companies = success;
          PreferenceHelper.setString(
              PreferenceHelper.userGetProfileData, json.encode(mProfile));
          PreferenceHelper.getString(PreferenceHelper.userGetProfileData);

          emit(GetCompaniesResponse(modelGetCompanies: success));
        },
        (error) {
          emit(GetCompaniesFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(ValidationString.validationNoInternetFound,
          getNavigatorKeyContext(), false);
      emit(const GetCompaniesFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      ToastController.showToast(e.toString(), getNavigatorKeyContext(), false);
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const GetCompaniesFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('error----$e');
        emit(const GetCompaniesFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
