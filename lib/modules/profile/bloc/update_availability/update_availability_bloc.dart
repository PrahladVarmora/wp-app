import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/repository/repository_profile.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'update_availability_event.dart';

part 'update_availability_state.dart';

/// Notifies the [UpdateAvailabilityBloc] of a new [UpdateAvailabilityEvent] which triggers
/// [RepositoryProfile] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class UpdateAvailabilityBloc
    extends Bloc<UpdateAvailabilityEvent, UpdateAvailabilityState> {
  UpdateAvailabilityBloc({
    required RepositoryProfile repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryUpdateAvailability = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(UpdateAvailabilityInitial()) {
    on<UpdateAvailabilityUser>(_onUpdateAvailabilityUser);
  }

  final RepositoryProfile mRepositoryUpdateAvailability;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onUpdateAvailabilityUser] of a new [UpdateAvailabilityUser] which triggers
  void _onUpdateAvailabilityUser(
    UpdateAvailabilityUser event,
    Emitter<UpdateAvailabilityState> emit,
  ) async {
    emit(UpdateAvailabilityLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryUpdateAvailability.callUpdateAvailabilityAPI(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              event.body,
              mApiProvider,
              mClient);
      response.fold(
        (success) async {
          BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
              .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
          await Future.delayed(const Duration(seconds: 2))
              .then((value) => Navigator.pop(getNavigatorKeyContext()));
          ToastController.showToast(
              success.message.toString(), getNavigatorKeyContext(), true);

          emit(UpdateAvailabilityResponse(mUpdateAvailability: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(UpdateAvailabilityFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate().toString(),
          getNavigatorKeyContext(),
          false);
      emit(UpdateAvailabilityFailure(
          mError: ValidationString.validationNoInternetFound
              .translate()
              .toString()));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate().toString(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateAvailabilityFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('UpdateAvailabilityFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue
                .translate()
                .toString(),
            getNavigatorKeyContext(),
            false);
        emit(const UpdateAvailabilityFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
