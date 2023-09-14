part of 'job_detail_bloc.dart';

/// [JobDetailState] abstract class is used JobDetail State
abstract class JobDetailState extends Equatable {
  const JobDetailState();

  @override
  List<Object> get props => [];
}

/// [JobDetailInitial] class is used JobDetail State Initial
class JobDetailInitial extends JobDetailState {}

/// [JobDetailLoading] class is used JobDetail State Loading
class JobDetailLoading extends JobDetailState {}

/// [JobDetailResponse] class is used JobDetail State Response
class JobDetailResponse extends JobDetailState {
  final ModelMyJob mModelJobDetail;

  const JobDetailResponse({required this.mModelJobDetail});

  @override
  List<Object> get props => [mModelJobDetail];
}

/// [JobDetailFailure] class is used JobDetail State Failure
class JobDetailFailure extends JobDetailState {
  final String mError;

  const JobDetailFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
