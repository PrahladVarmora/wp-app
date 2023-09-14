import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/profile/model/model_setup_stripe.dart';
import 'package:we_pro/modules/profile/repository/repository_profile.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'setup_stripe_event.dart';

part 'setup_stripe_state.dart';

/// Notifies the [SetupStripeBloc] of a new [SetupStripeEvent] which triggers
/// [RepositoryProfile] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class SetupStripeBloc extends Bloc<SetupStripeEvent, SetupStripeState> {
  SetupStripeBloc({
    required RepositoryProfile repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySetupStripe = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(SetupStripeInitial()) {
    on<SetupStripeUser>(_onSetupStripeUser);
  }

  final RepositoryProfile mRepositorySetupStripe;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onSetupStripeUser] of a new [SetupStripeUser] which triggers
  void _onSetupStripeUser(
    SetupStripeUser event,
    Emitter<SetupStripeState> emit,
  ) async {
    emit(SetupStripeLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelSetUpStripe, ModelCommonAuthorised> response =
          await mRepositorySetupStripe.callSetupStripeAPI(
              event.url,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) async {
          Navigator.pushNamed(
              getNavigatorKeyContext(), AppRoutes.routesSetUpStripe,
              arguments: {
                AppConfig.argumentsTitle:
                    APPStrings.textSetupStripe.translate(),
                AppConfig.argumentsUrl: success.stripeUrl ?? ''
              });

          emit(const SetupStripeResponse());
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(SetupStripeFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate().toString(),
          getNavigatorKeyContext(),
          false);
      emit(SetupStripeFailure(
          mError: ValidationString.validationNoInternetFound
              .translate()
              .toString()));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationNoInternetFound.translate().toString(),
            getNavigatorKeyContext(),
            false);
        emit(const SetupStripeFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('SetupStripeFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue
                .translate()
                .toString(),
            getNavigatorKeyContext(),
            false);
        emit(const SetupStripeFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
