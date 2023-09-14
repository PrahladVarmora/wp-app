import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_car_info.dart';
import 'package:we_pro/modules/profile/repository/repository_skills.dart';

import '../../../../core/utils/core_import.dart';

part 'make_model_year_event.dart';

part 'make_model_year_state.dart';

/// Notifies the [MakeModelYearBloc] of a new [MakeModelYearEvent] which triggers
/// [RepositoryMaster] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class MakeModelYearBloc extends Bloc<MakeModelYearEvent, MakeModelYearState> {
  MakeModelYearBloc({
    required RepositorySkills repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySkills = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(MakeModelYearInitial()) {
    printWrapped('MakeModelYearInitial');
    on<GetMakeModelYearList>(_onGetMakeModelYearList);
  }

  List<CarMakesData> makeModelYear = [];
  final RepositorySkills mRepositorySkills;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onGetMakeModelYearList] of a new [MakeModelYearLogin] which triggers
  void _onGetMakeModelYearList(
    GetMakeModelYearList event,
    Emitter<MakeModelYearState> emit,
  ) async {
    emit(MakeModelYearLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCarInfo, ModelCommonAuthorised> response =
          await mRepositorySkills.callGetMakeModelYear(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          makeModelYear.clear();
          makeModelYear.addAll(success.carMakesData ?? []);

          emit(MakeModelYearResponse(mMakeModelYear: success));
        },
        (error) {
          ToastController.showToast(
              error.message!, getNavigatorKeyContext(), false);
          emit(MakeModelYearFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const MakeModelYearFailure(
          mError: ValidationString.validationNoInternetFound));
    } catch (e) {
      ToastController.showToast(e.toString(), getNavigatorKeyContext(), false);
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const MakeModelYearFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        emit(const MakeModelYearFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
