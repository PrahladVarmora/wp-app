import 'package:equatable/equatable.dart';
import 'package:we_pro/modules/dashboard/messages/model/model_message_detail_response.dart';

class MessageDetailState extends Equatable {
  const MessageDetailState();

  @override
  List<Object?> get props => [];
}

class MessageDetailInitial extends MessageDetailState {}

class MessageDetailLoading extends MessageDetailState {}

class MessageGetChatDetailResponse extends MessageDetailState {
  final ModelMessageDetailResponse modelChatDetailList;

  const MessageGetChatDetailResponse({required this.modelChatDetailList});

  @override
  List<Object?> get props => [modelChatDetailList];
}

class MessageDetailFailure extends MessageDetailState {
  final String mError;

  const MessageDetailFailure(this.mError);

  @override
  List<Object?> get props => [mError];
}
