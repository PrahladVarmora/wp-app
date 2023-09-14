import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/optimize_route/model/model_google_optimise_route.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryOptimizeRoute {
  static final RepositoryOptimizeRoute _repository =
      RepositoryOptimizeRoute._internal();

  /// `RepositoryJob()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryJob` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryOptimizeRoute() {
    return _repository;
  }

  /// A private constructor.
  RepositoryOptimizeRoute._internal();

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
  Future<Either<ModelGoogleOptimizeRoute, ModelCommonAuthorised>>
      callPostMyJobApi(
          String url,
          Map<String, dynamic> body,
          Map<String, String> header,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMethod(client, url, body, header);
    return response.fold(
      (success) {
        ModelGoogleOptimizeRoute result =
            ModelGoogleOptimizeRoute.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callOptimizeRouteApi(
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
