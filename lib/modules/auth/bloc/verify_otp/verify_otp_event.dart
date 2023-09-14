part of 'verify_otp_bloc.dart';

/// [VerifyOtpEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();

  @override
  List<Object> get props => [];
}

/// [VerifyOtpUser] abstract class is used VerifyOtp Event
class VerifyOtpUser extends VerifyOtpEvent {
  const VerifyOtpUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}

class VerifyOtpUserSMS extends VerifyOtpEvent {
  const VerifyOtpUserSMS({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
