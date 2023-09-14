part of 'notifications_update_status_bloc.dart';

/// [NotificationsUpdateStatusEvent] abstract class is used Event of bloc.
abstract class NotificationsUpdateStatusEvent extends Equatable {
  const NotificationsUpdateStatusEvent();

  @override
  List<Object> get props => [];
}

/// [NotificationsUpdateStatusNotificationsUpdateStatus] abstract class is used Sub State Event
class NotificationsUpdateStatus extends NotificationsUpdateStatusEvent {
  const NotificationsUpdateStatus({
    required this.url,
    required this.body,
    required this.mModalNotificationData,
  });

  final String url;
  final Map<String, dynamic> body;
  final ModalNotificationData mModalNotificationData;

  @override
  List<Object> get props => [
        url,
        body,
        mModalNotificationData,
      ];
}
