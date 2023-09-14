part of 'reset_password_bloc.dart';

/// [ResetPasswordState] abstract class is used ResetPassword State
abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

/// [ResetPasswordInitial] class is used ResetPassword State Initial
class ResetPasswordInitial extends ResetPasswordState {}

/// [ResetPasswordLoading] class is used ResetPassword State Loading
class ResetPasswordLoading extends ResetPasswordState {}

/// [ResetPasswordResponse] class is used ResetPassword State Response
class ResetPasswordResponse extends ResetPasswordState {
  final ModelCommonAuthorised mModelCommonAuthorised;

  const ResetPasswordResponse({required this.mModelCommonAuthorised});

  @override
  List<Object> get props => [mModelCommonAuthorised];
}

/// [ResetPasswordFailure] class is used ResetPassword State Failure
class ResetPasswordFailure extends ResetPasswordState {
  final String mError;

  const ResetPasswordFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
