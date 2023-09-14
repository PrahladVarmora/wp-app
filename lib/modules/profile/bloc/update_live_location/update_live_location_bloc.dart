import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/repository/repository_profile.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'update_live_location_event.dart';

part 'update_live_location_state.dart';

/// Notifies the [UpdateLiveLocationBloc] of a new [UpdateLiveLocationEvent] which triggers
/// [RepositoryProfile] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class UpdateLiveLocationBloc
    extends Bloc<UpdateLiveLocationEvent, UpdateLiveLocationState> {
  UpdateLiveLocationBloc({
    required RepositoryProfile repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryUpdateLiveLocation = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(UpdateLiveLocationInitial()) {
    on<UpdateLiveLocationUser>(_onUpdateLiveLocationUser);
  }

  final RepositoryProfile mRepositoryUpdateLiveLocation;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onUpdateLiveLocationUser] of a new [UpdateLiveLocationUser] which triggers
  void _onUpdateLiveLocationUser(
    UpdateLiveLocationUser event,
    Emitter<UpdateLiveLocationState> emit,
  ) async {
    emit(UpdateLiveLocationLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryUpdateLiveLocation.callUpdateLiveLocationAPI(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              event.body,
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          BlocProvider.of<GetProfileLocationBloc>(getNavigatorKeyContext())
              .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
          emit(const UpdateLiveLocationResponse());
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(UpdateLiveLocationFailure(mError: error.message!));
        },
      );
    } on SocketException {
      /*ToastController.showToast(
          ValidationString.validationNoInternetFound.translate().toString(),
          getNavigatorKeyContext(),
          false);*/
      emit(UpdateLiveLocationFailure(
          mError: ValidationString.validationNoInternetFound
              .translate()
              .toString()));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        /* ToastController.showToast(
            ValidationString.validationNoInternetFound.translate().toString(),
            getNavigatorKeyContext(),
            false);*/
        emit(const UpdateLiveLocationFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        // printWrapped('UpdateLiveLocationFailure-----$e');
        /*ToastController.showToast(
            ValidationString.validationInternalServerIssue
                .translate()
                .toString(),
            getNavigatorKeyContext(),
            false);*/
        emit(const UpdateLiveLocationFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
