part of 'notifications_update_status_bloc.dart';

/// [NotificationsUpdateStatusState] abstract class is used NotificationsUpdateStatus State
abstract class NotificationsUpdateStatusState extends Equatable {
  const NotificationsUpdateStatusState();

  @override
  List<Object> get props => [];
}

/// [NotificationsUpdateStatusInitial] class is used NotificationsUpdateStatus State Initial
class NotificationsUpdateStatusInitial extends NotificationsUpdateStatusState {}

/// [NotificationsUpdateStatusLoading] class is used NotificationsUpdateStatus State Loading
class NotificationsUpdateStatusLoading extends NotificationsUpdateStatusState {
  final String id;

  const NotificationsUpdateStatusLoading({required this.id});

  @override
  List<Object> get props => [id];
}

/// [NotificationsUpdateStatusResponse] class is used NotificationsUpdateStatus State Response
class NotificationsUpdateStatusResponse extends NotificationsUpdateStatusState {
  final ModalNotificationData mModalNotificationData;

  const NotificationsUpdateStatusResponse(
      {required this.mModalNotificationData});

  @override
  List<Object> get props => [mModalNotificationData];
}

/// [NotificationsUpdateStatusFailure] class is used NotificationsUpdateStatus State Failure
class NotificationsUpdateStatusFailure extends NotificationsUpdateStatusState {
  final String mError;

  const NotificationsUpdateStatusFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
