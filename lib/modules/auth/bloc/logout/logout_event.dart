part of 'logout_bloc.dart';

/// [LogoutEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class LogoutEvent extends Equatable {
  const LogoutEvent();

  @override
  List<Object> get props => [];
}

/// [LogoutUser] abstract class is used Logout Event
class LogoutUser extends LogoutEvent {
  const LogoutUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
