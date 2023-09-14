import 'package:equatable/equatable.dart';
import 'package:we_pro/modules/dashboard/messages/model/model_chat_list.dart';

class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageGetChatListResponse extends MessageState {
  final ModelChatList modelChatList;

  const MessageGetChatListResponse(this.modelChatList);

  @override
  List<Object?> get props => [modelChatList];
}

class MessageFailure extends MessageState {
  final String mError;

  const MessageFailure(this.mError);

  @override
  List<Object?> get props => [mError];
}
