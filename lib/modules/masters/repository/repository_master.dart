import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/utils/api_import.dart';
import 'package:we_pro/modules/dashboard/model/model_job_types_history_filter.dart';
import 'package:we_pro/modules/masters/model/model_get_status.dart';
import 'package:we_pro/modules/masters/model/model_skill.dart';
import 'package:we_pro/modules/masters/model/model_sources.dart';
import 'package:we_pro/modules/masters/model/model_sources_categories.dart';
import 'package:we_pro/modules/masters/model/model_sources_category_types.dart';
import 'package:we_pro/modules/masters/model/model_sources_subtypes.dart';

/// This class used to API and bloc connection
class RepositoryMaster {
  static final RepositoryMaster _repository = RepositoryMaster._internal();

  factory RepositoryMaster() {
    return _repository;
  }

  RepositoryMaster._internal();

  /// It calls the get method of the ApiProvider class and returns the response as a ModelSources object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelSources, ModelCommonAuthorised>
  Future<Either<ModelSourcesList, ModelCommonAuthorised>> callGetSourceListApi(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callGetMethod(client, url, header);
    return response.fold(
      (success) {
        ModelSourcesList result =
            ModelSourcesList.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelSourcesCategories, ModelCommonAuthorised>>
      callGetSourcesCategoriesListApi(
          String url,
          Map<String, dynamic> mBody,
          Map<String, String> header,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, mBody, header, []);
    return response.fold(
      (success) {
        ModelSourcesCategories result =
            ModelSourcesCategories.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelSourcesCategoryTypes, ModelCommonAuthorised>>
      callGetCategoryTypesListApi(
          String url,
          Map<String, dynamic> mBody,
          Map<String, String> header,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, mBody, header, []);
    return response.fold(
      (success) {
        ModelSourcesCategoryTypes result =
            ModelSourcesCategoryTypes.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelSourcesSubtypes, ModelCommonAuthorised>>
      callGetTypeSubtypesListApi(
          String url,
          Map<String, dynamic> mBody,
          Map<String, String> header,
          ApiProvider mApiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callPostMultipartMethod(url, mBody, header, []);
    return response.fold(
      (success) {
        ModelSourcesSubtypes result =
            ModelSourcesSubtypes.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  /// It calls the get method of the ApiProvider class and returns the response as a ModelSkill object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelSkill, ModelCommonAuthorised>
  Future<Either<ModelSkill, ModelCommonAuthorised>> callGetSkillListApi(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callGetMethod(client, url, header);
    return response.fold(
      (success) {
        ModelSkill result = ModelSkill.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  /// It calls the get method of the ApiProvider class and returns the response as a ModelGetStatus object
  ///
  /// Args:
  ///   url (String): The url of the api
  ///   header (Map<String, String>): This is the header of the request.
  ///   mApiProvider (ApiProvider): This is the ApiProvider class that we created earlier.
  ///   client (http): http.Client object
  ///
  /// Returns:
  ///   Either<ModelGetStatus, ModelCommonAuthorised>
  Future<Either<ModelGetStatus, ModelCommonAuthorised>> callGetStatusListApi(
      String url,
      Map<String, String> header,
      ApiProvider mApiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callGetMethod(client, url, header);
    return response.fold(
      (success) {
        ModelGetStatus result = ModelGetStatus.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelJobTypesHistoryFilter, ModelCommonAuthorised>>
      callJobTypesFilterListApi(String url, Map<String, String> header,
          ApiProvider mApiProvider, http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await mApiProvider.callGetMethod(client, url, header);
    return response.fold(
      (success) {
        ModelJobTypesHistoryFilter result =
            ModelJobTypesHistoryFilter.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }
}
