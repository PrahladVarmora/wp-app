part of 'notifications_clear_list_bloc.dart';

/// [NotificationsClearListState] abstract class is used NotificationsClearList State
abstract class NotificationsClearListState extends Equatable {
  const NotificationsClearListState();

  @override
  List<Object> get props => [];
}

/// [NotificationsClearListInitial] class is used NotificationsClearList State Initial
class NotificationsClearListInitial extends NotificationsClearListState {}

/// [NotificationsClearListLoading] class is used NotificationsClearList State Loading
class NotificationsClearListLoading extends NotificationsClearListState {
  const NotificationsClearListLoading();

  @override
  List<Object> get props => [];
}

/// [NotificationsClearListResponse] class is used NotificationsClearList State Response
class NotificationsClearListResponse extends NotificationsClearListState {
  const NotificationsClearListResponse();

  @override
  List<Object> get props => [];
}

/// [NotificationsClearListFailure] class is used NotificationsClearList State Failure
class NotificationsClearListFailure extends NotificationsClearListState {
  final String mError;

  const NotificationsClearListFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
