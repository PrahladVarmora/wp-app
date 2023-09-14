part of 'forgot_password_bloc.dart';

/// [ForgotPasswordEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

/// [ForgotPasswordUser] abstract class is used ForgotPassword Event
class ForgotPasswordUser extends ForgotPasswordEvent {
  const ForgotPasswordUser(
      {required this.url, required this.body, this.isResend = false});

  final String url;
  final Map<String, dynamic> body;
  final bool isResend;

  @override
  List<Object> get props => [url, body];
}
