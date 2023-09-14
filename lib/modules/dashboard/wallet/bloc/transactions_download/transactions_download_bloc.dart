import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/wallet/repository/repository_wallet.dart';

part 'transactions_download_event.dart';

part 'transactions_download_state.dart';

/// Notifies the [TransactionsDownloadBloc] of a new [TransactionsDownloadEvent] which triggers
/// [RepositoryWallet] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class TransactionsDownloadBloc
    extends Bloc<TransactionsDownloadEvent, TransactionsDownloadState> {
  TransactionsDownloadBloc({
    required RepositoryWallet repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryRequestMoney = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(TransactionsDownloadInitial()) {
    on<TransactionsDownload>(_onRequestMoney);
  }

  final RepositoryWallet mRepositoryRequestMoney;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onRequestMoney] of a new [RequestMoneyRequestMoney] which triggers
  void _onRequestMoney(
    TransactionsDownload event,
    Emitter<TransactionsDownloadState> emit,
  ) async {
    emit(TransactionsDownloadLoading());
    try {
      Either<dynamic, ModelCommonAuthorised> response =
          await mRepositoryRequestMoney.callTransactionsDownloadApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      await response.fold(
        (success) async {
          await Printing.sharePdf(bytes: success, filename: 'wepro.pdf');
          emit(const TransactionsDownloadResponse());
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(TransactionsDownloadFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(TransactionsDownloadFailure(
          mError: ValidationString.validationNoInternetFound.translate()));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const TransactionsDownloadFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('RequestMoneyFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const TransactionsDownloadFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
