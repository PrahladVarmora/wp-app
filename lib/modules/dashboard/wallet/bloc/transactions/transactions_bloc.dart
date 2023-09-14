import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/wallet/model/model_transactions_history.dart';
import 'package:we_pro/modules/dashboard/wallet/repository/repository_wallet.dart';

part 'transactions_event.dart';

part 'transactions_state.dart';

/// Notifies the [TransactionsBloc] of a new [TransactionsEvent] which triggers
/// [RepositoryWallet] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    required RepositoryWallet repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryRequestMoney = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(TransactionsInitial()) {
    on<Transactions>(_onRequestMoney);
  }

  final RepositoryWallet mRepositoryRequestMoney;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onRequestMoney] of a new [RequestMoneyRequestMoney] which triggers
  void _onRequestMoney(
    Transactions event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(TransactionsLoading());
    try {
      /// This is a way to handle the response from the API call.

      Either<ModelTransactionsHistory, ModelCommonAuthorised> response =
          await mRepositoryRequestMoney.callTransactionsApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          // Navigator.pop(getNavigatorKeyContext());

          emit(TransactionsResponse(mModelTransactionsHistory: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(TransactionsFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(TransactionsFailure(
          mError: ValidationString.validationNoInternetFound.translate()));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const TransactionsFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('RequestMoneyFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const TransactionsFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
