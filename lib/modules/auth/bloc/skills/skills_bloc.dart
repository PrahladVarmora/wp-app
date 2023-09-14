import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/repository/repository_auth.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';

import '../../../profile/model/skills/model_select_car_info.dart';
import '../../model/model_get_skills.dart';

part 'skills_event.dart';

part 'skills_state.dart';

/// Notifies the [AuthBloc] of a new [AuthEvent] which triggers
/// [RepositoryAuth] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class SkillsBloc extends Bloc<SkillsEvent, SkillState> {
  SkillsBloc({
    required RepositoryAuth repositoryAuth,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAuth = repositoryAuth,
        mApiProvider = apiProvider,
        mClient = client,
        super(SkillsInitial()) {
    on<SkillsGetData>(_skillGetData);
    on<SkillsSetData>(_skillSetData);
  }

  final RepositoryAuth mRepositoryAuth;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// _onAuthNewUser is a function that takes an AuthUser event, an Emitter<AuthState> emit, and returns
  /// a Future<void> that emits an AuthLoading state, and then either an AuthResponse state or an
  /// AuthFailure state
  ///
  /// Args:
  ///   event (AuthUser): The event that was dispatched.
  ///   emit (Emitter<AuthState>): This is the function that you use to emit events.
  void _skillGetData(
    SkillsGetData event,
    Emitter<SkillState> emit,
  ) async {
    /// Emitting an AuthLoading state.
    emit(SkillsLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<dynamic, ModelCommonAuthorised> response =
          await mRepositoryAuth.callGetSkillData(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          // // printWrapped('mModelUser.accessToken-----${success.accessToken}');
          // // PreferenceHelper.setString(
          // //     PreferenceHelper.authToken, success.accessToken ?? '');
          // PreferenceHelper.setString(
          //     PreferenceHelper.userData, json.encode(success));

          // PreferenceHelper.getString(PreferenceHelper.userData);
          // BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
          //     .add(GetProfileUser(url: AppUrls.apiGetProfileApi));

          emit(SkillsGetDataResponse(modelGetSkill: success as ModelGetSkills));
        },
        (error) {
          emit(SkillsFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const SkillsFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const SkillsFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const SkillsFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }

  void _skillSetData(
    SkillsSetData event,
    Emitter<SkillState> emit,
  ) async {
    /// Emitting an AuthLoading state.
    emit(SkillsLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<dynamic, ModelCommonAuthorised> response =
          await mRepositoryAuth.callSetSkillData(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /* printWrapped('mModelUser.accessToken-----${success.accessToken}');
          PreferenceHelper.setString(
              PreferenceHelper.authToken, success.accessToken ?? '');
          PreferenceHelper.setString(
              PreferenceHelper.userData, json.encode(success));

          PreferenceHelper.getString(PreferenceHelper.userData);*/
          BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
              .add(GetProfileUser(url: AppUrls.apiGetProfileApi));

          emit(SkillsSetDataResponse(commonResponse: success));
        },
        (error) {
          emit(SkillsFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const SkillsFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const SkillsFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const SkillsFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
