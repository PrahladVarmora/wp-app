part of 'update_job_bloc.dart';

/// [UpdateJobState] abstract class is used UpdateJob State
abstract class UpdateJobState extends Equatable {
  const UpdateJobState();

  @override
  List<Object> get props => [];
}

/// [UpdateJobInitial] class is used UpdateJob State Initial
class UpdateJobInitial extends UpdateJobState {}

/// [UpdateJobLoading] class is used UpdateJob State Loading
class UpdateJobLoading extends UpdateJobState {}

/// [UpdateJobAcceptResponse] class is used UpdateJob State Response
class UpdateJobAcceptResponse extends UpdateJobState {
  const UpdateJobAcceptResponse();

  @override
  List<Object> get props => [];
}

/// [UpdateJobFailure] class is used UpdateJob State Failure
class UpdateJobFailure extends UpdateJobState {
  final String mError;

  const UpdateJobFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
