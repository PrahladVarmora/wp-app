part of 'add_job_bloc.dart';

/// [AddJobState] abstract class is used AddJob State
abstract class AddJobState extends Equatable {
  const AddJobState();

  @override
  List<Object> get props => [];
}

/// [AddJobInitial] class is used AddJob State Initial
class AddJobInitial extends AddJobState {}

/// [AddJobLoading] class is used AddJob State Loading
class AddJobLoading extends AddJobState {}

/// [AddJobResponse] class is used AddJob State Response
class AddJobResponse extends AddJobState {
  final ModelCommonAuthorised mModelAddJob;

  const AddJobResponse({required this.mModelAddJob});

  @override
  List<Object> get props => [mModelAddJob];
}

/// [AddJobFailure] class is used AddJob State Failure
class AddJobFailure extends AddJobState {
  final String mError;

  const AddJobFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
