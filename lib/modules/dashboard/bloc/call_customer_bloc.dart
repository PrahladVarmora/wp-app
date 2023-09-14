import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

part 'call_customer_event.dart';

part 'call_customer_state.dart';

/// Notifies the [CallCustomerBloc] of a new [CallCustomerEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class CallCustomerBloc extends Bloc<CallCustomerEvent, CallCustomerState> {
  CallCustomerBloc({
    required RepositoryJob repositoryCallCustomer,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryCallCustomer = repositoryCallCustomer,
        mApiProvider = apiProvider,
        mClient = client,
        super(CallCustomerInitial()) {
    on<CallCustomer>(_onCallCustomer);
  }

  final RepositoryJob mRepositoryCallCustomer;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onCallCustomer] of a new [CallCustomerCallCustomer] which triggers
  void _onCallCustomer(
    CallCustomer event,
    Emitter<CallCustomerState> emit,
  ) async {
    emit(CallCustomerLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryCallCustomer.callPostCallCustomerApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          if (event.isSendMessage) {
            Navigator.pop(getNavigatorKeyContext());
          } else {
            Navigator.pop(getNavigatorKeyContext());
            launchUrlString("tel:${event.phoneNumber}");
          }

          emit(CallCustomerResponse(mModelCallCustomer: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(CallCustomerFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const CallCustomerFailure(
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
        emit(const CallCustomerFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const CallCustomerFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
