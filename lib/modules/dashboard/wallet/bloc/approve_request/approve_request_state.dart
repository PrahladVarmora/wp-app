part of 'approve_request_bloc.dart';

/// [ApproveRequestState] abstract class is used RequestMoney State
abstract class ApproveRequestState extends Equatable {
  const ApproveRequestState();

  @override
  List<Object> get props => [];
}

/// [ApproveRequestInitial] class is used ApproveRequest State Initial
class ApproveRequestInitial extends ApproveRequestState {}

/// [ApproveRequestLoading] class is used ApproveRequest State Loading
class ApproveRequestLoading extends ApproveRequestState {}

/// [ApproveRequestResponse] class is used ApproveRequest State Response
class ApproveRequestResponse extends ApproveRequestState {
  final ModelCommonAuthorised mModelRequestMoney;

  const ApproveRequestResponse({required this.mModelRequestMoney});

  @override
  List<Object> get props => [mModelRequestMoney];
}

/// [ApproveRequestFailure] class is used RequestMoney State Failure
class ApproveRequestFailure extends ApproveRequestState {
  final String mError;

  const ApproveRequestFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
