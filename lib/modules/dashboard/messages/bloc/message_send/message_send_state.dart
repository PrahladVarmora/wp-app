import 'package:equatable/equatable.dart';
import 'package:we_pro/modules/core/common/modelCommon/model_common_authorised.dart';

class MessageSendState extends Equatable {
  const MessageSendState();

  @override
  List<Object?> get props => [];
}

class MessageSendInitial extends MessageSendState {}

class MessageSendLoading extends MessageSendState {}

class MessageSendResponse extends MessageSendState {
  final ModelCommonAuthorised common;

  const MessageSendResponse(this.common);

  @override
  List<Object?> get props => [common];
}

class MessageSendFailure extends MessageSendState {
  final String mError;

  const MessageSendFailure(this.mError);

  @override
  List<Object?> get props => [mError];
}
