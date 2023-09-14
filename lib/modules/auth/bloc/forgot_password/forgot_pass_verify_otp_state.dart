part of 'forgot_pass_verify_otp_bloc.dart';

/// [ForgotPassVerifyOtpState] abstract class is used ForgotPassVerifyOtp State
abstract class ForgotPassVerifyOtpState extends Equatable {
  const ForgotPassVerifyOtpState();

  @override
  List<Object> get props => [];
}

/// [ForgotPassVerifyOtpInitial] class is used ForgotPassVerifyOtp State Initial
class ForgotPassVerifyOtpInitial extends ForgotPassVerifyOtpState {}

/// [ForgotPassVerifyOtpLoading] class is used ForgotPassVerifyOtp State Loading
class ForgotPassVerifyOtpLoading extends ForgotPassVerifyOtpState {}

/// [ForgotPassVerifyOtpResponse] class is used ForgotPassVerifyOtp State Response
class ForgotPassVerifyOtpResponse extends ForgotPassVerifyOtpState {
  const ForgotPassVerifyOtpResponse();
}

/// [ForgotPassVerifyOtpFailure] class is used ForgotPassVerifyOtp State Failure
class ForgotPassVerifyOtpFailure extends ForgotPassVerifyOtpState {
  final String mError;

  const ForgotPassVerifyOtpFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
