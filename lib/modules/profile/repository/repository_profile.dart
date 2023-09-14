import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/profile/model/model_get_profile.dart';
import 'package:we_pro/modules/profile/model/model_setup_stripe.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryProfile {
  static final RepositoryProfile _repository = RepositoryProfile._internal();

  /// `RepositoryProfile()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryProfile` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryProfile() {
    return _repository;
  }

  /// A private constructor.
  RepositoryProfile._internal();

  /// It calls the post method of the ApiProvider class and returns the response as a ModelGetProfile object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelGetProfile, ModelCommonAuthorised>
  Future<Either<ModelGetProfile, ModelCommonAuthorised>> callGetProfile(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callGetMethod(client, url, header);
    return response.fold(
      (success) {
        ModelGetProfile result = ModelGetProfile.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  /// It calls the post method of the ApiProvider class and returns the response as a ModelCommonAuthorised object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelCommonAuthorised, ModelCommonAuthorised>
  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callUpdateProfileUser(
          String url,
          Map<String, String> header,
          Map<String, dynamic> params,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, params, header, []);
    return response.fold(
      (success) {
        ModelCommonAuthorised result =
            ModelCommonAuthorised.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  /// It calls the post method of the ApiProvider class and returns the response as a ModelCommonAuthorised object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelCommonAuthorised, ModelCommonAuthorised>
  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callUpdateProfilePictureApiWithImage(
          String url,
          Map<String, String> header,
          File? imageFile,
          Map<String, dynamic> params,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(
            url,
            params,
            header,
            (imageFile?.path ?? '').isNotEmpty
                ? [
                    ModelMultiPartFile(
                        filePath: imageFile!.path,
                        apiKey: ApiParams.multipartFilePicture)
                  ]
                : []);
    return response.fold(
      (success) {
        ModelCommonAuthorised result =
            ModelCommonAuthorised.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  /// It calls the post method of the ApiProvider class and returns the response as a ModelCommonAuthorised object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelCommonAuthorised, ModelCommonAuthorised>
  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callDrivingLicenceUpdate(
          String url,
          Map<String, String> header,
          List<ModelMultiPartFile> imageFile,
          Map<String, dynamic> params,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response = await mApiProvider
        .callPostMultipartMethod(url, params, header, imageFile);
    return response.fold(
      (success) {
        ModelCommonAuthorised result =
            ModelCommonAuthorised.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  /// This function makes a POST request to a clock-in/out API endpoint with provided headers, parameters, and API provider using an HTTP client and returns an Either object containing either a successful response or an error response.
  ///
  /// Args:
  ///   url (String): The URL of the API endpoint that will be called.
  ///   header (Map<String, String>): A map containing the headers to be sent with the API request. Headers are used to provide additional information about the request, such as authentication tokens or content type.
  ///   params (Map<String, dynamic>): A map of key-value pairs representing the parameters to be sent in the request body. These parameters will be encoded as JSON before being sent to the server.
  ///   mApiProvider (ApiProvider): It seems that `mApiProvider` is an instance of a class or an object that provides API-related functionality such as making HTTP requests, parsing responses, and handling errors. It is likely that this parameter is used to access the API-related methods and properties of the `mApiProvider` object within
  ///   client (http): The `client` parameter is an instance of the `http.Client` class, which is used to send HTTP requests to the server and receive HTTP responses. It is typically used to configure the behavior of the HTTP client, such as setting timeouts, intercepting requests and responses, and handling errors.
  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callPostClockInOutApi(
          String url,
          Map<String, String> header,
          Map<String, dynamic> params,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, params, header, []);
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
      callUpdateAvailabilityAPI(
          String url,
          Map<String, String> header,
          Map<String, dynamic> params,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMethod(client, url, params, header);
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
      callAddCompaniesAPI(
          String url,
          Map<String, String> header,
          Map<String, dynamic> params,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, params, header, []);
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
      callUpdateLiveLocationAPI(
          String url,
          Map<String, String> header,
          Map<String, dynamic> params,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, params, header, []);
    return response.fold(
      (success) {
        ModelCommonAuthorised result =
            ModelCommonAuthorised.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<Companies, ModelCommonAuthorised>> callGetCompanies(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callGetMethod(client, url, header);
    return response.fold(
      (success) {
        Companies result = Companies.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callUpdatePersonalProfileAPI(
          String url,
          Map<String, String> header,
          Map<String, dynamic> params,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, params, header, []);
    return response.fold(
      (success) {
        ModelCommonAuthorised result =
            ModelCommonAuthorised.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelSetUpStripe, ModelCommonAuthorised>> callSetupStripeAPI(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callGetMethod(client, url, header);
    return response.fold(
      (success) {
        ModelSetUpStripe result =
            ModelSetUpStripe.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }
}
