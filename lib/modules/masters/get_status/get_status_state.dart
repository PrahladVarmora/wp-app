part of 'get_status_bloc.dart';

/// [GetStatusState] abstract class is used GetStatus State
abstract class GetStatusState extends Equatable {
  const GetStatusState();

  @override
  List<Object> get props => [];
}

/// [GetStatusInitial] class is used GetStatus State Initial
class GetStatusInitial extends GetStatusState {}

/// [GetStatusLoading] class is used GetStatus State Loading
class GetStatusLoading extends GetStatusState {}

/// [GetStatusResponse] class is used GetStatus State Response
class GetStatusResponse extends GetStatusState {
  final ModelGetStatus mGetStatus;

  const GetStatusResponse({required this.mGetStatus});

  @override
  List<Object> get props => [mGetStatus];
}

/// [GetStatusFailure] class is used GetStatus State Failure
class GetStatusFailure extends GetStatusState {
  final String mError;

  const GetStatusFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
