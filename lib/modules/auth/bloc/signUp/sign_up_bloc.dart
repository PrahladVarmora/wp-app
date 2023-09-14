import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/bloc/send_otp/otp_send_bloc.dart';
import 'package:we_pro/modules/auth/model/model_user.dart';
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/bloc/skills/make_model_year/make_model_year_bloc.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

/// Notifies the [SignUpBloc] of a new [SignUpEvent] which triggers
/// [RepositoryAuth] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required RepositoryAuth repositorySignUp,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySignUp = repositorySignUp,
        mApiProvider = apiProvider,
        mClient = client,
        super(SignUpInitial()) {
    on<SignUpSignUp>(_onAuthNewUser);
  }

  final RepositoryAuth mRepositorySignUp;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onAuthNewUser] of a new [SignUpSignUp] which triggers
  void _onAuthNewUser(
    SignUpSignUp event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelUser, ModelCommonAuthorised> response =
          await mRepositorySignUp.callSignUpApiWithImage(
              event.url,
              await mApiProvider.getHeaderValueWithAccessToken(),
              event.imageFile,
              event.body,
              mApiProvider,
              mClient);
      await response.fold(
        (success) async {
          printWrapped('signup-success');
          PreferenceHelper.setString(
              PreferenceHelper.authToken, success.accessToken ?? '');
          PreferenceHelper.setString(
              PreferenceHelper.userData, json.encode(success));

          PreferenceHelper.getString(PreferenceHelper.userData);
          if (event.imageFile != null) {
            Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
                await mRepositorySignUp.callUpdateProfilePictureApiWithImage(
                    AppUrls.apiPictureUpdateProfile,
                    await mApiProvider.getHeaderValueWithUserToken(),
                    event.imageFile,
                    {},
                    mApiProvider,
                    mClient);
            await response.fold(
              (success1) async {
                BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
                    .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
                BlocProvider.of<MakeModelYearBloc>(getNavigatorKeyContext())
                    .add(GetMakeModelYearList(
                        url: AppUrls.apiDispatchSourcesCarInfo));
                BlocProvider.of<OtpSendBloc>(getNavigatorKeyContext())
                    .add(OtpSendUser(url: AppUrls.apiSendOTPApi, body: const {
                  ApiParams.paramVerifyBy: 'email',
                }));
                emit(SignUpResponse(mModelUser: success));
              },
              (error) async {
                BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
                    .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
                BlocProvider.of<MakeModelYearBloc>(getNavigatorKeyContext())
                    .add(GetMakeModelYearList(
                        url: AppUrls.apiDispatchSourcesCarInfo));
                BlocProvider.of<OtpSendBloc>(getNavigatorKeyContext())
                    .add(OtpSendUser(url: AppUrls.apiSendOTPApi, body: const {
                  ApiParams.paramVerifyBy: 'email',
                }));
                emit(SignUpResponse(mModelUser: success));
              },
            );
          } else {
            BlocProvider.of<MakeModelYearBloc>(getNavigatorKeyContext()).add(
                GetMakeModelYearList(url: AppUrls.apiDispatchSourcesCarInfo));
            BlocProvider.of<OtpSendBloc>(getNavigatorKeyContext())
                .add(OtpSendUser(url: AppUrls.apiSendOTPApi, body: const {
              ApiParams.paramVerifyBy: 'email',
            }));
            emit(SignUpResponse(mModelUser: success));
          }
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);
          emit(SignUpFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(const SignUpFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      ToastController.showToast(e.toString(), getNavigatorKeyContext(), false);
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const SignUpFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const SignUpFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
