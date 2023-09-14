part of 'notifications_list_bloc.dart';

/// [NotificationsListState] abstract class is used NotificationsList State
abstract class NotificationsListState extends Equatable {
  const NotificationsListState();

  @override
  List<Object> get props => [];
}

/// [NotificationsListInitial] class is used NotificationsList State Initial
class NotificationsListInitial extends NotificationsListState {}

/// [NotificationsListLoading] class is used NotificationsList State Loading
class NotificationsListLoading extends NotificationsListState {}

/// [NotificationsListResponse] class is used NotificationsList State Response
class NotificationsListResponse extends NotificationsListState {
  final ModelNotificationsList mModelNotificationsList;

  const NotificationsListResponse({required this.mModelNotificationsList});

  @override
  List<Object> get props => [mModelNotificationsList];
}

/// [NotificationsListFailure] class is used NotificationsList State Failure
class NotificationsListFailure extends NotificationsListState {
  final String mError;

  const NotificationsListFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
