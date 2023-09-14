part of 'change_password_bloc.dart';

/// [ChangePasswordEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

/// [ChangePasswordUser] abstract class is used ChangePassword Event
class ChangePasswordUser extends ChangePasswordEvent {
  const ChangePasswordUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
