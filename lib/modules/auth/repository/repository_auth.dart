import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/auth/model/model_get_skills.dart';
import 'package:we_pro/modules/core/utils/api_import.dart';

import '../model/model_user.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositoryAuth {
  static final RepositoryAuth _repository = RepositoryAuth._internal();

  /// `RepositoryAuth()` is a factory constructor that returns a singleton instance of the
  /// `RepositoryAuth` class
  ///
  /// Returns:
  ///   The repository
  factory RepositoryAuth() {
    return _repository;
  }

  /// A private constructor.
  RepositoryAuth._internal();

  /// It calls the post method of the ApiProvider class and returns the response as a ModelUser object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelUser, ModelCommonAuthorised>
  Future<Either<ModelUser, ModelCommonAuthorised>> callPostSignInApi(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, body, header, []);
    return response.fold(
      (success) {
        ModelUser result = ModelUser.fromJson(jsonDecode(success));
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
  ///   Either<ModelUser, ModelCommonAuthorised>
  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callPostLogoutApi(
          String url,
          Map<String, dynamic> body,
          Map<String, String> header,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMethod(client, url, body, header);
    return response.fold(
      (success) {
        ModelCommonAuthorised result =
            ModelCommonAuthorised.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  /// It calls the post method of the ApiProvider class and returns the response as a ModelUser object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelUser, ModelCommonAuthorised>
  Future<Either<ModelUser, ModelCommonAuthorised>> callSignUpApiWithImage(
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
        ModelUser result = ModelUser.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

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

  /// It calls the post method of the ApiProvider class and returns the response as a ModelUser object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelForgotPassword, ModelCommonAuthorised>
  Future<Either<ModelUser, ModelCommonAuthorised>> callPostForgotPasswordApi(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, body, header, []);
    return response.fold(
      (success) {
        ModelUser result = ModelUser.fromJson(jsonDecode(success));
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
      callPostOTPSendApi(
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
      callPostVerifyOtpApi(
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
      callPostResetPasswordApi(
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
      callPostVerifyAccessTokenApi(
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

  /// It calls the post method of the ApiProvider class and returns the response as a ModelUser object
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
  Future<Either<ModelUser, ModelCommonAuthorised>> callPostRenewAccessTokenApi(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, body, header, []);
    return response.fold(
      (success) {
        ModelUser result = ModelUser.fromJson(jsonDecode(success));
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
  Future<Either<ModelUser, ModelCommonAuthorised>>
      callPostOTPVerifyForgotPasswordApi(
          String url,
          Map<String, dynamic> body,
          Map<String, String> header,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, body, header, []);
    return response.fold(
      (success) {
        ModelUser result = ModelUser.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  /// It calls the post method of the ApiProvider class and returns the response as a ModelCommonAuthorised object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<dynamic, ModelCommonAuthorised>
  Future<Either<dynamic, ModelCommonAuthorised>> callGetSkillData(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callGetMethod(client, url, header);
    return response.fold(
      (success) {
        ModelGetSkills result = ModelGetSkills.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<dynamic, ModelCommonAuthorised>>

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
      callSetSkillData(
          String url,
          List<dynamic> body,
          Map<String, String> header,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMethodWithList(client, url, body, header);
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
      callPostDeleteAccountApi(String url, Map<String, String> header,
          ApiProvider mApiProvider, http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMethod(client, url, {}, header);
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
