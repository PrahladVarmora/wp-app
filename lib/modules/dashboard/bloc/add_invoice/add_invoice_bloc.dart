import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'add_invoice_event.dart';

part 'add_invoice_state.dart';

/// Notifies the [AddInvoiceBloc] of a new [AddInvoiceEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class AddInvoiceBloc extends Bloc<AddInvoiceEvent, AddInvoiceState> {
  AddInvoiceBloc({
    required RepositoryJob repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryAddInvoice = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(AddInvoiceInitial()) {
    on<AddInvoice>(_onAddInvoice);
    on<UpdateInvoice>(_onUpdateInvoice);
  }

  final RepositoryJob mRepositoryAddInvoice;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onAddInvoice] of a new [AddInvoiceAddInvoice] which triggers
  void _onAddInvoice(
    AddInvoice event,
    Emitter<AddInvoiceState> emit,
  ) async {
    emit(AddInvoiceLoading());
    try {
      /// This is a way to handle the response from the API call.

      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryAddInvoice.callPostAddInvoiceApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// Navigate to another screen
          Navigator.pop(getNavigatorKeyContext());
          ToastController.showToast(
              success.message.toString(), getNavigatorKeyContext(), true);
          emit(AddInvoiceResponse(mModelAddInvoice: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(AddInvoiceFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(AddInvoiceFailure(
          mError: ValidationString.validationNoInternetFound.translate()));
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
        emit(const AddInvoiceFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('AddInvoiceFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const AddInvoiceFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }

  void _onUpdateInvoice(
    UpdateInvoice event,
    Emitter<AddInvoiceState> emit,
  ) async {
    emit(AddInvoiceLoading());
    try {
      /// This is a way to handle the response from the API call.

      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryAddInvoice.callPostAddInvoiceApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          /// Navigate to another screen
          Navigator.pop(getNavigatorKeyContext());
          ToastController.showToast(
              success.message.toString(), getNavigatorKeyContext(), true);
          emit(AddInvoiceResponse(mModelAddInvoice: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(AddInvoiceFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(AddInvoiceFailure(
          mError: ValidationString.validationNoInternetFound.translate()));
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
        emit(const AddInvoiceFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('AddInvoiceFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const AddInvoiceFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
