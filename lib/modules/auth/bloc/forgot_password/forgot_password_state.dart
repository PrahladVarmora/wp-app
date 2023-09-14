part of 'forgot_password_bloc.dart';

/// [ForgotPasswordState] abstract class is used ForgotPassword State
abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

/// [ForgotPasswordInitial] class is used ForgotPassword State Initial
class ForgotPasswordInitial extends ForgotPasswordState {}

/// [ForgotPasswordLoading] class is used ForgotPassword State Loading
class ForgotPasswordLoading extends ForgotPasswordState {}

/// [ForgotPasswordResponse] class is used ForgotPassword State Response
class ForgotPasswordResponse extends ForgotPasswordState {
  final ModelUser mModelForgotPassword;

  const ForgotPasswordResponse({required this.mModelForgotPassword});

  @override
  List<Object> get props => [ModelForgotPassword];
}

/// [ForgotPasswordFailure] class is used ForgotPassword State Failure
class ForgotPasswordFailure extends ForgotPasswordState {
  final String mError;

  const ForgotPasswordFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
