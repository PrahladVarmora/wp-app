part of 'job_types_filter_bloc.dart';

/// [JobTypesFilterEvent] abstract class is used Event of bloc.
abstract class JobTypesFilterEvent extends Equatable {
  const JobTypesFilterEvent();

  @override
  List<Object> get props => [];
}

/// [JobTypesFilterList] abstract class is used JobTypesFilter Event
class JobTypesFilterList extends JobTypesFilterEvent {
  final String url;

  const JobTypesFilterList({required this.url});

  @override
  List<Object> get props => [];
}
