part of 'job_types_filter_bloc.dart';

/// [JobTypesFilterState] abstract class is used JobTypesFilter State
abstract class JobTypesFilterState extends Equatable {
  const JobTypesFilterState();

  @override
  List<Object> get props => [];
}

/// [JobTypesFilterInitial] class is used JobTypesFilter State Initial
class JobTypesFilterInitial extends JobTypesFilterState {}

/// [JobTypesFilterLoading] class is used JobTypesFilter State Loading
class JobTypesFilterLoading extends JobTypesFilterState {}

/// [JobTypesFilterResponse] class is used JobTypesFilter State Response
class JobTypesFilterResponse extends JobTypesFilterState {
  final ModelJobTypesHistoryFilter mJobTypesFilter;

  const JobTypesFilterResponse({required this.mJobTypesFilter});

  @override
  List<Object> get props => [mJobTypesFilter];
}

/// [JobTypesFilterFailure] class is used JobTypesFilter State Failure
class JobTypesFilterFailure extends JobTypesFilterState {
  final String mError;

  const JobTypesFilterFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
