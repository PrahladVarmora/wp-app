part of 'forgot_pass_verify_otp_bloc.dart';

/// [ForgotPassVerifyOtpEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class ForgotPassVerifyOtpEvent extends Equatable {
  const ForgotPassVerifyOtpEvent();

  @override
  List<Object> get props => [];
}

/// [ForgotPassVerifyOtpUser] abstract class is used ForgotPassVerifyOtp Event
class ForgotPassVerifyOtpUser extends ForgotPassVerifyOtpEvent {
  const ForgotPassVerifyOtpUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
