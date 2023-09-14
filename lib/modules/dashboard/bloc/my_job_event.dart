part of 'my_job_bloc.dart';

/// [MyJobEvent] abstract class is used Event of bloc.
abstract class MyJobEvent extends Equatable {
  const MyJobEvent();

  @override
  List<Object> get props => [];
}

/// [MyJobMyJob] abstract class is used Auth Event
class MyJobMyJob extends MyJobEvent {
  const MyJobMyJob({
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

/// [NewJobMyJob] abstract class is used Auth Event
class NewJobMyJob extends MyJobEvent {
  const NewJobMyJob({
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
