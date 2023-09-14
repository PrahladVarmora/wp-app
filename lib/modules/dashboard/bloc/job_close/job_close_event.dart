part of 'job_close_bloc.dart';

/// [JobCloseEvent] abstract class is used Event of bloc.
abstract class JobCloseEvent extends Equatable {
  const JobCloseEvent();

  @override
  List<Object> get props => [];
}

/// [JobCloseJobClose] abstract class is used Sub State Event
class JobClose extends JobCloseEvent {
  const JobClose({
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
