part of 'change_priority_bloc.dart';

/// [ChangePriorityState] abstract class is used ChangePriority State
abstract class ChangePriorityState extends Equatable {
  const ChangePriorityState();

  @override
  List<Object> get props => [];
}

/// [ChangePriorityInitial] class is used ChangePriority State Initial
class ChangePriorityInitial extends ChangePriorityState {}

/// [ChangePriorityLoading] class is used ChangePriority State Loading
class ChangePriorityLoading extends ChangePriorityState {}

/// [ChangePriorityResponse] class is used ChangePriority State Response
class ChangePriorityResponse extends ChangePriorityState {
  final ModelCommonAuthorised mModelChangePriority;

  const ChangePriorityResponse({required this.mModelChangePriority});

  @override
  List<Object> get props => [mModelChangePriority];
}

/// [ChangePriorityFailure] class is used ChangePriority State Failure
class ChangePriorityFailure extends ChangePriorityState {
  final String mError;

  const ChangePriorityFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
