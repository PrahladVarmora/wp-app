part of 'job_types_bloc.dart';

/// [JobTypesEvent] abstract class is used Event of bloc.
abstract class JobTypesEvent extends Equatable {
  const JobTypesEvent();

  @override
  List<Object> get props => [];
}

/// [GetJobTypesList] abstract class is used JobTypes Event
class GetJobTypesList extends JobTypesEvent {
  final String url;
  final Map<String, dynamic> mBody;

  const GetJobTypesList({required this.url, required this.mBody});

  @override
  List<Object> get props => [AutofillHints.url, mBody];
}
