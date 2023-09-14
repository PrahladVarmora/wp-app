part of 'job_close_bloc.dart';

/// [JobCloseState] abstract class is used JobClose State
abstract class JobCloseState extends Equatable {
  const JobCloseState();

  @override
  List<Object> get props => [];
}

/// [JobCloseInitial] class is used JobClose State Initial
class JobCloseInitial extends JobCloseState {}

/// [JobCloseLoading] class is used JobClose State Loading
class JobCloseLoading extends JobCloseState {}

/// [JobCloseResponse] class is used JobClose State Response
class JobCloseResponse extends JobCloseState {
  final ModelCommonAuthorised mModelJobClose;

  const JobCloseResponse({required this.mModelJobClose});

  @override
  List<Object> get props => [mModelJobClose];
}

/// [JobCloseFailure] class is used JobClose State Failure
class JobCloseFailure extends JobCloseState {
  final String mError;

  const JobCloseFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
