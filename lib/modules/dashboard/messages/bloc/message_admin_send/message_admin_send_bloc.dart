import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/api_service/api_provider.dart';
import 'package:we_pro/modules/dashboard/messages/repositry/repository_message.dart';

import '../../../../core/common/modelCommon/model_common_authorised.dart';
import '../../../../core/utils/validation_string.dart';
import 'message_admin_send_event.dart';
import 'message_admin_send_state.dart';

class MessageAdminSendBloc
    extends Bloc<MessageAdminSendEvent, MessageAdminSendState> {
  final RepositoryMessage mRepositoryMessage;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  MessageAdminSendBloc(
      {required RepositoryMessage repositoryMessage,
      required ApiProvider apiProvider,
      required http.Client client})
      : mApiProvider = apiProvider,
        mClient = client,
        mRepositoryMessage = repositoryMessage,
        super(MessageAdminSendInitial()) {
    on<MessageAdminSendRequest>(_sendMessage);
  }

  Future<void> _sendMessage(MessageAdminSendRequest event,
      Emitter<MessageAdminSendState> emit) async {
    emit(MessageAdminSendLoading());
    try {
      Either<dynamic, ModelCommonAuthorised> response =
          await mRepositoryMessage.callSendMessageApi(
              event.url,
              event.body,
              await mApiProvider.getHeaderValueWithUserToken(),
              mApiProvider,
              mClient,
              event.imageFile);
      response.fold(
        (success) {
          emit(MessageAdminSendResponse(success as ModelCommonAuthorised));
        },
        (error) {
          emit(MessageAdminSendFailure(error.message!));
        },
      );
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const MessageAdminSendFailure(
            ValidationString.validationNoInternetFound));
      } else {
        emit(const MessageAdminSendFailure(
            ValidationString.validationInternalServerIssue));
      }
    }
  }
}
