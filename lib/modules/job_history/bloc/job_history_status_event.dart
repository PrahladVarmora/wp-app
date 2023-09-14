import 'package:equatable/equatable.dart';

class JobHistoryStatusEvent extends Equatable {
  const JobHistoryStatusEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetJobHistory extends JobHistoryStatusEvent {
  final String url;
  final Map<String, dynamic> body;

  const GetJobHistory({required this.url, required this.body});

  @override
  List<Object?> get props => [url, body];
}
