part of 'change_priority_bloc.dart';

/// [ChangePriorityEvent] abstract class is used Event of bloc.
abstract class ChangePriorityEvent extends Equatable {
  const ChangePriorityEvent();

  @override
  List<Object> get props => [];
}

/// [ChangePriorityChangePriority] abstract class is used Sub State Event
class ChangePriority extends ChangePriorityEvent {
  const ChangePriority({
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
