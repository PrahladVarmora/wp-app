import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/api_service/api_provider.dart';
import 'package:we_pro/modules/core/common/modelCommon/model_common_authorised.dart';
import 'package:we_pro/modules/dashboard/messages/model/model_message_detail_response.dart';

import '../../../core/utils/api_params.dart';
import '../model/model_chat_list.dart';

class RepositoryMessage {
  static final RepositoryMessage _repository = RepositoryMessage._internal();

  factory RepositoryMessage() {
    return _repository;
  }

  RepositoryMessage._internal();

  Future<Either<ModelChatList, ModelCommonAuthorised>> callGetChatListApi(
      String url,
      Map<String, dynamic> body,
      Map<String, String> header,
      ApiProvider apiProvider,
      http.Client clint) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await apiProvider.callPostMultipartMethod(url, body, header, []);
    return response.fold(
      (success) {
        ModelChatList result = ModelChatList.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelMessageDetailResponse, ModelCommonAuthorised>>
      callGetChatDetailApi(
          String url,
          Map<String, dynamic> body,
          Map<String, String> header,
          ApiProvider apiProvider,
          http.Client clint) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await apiProvider.callPostMultipartMethod(url, body, header, []);
    return response.fold(
      (success) {
        ModelMessageDetailResponse result =
            ModelMessageDetailResponse.fromJson(jsonDecode(success));
        return left(result);
      },
      (error) => right(error),
    );
  }

  Future<Either<ModelCommonAuthorised, ModelCommonAuthorised>>
      callSendMessageApi(
    String url,
    Map<String, dynamic> body,
    Map<String, String> header,
    ApiProvider apiProvider,
    http.Client clint,
    File? imageFile,
  ) async {
    Either<dynamic, ModelCommonAuthorised> response =
        await apiProvider.callPostMultipartMethod(
            url,
            body,
            header,
            (imageFile?.path ?? '').isNotEmpty
                ? [
                    ModelMultiPartFile(
                        filePath: imageFile!.path,
                        apiKey: ApiParams.multipartImg)
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
}
