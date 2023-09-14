import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_industry.dart';
import 'package:we_pro/modules/profile/repository/repository_skills.dart';

part 'industry_event.dart';

part 'industry_state.dart';

/// Notifies the [IndustryBloc] of a new [IndustryEvent] which triggers
/// [RepositoryMaster] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class IndustryBloc extends Bloc<IndustryEvent, IndustryState> {
  IndustryBloc({
    required RepositorySkills repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySkills = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(IndustryInitial()) {
    printWrapped('IndustryInitial');
    on<GetIndustryList>(_onGetIndustryList);
  }

  List<IndustryData> industry = [];
  final RepositorySkills mRepositorySkills;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onGetIndustryList] of a new [IndustryLogin] which triggers
  void _onGetIndustryList(
    GetIndustryList event,
    Emitter<IndustryState> emit,
  ) async {
    emit(IndustryLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelIndustry, ModelCommonAuthorised> response =
          await mRepositorySkills.callGetIndustry(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          industry = success.industry ?? [];

          emit(IndustryResponse(mIndustry: success));
        },
        (error) {
          if (error.status != "401") {
            ToastController.showToast(
                error.message!, getNavigatorKeyContext(), false);
          }
          emit(IndustryFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const IndustryFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const IndustryFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const IndustryFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
