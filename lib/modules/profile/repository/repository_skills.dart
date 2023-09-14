import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_car_info.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_industry.dart';
import 'package:we_pro/modules/profile/model/skills/model_select_job_types.dart';

/// This class used to API and bloc connection
/// This class is used to call the post api and return the response in the form of ModelUser
class RepositorySkills {
  static final RepositorySkills _repository = RepositorySkills._internal();

  /// `RepositorySkills()` is a factory constructor that returns a singleton instance of the
  /// `RepositorySkills` class
  ///
  /// Returns:
  ///   The repository
  factory RepositorySkills() {
    return _repository;
  }

  /// A private constructor.
  RepositorySkills._internal();

  /// It calls the post method of the ApiProvider class and returns the response as a ModelIndustry object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelIndustry, ModelCommonAuthorised>
  Future<Either<ModelIndustry, ModelCommonAuthorised>> callGetIndustry(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callGetMethod(client, url, header);
    return response.fold(
      (success) {
        ModelIndustry result = ModelIndustry.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  /// It calls the post method of the ApiProvider class and returns the response as a ModelIndustry object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   body (Map<String, dynamic>): The body of the request.
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelIndustry, ModelCommonAuthorised>
  Future<Either<ModelJobTypes, ModelCommonAuthorised>> callGetJobTypes(
      String url,
      Map<String, dynamic> mBody,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, mBody, header, []);
    return response.fold(
      (success) {
        ModelJobTypes result = ModelJobTypes.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelCarInfo, ModelCommonAuthorised>> callGetMakeModelYear(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callGetMethod(client, url, header);
    return response.fold(
      (success) {
        try {
          ModelCarInfo result = ModelCarInfo.fromJson(jsonDecode(success));
          return left(result);
        } catch (e) {
          return right(ModelCommonAuthorised(message: e.toString()));
        }
      },
      (error) => right(error),
    );
  }
}
