import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:we_pro/modules/core/api_service/api_provider.dart';
import 'package:we_pro/modules/dashboard/messages/model/model_message_detail_response.dart';
import 'package:we_pro/modules/dashboard/messages/repositry/repository_message.dart';

import '../../../../core/common/modelCommon/model_common_authorised.dart';
import '../../../../core/utils/validation_string.dart';
import 'message_admin_detail_event.dart';
import 'message_admin_detail_state.dart';

class MessageAdminDetailBloc
    extends Bloc<MessageAdminDetailEvent, MessageAdminDetailState> {
  final RepositoryMessage mRepositoryMessage;
  final ApiProvider mApiProvider;
  final http.Client mClient;

  MessageAdminDetailBloc(
      {required RepositoryMessage repositoryMessage,
      required ApiProvider apiProvider,
      required http.Client client})
      : mApiProvider = apiProvider,
        mClient = client,
        mRepositoryMessage = repositoryMessage,
        super(MessageAdminDetailInitial()) {
    on<MessageAdminGetChatDetail>(_getChatDetailList);
  }

  Future<void> _getChatDetailList(MessageAdminGetChatDetail event,
      Emitter<MessageAdminDetailState> emit) async {
    emit(MessageAdminDetailLoading());
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
          emit(MessageAdminGetChatDetailResponse(
              modelChatDetailList: success as ModelMessageDetailResponse));
        },
        (error) {
          emit(MessageAdminDetailFailure(error.message!));
        },
      );
    } catch (e) {
      if (e.toString().contains(ValidationString.validationXMLHttpRequest)) {
        emit(const MessageAdminDetailFailure(
            ValidationString.validationNoInternetFound));
      } else {
        emit(const MessageAdminDetailFailure(
            ValidationString.validationInternalServerIssue));
      }
    }
  }
}
