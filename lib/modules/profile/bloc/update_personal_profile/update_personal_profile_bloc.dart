import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/repository/repository_profile.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'update_personal_profile_event.dart';

part 'update_personal_profile_state.dart';

/// Notifies the [UpdatePersonalProfileBloc] of a new [UpdatePersonalProfileEvent] which triggers
/// [RepositoryProfile] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class UpdatePersonalProfileBloc
    extends Bloc<UpdatePersonalProfileEvent, UpdatePersonalProfileState> {
  UpdatePersonalProfileBloc({
    required RepositoryProfile repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryUpdatePersonalProfile = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(UpdatePersonalProfileInitial()) {
    on<UpdatePersonalProfileUser>(_onUpdatePersonalProfileUser);
  }

  final RepositoryProfile mRepositoryUpdatePersonalProfile;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onUpdatePersonalProfileUser] of a new [UpdatePersonalProfileUser] which triggers
  void _onUpdatePersonalProfileUser(
    UpdatePersonalProfileUser event,
    Emitter<UpdatePersonalProfileState> emit,
  ) async {
    emit(UpdatePersonalProfileLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryUpdatePersonalProfile.callUpdatePersonalProfileAPI(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              event.body,
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
              .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
          Navigator.pop(getNavigatorKeyContext());
          emit(const UpdatePersonalProfileResponse());
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(UpdatePersonalProfileFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate().toString(),
          getNavigatorKeyContext(),
          false);
      emit(UpdatePersonalProfileFailure(
          mError: ValidationString.validationNoInternetFound
              .translate()
              .toString()));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate().toString(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdatePersonalProfileFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        // printWrapped('UpdatePersonalProfileFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue
                .translate()
                .toString(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdatePersonalProfileFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
