part of 'change_password_bloc.dart';

/// [ChangePasswordState] abstract class is used ChangePassword State
abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

/// [ChangePasswordInitial] class is used ChangePassword State Initial
class ChangePasswordInitial extends ChangePasswordState {}

/// [ChangePasswordLoading] class is used ChangePassword State Loading
class ChangePasswordLoading extends ChangePasswordState {}

/// [ChangePasswordResponse] class is used ChangePassword State Response
class ChangePasswordResponse extends ChangePasswordState {
  // final ModelUser mModelUser;

  const ChangePasswordResponse();

  @override
  List<Object> get props => [];
}

/// [ChangePasswordFailure] class is used ChangePassword State Failure
class ChangePasswordFailure extends ChangePasswordState {
  final String mError;

  const ChangePasswordFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
