part of 'otp_send_bloc.dart';

/// [OtpSendState] abstract class is used OtpSend State
abstract class OtpSendState extends Equatable {
  const OtpSendState();

  @override
  List<Object> get props => [];
}

/// [OtpSendInitial] class is used OtpSend State Initial
class OtpSendInitial extends OtpSendState {}

/// [OtpSendLoading] class is used OtpSend State Loading
class OtpSendLoading extends OtpSendState {}

/// [OtpSendResponse] class is used OtpSend State Response
class OtpSendResponse extends OtpSendState {
  final ModelCommonAuthorised mModelOtpSend;

  const OtpSendResponse({required this.mModelOtpSend});

  @override
  List<Object> get props => [ModelCommonAuthorised];
}

/// [OtpSendFailure] class is used OtpSend State Failure
class OtpSendFailure extends OtpSendState {
  final String mError;

  const OtpSendFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
