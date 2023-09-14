import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'send_invoice_event.dart';

part 'send_invoice_state.dart';

/// Notifies the [SendInvoiceBloc] of a new [SendInvoiceEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class SendInvoiceBloc extends Bloc<SendInvoiceEvent, SendInvoiceState> {
  SendInvoiceBloc({
    required RepositoryJob repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositorySendInvoice = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(SendInvoiceInitial()) {
    on<SendInvoice>(_onSendInvoice);
  }

  final RepositoryJob mRepositorySendInvoice;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onSendInvoice] of a new [SendInvoice] which triggers
  void _onSendInvoice(
    SendInvoice event,
    Emitter<SendInvoiceState> emit,
  ) async {
    emit(SendInvoiceLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositorySendInvoice.callPostSendInvoiceApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          // Navigator.pop(getNavigatorKeyContext());
          ToastController.showToast(
              success.message ?? '', getNavigatorKeyContext(), true);
          emit(SendInvoiceResponse(mModelSendInvoice: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(SendInvoiceFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const SendInvoiceFailure(
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
        emit(const SendInvoiceFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const SendInvoiceFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
