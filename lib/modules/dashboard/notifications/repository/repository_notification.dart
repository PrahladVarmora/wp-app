import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/dashboard/notifications/modal/modal_notification_list.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryNotification {
  static final RepositoryNotification _repository =
      RepositoryNotification._internal();

  /// `RepositoryJob()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryJob` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryNotification() {
    return _repository;
  }

  /// A private constructor.
  RepositoryNotification._internal();

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
  Future<Either<ModelNotificationsList, ModelCommonAuthorised>>
      callNotificationsListApi(
          String url,
          Map<String, dynamic> body,
          Map<String, String> header,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, body, header, []);
    return response.fold(
      (success) {
        ModelNotificationsList result =
            ModelNotificationsList.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callNotificationsUpdateStatusApi(
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
      callNotificationsClearListApi(String url, Map<String, String> header,
          ApiProvider mApiProvider, http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, {}, header, []);
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
