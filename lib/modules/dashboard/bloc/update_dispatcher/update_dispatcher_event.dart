part of 'update_dispatcher_bloc.dart';

/// [UpdateDispatcherEvent] abstract class is used Event of bloc.
abstract class UpdateDispatcherEvent extends Equatable {
  const UpdateDispatcherEvent();

  @override
  List<Object> get props => [];
}

/// [UpdateDispatcherUpdateDispatcher] abstract class is used Sub State Event
class UpdateDispatcher extends UpdateDispatcherEvent {
  const UpdateDispatcher({
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
