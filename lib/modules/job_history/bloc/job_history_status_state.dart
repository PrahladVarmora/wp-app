import 'package:equatable/equatable.dart';
import 'package:we_pro/modules/dashboard/model/model_job_history.dart';

///[JobHistoryStatusState] this class use for JobHistory state
class JobHistoryStatusState extends Equatable {
  const JobHistoryStatusState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

///[JobHistoryInitial] this class use for JobHistory state initial
class JobHistoryInitial extends JobHistoryStatusState {}

///[JobHistoryLoading] this class use for JobHistory state  Loading
class JobHistoryLoading extends JobHistoryStatusState {}

///[JobHistoryResponse] this class use for JobHistory state Response
class JobHistoryResponse extends JobHistoryStatusState {
  final ModelJobHistory mModelJobHistory;

  const JobHistoryResponse({required this.mModelJobHistory});

  @override
  List<Object> get props => [mModelJobHistory];
}

///[JobHistoryFailure] this class use for JobHistory state Failure
class JobHistoryFailure extends JobHistoryStatusState {
  final String mError;

  const JobHistoryFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
