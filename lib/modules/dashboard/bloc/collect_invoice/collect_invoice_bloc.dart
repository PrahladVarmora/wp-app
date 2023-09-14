import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/dashboard/model/model_collect_payment.dart';
import 'package:we_pro/modules/dashboard/model/model_my_job.dart';
import 'package:we_pro/modules/dashboard/repository/repository_job.dart';

import '../../../core/utils/api_import.dart';
import '../../../core/utils/core_import.dart';

part 'collect_invoice_event.dart';

part 'collect_invoice_state.dart';

/// Notifies the [CollectInvoiceBloc] of a new [CollectInvoiceEvent] which triggers
/// [RepositoryJob] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class CollectInvoiceBloc
    extends Bloc<CollectInvoiceEvent, CollectInvoiceState> {
  CollectInvoiceBloc({
    required RepositoryJob repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryCollectInvoice = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(CollectInvoiceInitial()) {
    on<CollectInvoice>(_onCollectInvoice);
  }

  final RepositoryJob mRepositoryCollectInvoice;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onCollectInvoice] of a new [CollectInvoice] which triggers
  void _onCollectInvoice(
    CollectInvoice event,
    Emitter<CollectInvoiceState> emit,
  ) async {
    emit(CollectInvoiceLoading());
    try {
      /// This is a way to handle the response from the API call.
      Either<ModelCollectPayment, ModelCommonAuthorised> response =
          await mRepositoryCollectInvoice.callPostCollectInvoiceApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          // Navigator.pop(getNavigatorKeyContext());
          /*ToastController.showToast(
              success.msg ?? '', getNavigatorKeyContext(), true);*/

          if (event.body[ApiParams.paramChargeMethod] == payCash ||
              event.body[ApiParams.paramChargeMethod] == payCheque ||
              event.body[ApiParams.paramChargeMethod] == payCashApp ||
              event.body[ApiParams.paramChargeMethod] == payZelle ||
              event.body[ApiParams.paramChargeMethod] == payVenom) {
            if (event.isPartial) {
              Navigator.pop(getNavigatorKeyContext());
            } else {
              Navigator.popAndPushNamed(
                  getNavigatorKeyContext(), AppRoutes.routesPaymentSuccessfully,
                  arguments: event.mJobData);
            }
          } else if ((event.body[ApiParams.paramChargeMethod] ==
              payCreditCard)) {
            if (event.isPartial) {
              Navigator.pop(getNavigatorKeyContext());
            } else {
              Navigator.pushNamed(getNavigatorKeyContext(),
                  AppRoutes.routesPartialPaymentStatus,
                  arguments: event.mJobData);
            }
          } else if (event.body[ApiParams.paramChargeMethod] == payChargeNow) {
            Navigator.pushNamed(
                getNavigatorKeyContext(), AppRoutes.routesChargeNowPayment,
                arguments: {
                  AppConfig.argumentsUrl: success.payUrl ?? '',
                  AppConfig.argumentsJob: event.mJobData,
                  AppConfig.argumentsIsPartial: event.isPartial,
                });
          }
          emit(CollectInvoiceResponse(mModelCollectInvoice: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(CollectInvoiceFailure(mError: error.message!));
        },
      );
    } on SocketException {
      emit(const CollectInvoiceFailure(
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
        emit(const CollectInvoiceFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const CollectInvoiceFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
