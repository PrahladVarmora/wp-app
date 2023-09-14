part of 'otp_send_bloc.dart';

/// [OtpSendEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class OtpSendEvent extends Equatable {
  const OtpSendEvent();

  @override
  List<Object> get props => [];
}

/// [OtpSendUser] abstract class is used OtpSend Event
class OtpSendUser extends OtpSendEvent {
  const OtpSendUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}

class ResendOtpSendUser extends OtpSendEvent {
  const ResendOtpSendUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}

/// [OtpSendUserContact] abstract class is used OtpSend Event
class OtpSendUserContact extends OtpSendEvent {
  const OtpSendUserContact({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
