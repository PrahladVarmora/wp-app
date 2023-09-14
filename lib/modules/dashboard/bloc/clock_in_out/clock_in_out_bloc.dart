import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/profile/bloc/get_profile/get_profile_bloc.dart';
import 'package:we_pro/modules/profile/repository/repository_profile.dart';

import '../../../core/utils/api_import.dart';

part 'clock_in_out_event.dart';

part 'clock_in_out_state.dart';

/// Notifies the [ClockInOutBloc] of a new [ClockInOutEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class ClockInOutBloc extends Bloc<ClockInOutEvent, ClockInOutState> {
  ClockInOutBloc({
    required RepositoryProfile repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryClockInOut = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(ClockInOutInitial()) {
    on<ClockInOut>(_onClockInOut);
    on<ClockInStatus>(_onClockInStatus);
  }

  final RepositoryProfile mRepositoryClockInOut;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onClockInOut] of a new [ClockInOutClockInOut] which triggers
  void _onClockInOut(
    ClockInOut event,
    Emitter<ClockInOutState> emit,
  ) async {
    emit(ClockInOutLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryClockInOut.callPostClockInOutApi(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              event.body,
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
              .add(GetProfileUser(url: AppUrls.apiGetProfileApi));
          emit(ClockInOutResponse(mModelClockInOut: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(ClockInOutFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const ClockInOutFailure(
          mError: ValidationString.validationNoInternetFound));
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const ClockInOutFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const ClockInOutFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }

  /// This is a private asynchronous function in Dart that handles the clock-in status event and updates the state using an Emitter.
  ///
  /// Args:
  ///   event (ClockInStatus): The event parameter is of type ClockInStatus, which is likely an enum or a class representing the status of a clock-in operation. It could contain information such as whether the clock-in was successful or not, any error messages, or other relevant data.
  ///   emit (Emitter<ClockInOutState>): `emit` is an instance of the `Emitter` class which is used to emit new states in the state management system. In this context, it is used to emit a new `ClockInOutState` whenever the `_onClockInStatus` function is called. The `emit` parameter is a
  void _onClockInStatus(
      ClockInStatus event, Emitter<ClockInOutState> emit) async {
    emit(ClockInOutLoading());
    Navigator.pop(getNavigatorKeyContext());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryClockInOut.callPostClockInOutApi(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              event.body,
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          BlocProvider.of<GetProfileBloc>(getNavigatorKeyContext())
              .add(GetProfileUser(url: AppUrls.apiGetProfileApi));

          emit(ClockInOutResponse(mModelClockInOut: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(ClockInOutFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const ClockInOutFailure(
          mError: ValidationString.validationNoInternetFound));
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const ClockInOutFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const ClockInOutFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
