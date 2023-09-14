part of 'job_detail_bloc.dart';

/// [JobDetailEvent] abstract class is used Event of bloc.
abstract class JobDetailEvent extends Equatable {
  const JobDetailEvent();

  @override
  List<Object> get props => [];
}

/// [JobDetailJobDetail] abstract class is used Auth Event
class JobDetail extends JobDetailEvent {
  const JobDetail({
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
