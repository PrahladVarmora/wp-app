import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/repository/repository_profile.dart';

import '../../../core/utils/core_import.dart';

part 'update_profile_event.dart';

part 'update_profile_state.dart';

/// Notifies the [UpdateProfileBloc] of a new [UpdateProfileEvent] which triggers
/// [RepositoryProfile] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc({
    required RepositoryProfile repositoryUpdateProfile,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryUpdateProfile = repositoryUpdateProfile,
        mApiProvider = apiProvider,
        mClient = client,
        super(UpdateProfileInitial()) {
    on<UpdateProfileUser>(_onUpdateProfileUser);
    on<PictureUpdateProfile>(_onUpdateProfilePictureUser);
    on<DrivingLicenceUpdateProfile>(_onDrivingLicenceUpdateUser);
  }

  final RepositoryProfile mRepositoryUpdateProfile;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onUpdateProfileUser] of a new [UpdateProfileUser] which triggers
  void _onUpdateProfileUser(
    UpdateProfileUser event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(UpdateProfileLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryUpdateProfile.callUpdateProfileUser(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              event.body,
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /* ToastController.showToast(
              success.message.toString(), getNavigatorKeyContext(), true);*/
          BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
              .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
          emit(UpdateProfileResponse(mUpdateProfile: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(UpdateProfileFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate().toString(),
          getNavigatorKeyContext(),
          false);
      emit(UpdateProfileFailure(
          mError: ValidationString.validationNoInternetFound
              .translate()
              .toString()));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate().toString(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateProfileFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue
                .translate()
                .toString(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateProfileFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }

  /// Notifies the [_onUpdateProfilePictureUser] of a new [UpdateProfilePicture] which triggers
  void _onUpdateProfilePictureUser(
    PictureUpdateProfile event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(UpdateProfileLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryUpdateProfile.callUpdateProfilePictureApiWithImage(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              event.imageFile,
              {},
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
              .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
          emit(UpdateProfilePictureResponse(mUpdateProfilePicture: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(UpdateProfileFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate().toString(),
          getNavigatorKeyContext(),
          false);
      emit(const UpdateProfileFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate().toString(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateProfileFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue
                .translate()
                .toString(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateProfileFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }

  /// Notifies the [_onDrivingLicenceUpdateUser] of a new [DrivingLicenceUpdateProfile] which triggers
  void _onDrivingLicenceUpdateUser(
    DrivingLicenceUpdateProfile event,
    Emitter<UpdateProfileState> emit,
  ) async {
    emit(UpdateProfileLoading());
    try {
      /// This is a way to handle the response from the API call.
      List<ModelMultiPartFile> mListImage = [
        if (event.backImageFile.path.isNotEmpty)
          ModelMultiPartFile(
              filePath: event.backImageFile.path,
              apiKey: ApiParams.multipartBackImage),
        if (event.frontImageFile.path.isNotEmpty)
          ModelMultiPartFile(
              filePath: event.frontImageFile.path,
              apiKey: ApiParams.multipartFrontImage)
      ];

      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryUpdateProfile.callDrivingLicenceUpdate(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mListImage,
              {},
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          // mListImage = [];
          BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
              .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
          if (event.isFromEdit) {
            Navigator.pop(getNavigatorKeyContext());
          } else {
            Navigator.pushNamedAndRemoveUntil(getNavigatorKeyContext(),
                AppRoutes.routesDashboard, (route) => false);
          }
          emit(DrivingLicenceUpdateResponse(mDrivingLicenceUpdate: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);
          emit(UpdateProfileFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate().toString(),
          getNavigatorKeyContext(),
          false);
      emit(const UpdateProfileFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate().toString(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateProfileFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue
                .translate()
                .toString(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateProfileFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
