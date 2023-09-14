part of 'my_job_bloc.dart';

/// [MyJobState] abstract class is used MyJob State
abstract class MyJobState extends Equatable {
  const MyJobState();

  @override
  List<Object> get props => [];
}

/// [MyJobInitial] class is used MyJob State Initial
class MyJobInitial extends MyJobState {}

/// [MyJobLoading] class is used MyJob State Loading
class MyJobLoading extends MyJobState {}

/// [NewJobLoading] class is used NewJob State Loading
class NewJobLoading extends MyJobState {}

/// [MyJobResponse] class is used MyJob State Response
class MyJobResponse extends MyJobState {
  final ModelMyJob mModelMyJob;

  const MyJobResponse({required this.mModelMyJob});

  @override
  List<Object> get props => [mModelMyJob];
}

/// [NewJobResponse] class is used New Job State Response
class NewJobResponse extends MyJobState {
  final ModelMyJob mModelNewJob;

  const NewJobResponse({required this.mModelNewJob});

  @override
  List<Object> get props => [mModelNewJob];
}

/// [MyJobFailure] class is used MyJob State Failure
class MyJobFailure extends MyJobState {
  final String mError;

  const MyJobFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
