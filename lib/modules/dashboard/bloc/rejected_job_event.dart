part of 'rejected_job_bloc.dart';

/// [RejectedJobEvent] abstract class is used Event of bloc.
abstract class RejectedJobEvent extends Equatable {
  const RejectedJobEvent();

  @override
  List<Object> get props => [];
}

/// [RejectedJobRejectedJob] abstract class is used Sub State Event
class RejectedJobList extends RejectedJobEvent {
  const RejectedJobList({
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
