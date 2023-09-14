import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/masters/model/model_skill.dart';
import 'package:we_pro/modules/masters/repository/repository_master.dart';

part 'skill_event.dart';

part 'skill_state.dart';

/// Notifies the [SkillBloc] of a new [SkillEvent] which triggers
/// [RepositoryMaster] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class SkillBloc extends Bloc<SkillEvent, SkillState> {
  SkillBloc({
    required RepositoryMaster repositorySkill,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySkill = repositorySkill,
        mApiProvider = apiProvider,
        mClient = client,
        super(SkillInitial()) {
    on<Skill>(_onSkill);
  }

  List<Skills> mSkills = [];
  final RepositoryMaster mRepositorySkill;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onSkill] of a new [SkillLogin] which triggers
  void _onSkill(
    Skill event,
    Emitter<SkillState> emit,
  ) async {
    emit(SkillLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelSkill, ModelCommonAuthorised> response =
          await mRepositorySkill.callGetSkillListApi(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          mSkills = success.skills ?? [];
          emit(SkillResponse(mSkill: success));
        },
        (error) {
          ToastController.showToast(
              error.message!, getNavigatorKeyContext(), false);
          emit(SkillFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const SkillFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const SkillFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const SkillFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
