part of 'add_job_bloc.dart';

/// [AddJobEvent] abstract class is used Event of bloc.
abstract class AddJobEvent extends Equatable {
  const AddJobEvent();

  @override
  List<Object> get props => [];
}

/// [AddJobAddJob] abstract class is used Sub State Event
class AddJob extends AddJobEvent {
  const AddJob({
    required this.url,
    required this.body,
  });

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [
        url,
        body,
      ];
}
