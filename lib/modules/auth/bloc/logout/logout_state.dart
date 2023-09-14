part of 'logout_bloc.dart';

/// [LogoutState] abstract class is used Logout State
abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

/// [LogoutInitial] class is used Logout State Initial
class LogoutInitial extends LogoutState {}

/// [LogoutLoading] class is used Logout State Loading
class LogoutLoading extends LogoutState {}

/// [LogoutResponse] class is used Logout State Response
class LogoutResponse extends LogoutState {
  final ModelCommonAuthorised modelCommonAuthorised;

  const LogoutResponse({required this.modelCommonAuthorised});

  @override
  List<Object> get props => [];
}

/// [LogoutFailure] class is used Logout State Failure
class LogoutFailure extends LogoutState {
  final String mError;

  const LogoutFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
