part of 'notifications_list_bloc.dart';

/// [NotificationsListEvent] abstract class is used Event of bloc.
abstract class NotificationsListEvent extends Equatable {
  const NotificationsListEvent();

  @override
  List<Object> get props => [];
}

/// [GetNotificationsList] abstract class is used Auth Event
class GetNotificationsList extends NotificationsListEvent {
  const GetNotificationsList({
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
