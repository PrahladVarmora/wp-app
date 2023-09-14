part of 'rejected_job_bloc.dart';

/// [RejectedJobState] abstract class is used RejectedJob State
abstract class RejectedJobState extends Equatable {
  const RejectedJobState();

  @override
  List<Object> get props => [];
}

/// [RejectedJobInitial] class is used RejectedJob State Initial
class RejectedJobInitial extends RejectedJobState {}

/// [RejectedJobLoading] class is used RejectedJob State Loading
class RejectedJobLoading extends RejectedJobState {}

/// [RejectedJobResponse] class is used RejectedJob State Response
class RejectedJobResponse extends RejectedJobState {
  final ModelCommonAuthorised mModelRejectedJob;

  const RejectedJobResponse({required this.mModelRejectedJob});

  @override
  List<Object> get props => [mModelRejectedJob];
}

/// [RejectedJobFailure] class is used RejectedJob State Failure
class RejectedJobFailure extends RejectedJobState {
  final String mError;

  const RejectedJobFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
