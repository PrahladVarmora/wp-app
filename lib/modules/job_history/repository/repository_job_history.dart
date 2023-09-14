import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/api_service/api_provider.dart';
import 'package:we_pro/modules/core/common/modelCommon/model_common_authorised.dart';
import 'package:we_pro/modules/dashboard/model/model_job_history.dart';

class RepositoryJobHistory {
  static final RepositoryJobHistory _repository =
      RepositoryJobHistory._internal();

  factory RepositoryJobHistory() {
    return _repository;
  }

  RepositoryJobHistory._internal();

  Future<Either<ModelJobHistory, ModelCommonAuthorised>> callJobHistoryListApi(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider apiProvider,
      http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await apiProvider.callPostMultipartMethod(url, body, header, []);

    return response.fold(
      (success) {
        ModelJobHistory result = ModelJobHistory.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callResendReceiptApi(
          String url,
          Map<String, dynamic> body,
          Map<String, String> header,
          ApiProvider apiProvider,
          http.Client client) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await apiProvider.callPostMultipartMethod(url, body, header, []);

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
