import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/api_service/api_provider.dart';
import 'package:we_pro/modules/core/api_service/common_service.dart';
import 'package:we_pro/modules/core/common/widgets/toast_controller.dart';
import 'package:we_pro/modules/dashboard/messages/repositry/repository_message.dart';

import '../../../../core/common/modelCommon/model_common_authorised.dart';
import '../../../../core/utils/validation_string.dart';
import 'message_send_event.dart';
import 'message_send_state.dart';

class MessageSendBloc extends Bloc<MessageSendEvent, MessageSendState> {
  final RepositoryMessage mRepositoryMessage;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  MessageSendBloc(
      {required RepositoryMessage repositoryMessage,
      required ApiProvider apiProvider,
      required http.Client client})
      : mApiProvider = apiProvider,
        mClient = client,
        mRepositoryMessage = repositoryMessage,
        super(MessageSendInitial()) {
    on<MessageSendRequest>(_sendMessage);
  }

  Future<void> _sendMessage(
      MessageSendRequest event, Emitter<MessageSendState> emit) async {
    emit(MessageSendLoading());
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
          emit(MessageSendResponse(success as ModelCommonAuthorised));
        },
        (error) {
          ToastController.showToast(
              error.message ?? '', getNavigatorKeyContext(), false);
          emit(MessageSendFailure(error.message!));
        },
      );
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const MessageSendFailure(
            ValidationString.validationNoInternetFound));
      } else {
        emit(const MessageSendFailure(
            ValidationString.validationInternalServerIssue));
      }
    }
  }
}
