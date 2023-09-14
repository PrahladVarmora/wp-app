import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/api_service/api_provider.dart';
import 'package:we_pro/modules/dashboard/messages/bloc/message_chat_list/message_state.dart';
import 'package:we_pro/modules/dashboard/messages/repositry/repository_message.dart';

import '../../../../core/common/modelCommon/model_common_authorised.dart';
import '../../../../core/utils/validation_string.dart';
import '../../model/model_chat_list.dart';
import 'message_event.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final RepositoryMessage mRepositoryMessage;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  MessageBloc(
      {required RepositoryMessage repositoryMessage,
      required ApiProvider apiProvider,
      required http.Client client})
      : mApiProvider = apiProvider,
        mClient = client,
        mRepositoryMessage = repositoryMessage,
        super(MessageInitial()) {
    on<MessageGetChatList>(_getChatList);
  }

  Future<void> _getChatList(
      MessageGetChatList event, Emitter<MessageState> emit) async {
    emit(MessageLoading());
    try {
      Either<dynamic, ModelCommonAuthorised> response =
          await mRepositoryMessage.callGetChatListApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient);
      response.fold(
        (success) {
          emit(MessageGetChatListResponse(success as ModelChatList));
        },
        (error) {
          emit(MessageFailure(error.message!));
        },
      );
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const MessageFailure(ValidationString.validationNoInternetFound));
      } else {
        emit(const MessageFailure(
            ValidationString.validationInternalServerIssue));
      }
    }
  }
}
