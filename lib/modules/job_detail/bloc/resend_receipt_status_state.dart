import 'package:equatable/equatable.dart';
import 'package:we_pro/modules/core/common/modelCommon/model_common_authorised.dart';

///[ResendReceiptStatusState] this class use for JobHistory state
class ResendReceiptStatusState extends Equatable {
  const ResendReceiptStatusState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

///[ResendReceiptInitial] this class use for JobHistory state initial
class ResendReceiptInitial extends ResendReceiptStatusState {}

///[ResendReceiptLoading] this class use for JobHistory state  Loading
class ResendReceiptLoading extends ResendReceiptStatusState {}

///[ResendReceiptResponse] this class use for JobHistory state Response
class ResendReceiptResponse extends ResendReceiptStatusState {
  final ModelCommonAuthorised mModelCommonAuthorised;

  const ResendReceiptResponse({required this.mModelCommonAuthorised});

  @override
  List<Object> get props => [mModelCommonAuthorised];
}

///[ResendReceiptFailure] this class use for JobHistory state Failure
class ResendReceiptFailure extends ResendReceiptStatusState {
  final String mError;

  const ResendReceiptFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
