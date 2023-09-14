import 'package:equatable/equatable.dart';
import 'package:we_pro/modules/core/common/modelCommon/model_common_authorised.dart';

class MessageAdminSendState extends Equatable {
  const MessageAdminSendState();

  @override
  List<Object?> get props => [];
}

class MessageAdminSendInitial extends MessageAdminSendState {}

class MessageAdminSendLoading extends MessageAdminSendState {}

class MessageAdminSendResponse extends MessageAdminSendState {
  final ModelCommonAuthorised common;

  const MessageAdminSendResponse(this.common);

  @override
  List<Object?> get props => [common];
}

class MessageAdminSendFailure extends MessageAdminSendState {
  final String mError;

  const MessageAdminSendFailure(this.mError);

  @override
  List<Object?> get props => [mError];
}
