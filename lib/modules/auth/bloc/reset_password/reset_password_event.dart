part of 'reset_password_bloc.dart';

/// [ResetPasswordEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

/// [ResetPasswordUser] abstract class is used ResetPassword Event
class ResetPasswordUser extends ResetPasswordEvent {
  const ResetPasswordUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
