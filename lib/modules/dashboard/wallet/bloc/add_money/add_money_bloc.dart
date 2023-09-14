import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/wallet/repository/repository_wallet.dart';

part 'add_money_event.dart';

part 'add_money_state.dart';

/// Notifies the [AddMoneyBloc] of a new [AddMoneyEvent] which triggers
/// [RepositoryWallet] This class used to API and bloc connection.
/// [ApiProvider] class is used to network API call.
class AddMoneyBloc extends Bloc<AddMoneyEvent, AddMoneyState> {
  AddMoneyBloc({
    required RepositoryWallet repository,
    required ApiProvider apiProvider,
    required http.Client client,
  })  : mRepositoryRequestMoney = repository,
        mApiProvider = apiProvider,
        mClient = client,
        super(AddMoneyInitial()) {
    on<AddMoney>(_onRequestMoney);
  }

  final RepositoryWallet mRepositoryRequestMoney;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  /// Notifies the [_onRequestMoney] of a new [RequestMoneyRequestMoney] which triggers
  void _onRequestMoney(
    AddMoney event,
    Emitter<AddMoneyState> emit,
  ) async {
    emit(AddMoneyLoading());
    try {
      /// This is a way to handle the response from the API call.

      Either<ModelCommonAuthorised, ModelCommonAuthorised> response =
          await mRepositoryRequestMoney.callAddMoneyApi(
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
          emit(AddMoneyResponse(mModelRequestMoney: success));
        },
        (error) {
          ToastController.showToast(
              error.message.toString(), getNavigatorKeyContext(), false);

          emit(AddMoneyFailure(mError: error.message!));
        },
      );
    } on SocketException {
      ToastController.showToast(
          ValidationString.validationNoInternetFound.translate(),
          getNavigatorKeyContext(),
          false);
      emit(AddMoneyFailure(
          mError: ValidationString.validationNoInternetFound.translate()));
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        ToastController.showToast(
            ValidationString.validationXMLHttpRequest.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const AddMoneyFailure(
            mError: ValidationString.validationNoInternetFound));
      } else {
        printWrapped('RequestMoneyFailure-----$e');
        ToastController.showToast(
            ValidationString.validationInternalServerIssue.translate(),
            getNavigatorKeyContext(),
            false);
        emit(const AddMoneyFailure(
            mError: ValidationString.validationInternalServerIssue));
      }
    }
  }
}
