import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/core/utils/core_import.dart';
import 'package:we_pro/modules/dashboard/wallet/model/model_transactions_history.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryWallet {
  static final RepositoryWallet _repository = RepositoryWallet._internal();

  /// `RepositoryJob()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryJob` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryWallet() {
    return _repository;
  }

  /// A private constructor.
  RepositoryWallet._internal();

  /// It calls the post method of the ApiProvider class and returns the response as a ModelMyJob object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelMyJob, ModelCommonAuthorised>
  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callSendAndRequestMoneyApi(
          String url,
          Map<String, dynamic> body,
          Map<String, String> header,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, body, header, []);
    return response.fold(
      (success) {
        ModelCommonAuthorised result =
            ModelCommonAuthorised.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelTransactionsHistory, ModelCommonAuthorised>>
      callTransactionsApi(
          String url,
          Map<String, dynamic> body,
          Map<String, String> header,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, body, header, []);
    return response.fold(
      (success) {
        ModelTransactionsHistory result =
            ModelTransactionsHistory.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<dynamic, ModelCommonAuthorised>> callTransactionsDownloadApi(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response = await mApiProvider
        .callPostMultipartMethodForDownload(url, body, header);
    return response.fold(
      (success) {
        return left(success ?? Uint8List(0));
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>> callAddMoneyApi(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, body, header, []);
    return response.fold(
      (success) {
        ModelCommonAuthorised result =
            ModelCommonAuthorised.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callApproveRequestApi(
          String url,
          Map<String, dynamic> body,
          Map<String, String> header,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, body, header, []);
    return response.fold(
      (success) {
        ModelCommonAuthorised result =
            ModelCommonAuthorised.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }
}
