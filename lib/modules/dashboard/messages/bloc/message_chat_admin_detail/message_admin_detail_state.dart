import 'package:equatable/equatable.dart';
import 'package:we_pro/modules/dashboard/messages/model/model_message_detail_response.dart';

class MessageAdminDetailState extends Equatable {
  const MessageAdminDetailState();

  @override
  List<Object?> get props => [];
}

class MessageAdminDetailInitial extends MessageAdminDetailState {}

class MessageAdminDetailLoading extends MessageAdminDetailState {}

class MessageAdminGetChatDetailResponse extends MessageAdminDetailState {
  final ModelMessageDetailResponse modelChatDetailList;

  const MessageAdminGetChatDetailResponse({required this.modelChatDetailList});

  @override
  List<Object?> get props => [modelChatDetailList];
}

class MessageAdminDetailFailure extends MessageAdminDetailState {
  final String mError;

  const MessageAdminDetailFailure(this.mError);

  @override
  List<Object?> get props => [mError];
}
