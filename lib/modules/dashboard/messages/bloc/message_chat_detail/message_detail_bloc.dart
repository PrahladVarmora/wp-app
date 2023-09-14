import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/api_service/api_provider.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_chat_detail/message_detail_state.dart';
import 'package:we_pro/modules/dashboard/messages/model/model_message_detail_response.dart';
import 'package:we_pro/modules/dashboard/messages/repositry/repository_message.dart';

import '../../../../core/common/modelCommon/model_common_authorised.dart';
import '../../../../core/utils/validation_string.dart';
import 'message_detail_event.dart';

class MessageDetailBloc extends Bloc<MessageDetailEvent, MessageDetailState> {
  final RepositoryMessage mRepositoryMessage;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  MessageDetailBloc(
      {required RepositoryMessage repositoryMessage,
      required ApiProvider apiProvider,
      required http.Client client})
      : mApiProvider = apiProvider,
        mClient = client,
        mRepositoryMessage = repositoryMessage,
        super(MessageDetailInitial()) {
    on<MessageGetChatDetail>(_getChatDetailList);
  }

  Future<void> _getChatDetailList(
      MessageGetChatDetail event, Emitter<MessageDetailState> emit) async {
    if (event.showLoader) {
      emit(MessageDetailLoading());
    }
    try {
      Either<dynamic, ModelCommonAuthorised> response =
          await mRepositoryMessage.callGetChatDetailApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          emit(MessageGetChatDetailResponse(
              modelChatDetailList: success as ModelMessageDetailResponse));
        },
        (error) {
          emit(MessageDetailFailure(error.message!));
        },
      );
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const MessageDetailFailure(
            ValidationString.validationNoInternetFound));
      } else {
        emit(const MessageDetailFailure(
            ValidationString.validationInternalServerIssue));
      }
    }
  }
}
