part of 'job_types_bloc.dart';

/// [JobTypesState] abstract class is used JobTypes State
abstract class JobTypesState extends Equatable {
  const JobTypesState();

  @override
  List<Object> get props => [];
}

/// [JobTypesInitial] class is used JobTypes State Initial
class JobTypesInitial extends JobTypesState {}

/// [JobTypesLoading] class is used JobTypes State Loading
class JobTypesLoading extends JobTypesState {}

/// [JobTypesResponse] class is used JobTypes State Response
class JobTypesResponse extends JobTypesState {
  final ModelJobTypes mJobTypes;

  const JobTypesResponse({required this.mJobTypes});

  @override
  List<Object> get props => [mJobTypes];
}

/// [JobTypesFailure] class is used JobTypes State Failure
class JobTypesFailure extends JobTypesState {
  final String mError;

  const JobTypesFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
