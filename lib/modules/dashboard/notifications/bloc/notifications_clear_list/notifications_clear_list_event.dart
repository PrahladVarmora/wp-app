part of 'notifications_clear_list_bloc.dart';

/// [NotificationsClearListEvent] abstract class is used Event of bloc.
abstract class NotificationsClearListEvent extends Equatable {
  const NotificationsClearListEvent();

  @override
  List<Object> get props => [];
}

/// [NotificationsClearListNotificationsClearList] abstract class is used Sub State Event
class NotificationsClearList extends NotificationsClearListEvent {
  const NotificationsClearList({
    required this.url,
  });

  final String url;

  @override
  List<Object> get props => [url];
}
