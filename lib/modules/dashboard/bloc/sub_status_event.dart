part of 'sub_status_bloc.dart';

/// [SubStatusEvent] abstract class is used Event of bloc.
abstract class SubStatusEvent extends Equatable {
  const SubStatusEvent();

  @override
  List<Object> get props => [];
}

/// [SubStatusSubStatus] abstract class is used Sub State Event
class SubStatusList extends SubStatusEvent {
  const SubStatusList({
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
