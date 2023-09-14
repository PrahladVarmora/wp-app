import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/wallet/repository/repository_wallet.dart';

part 'request_money_event.dart';

part 'request_money_state.dart';

/// Notifies the [SendAndRequestMoneyBloc] of a new [SendAndRequestMoneyEvent] which triggers
/// [RepositoryWallet] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class SendAndRequestMoneyBloc
    extends Bloc<SendAndRequestMoneyEvent, SendAndRequestMoneyState> {
  SendAndRequestMoneyBloc({
    required RepositoryWallet repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryRequestMoney = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(SendAndRequestMoneyInitial()) {
    on<SendAndRequestMoney>(_onRequestMoney);
  }

  final RepositoryWallet mRepositoryRequestMoney;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onRequestMoney] of a new [RequestMoneyRequestMoney] which triggers
  void _onRequestMoney(
    SendAndRequestMoney event,
    Emitter<SendAndRequestMoneyState> emit,
  ) async {
    emit(SendAndRequestMoneyLoading());
    try {
      /// This is a way to handle the response from the API call.

      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryRequestMoney.callSendAndRequestMoneyApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          // Navigator.pop(getNavigatorKeyContext());
          ToastController.showToast(
              success.message.toString(), getNavigatorKeyContext(), true);
          emit(SendAndRequestMoneyResponse(mModelRequestMoney: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(SendAndRequestMoneyFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(SendAndRequestMoneyFailure(
          mError: ValidationString.validationNoInternetFound.translate()));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const SendAndRequestMoneyFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('RequestMoneyFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const SendAndRequestMoneyFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
