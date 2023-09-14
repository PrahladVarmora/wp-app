part of 'update_job_bloc.dart';

/// [UpdateJobEvent] abstract class is used Event of bloc.
abstract class UpdateJobEvent extends Equatable {
  const UpdateJobEvent();

  @override
  List<Object> get props => [];
}

/// [UpdateJobAccept] abstract class is used UpdateJob Event
class UpdateJobAccept extends UpdateJobEvent {
  const UpdateJobAccept({
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

/// [UpdateJobAcceptFromList] abstract class is used UpdateJob Event
class UpdateJobAcceptFromList extends UpdateJobEvent {
  const UpdateJobAcceptFromList({
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
