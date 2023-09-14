part of 'verify_otp_bloc.dart';

/// [VerifyOtpState] abstract class is used VerifyOtp State
abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object> get props => [];
}

/// [VerifyOtpInitial] class is used VerifyOtp State Initial
class VerifyOtpInitial extends VerifyOtpState {}

/// [VerifyOtpLoading] class is used VerifyOtp State Loading
class VerifyOtpLoading extends VerifyOtpState {}

/// [VerifyOtpResponse] class is used VerifyOtp State Response
class VerifyOtpResponse extends VerifyOtpState {
  final ModelCommonAuthorised mModelVerifyOtp;

  const VerifyOtpResponse({required this.mModelVerifyOtp});

  @override
  List<Object> get props => [ModelCommonAuthorised];
}

/// [VerifyOtpFailure] class is used VerifyOtp State Failure
class VerifyOtpFailure extends VerifyOtpState {
  final String mError;

  const VerifyOtpFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
