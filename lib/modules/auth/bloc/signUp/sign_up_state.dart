part of 'sign_up_bloc.dart';

/// [SignUpState] abstract class is used Auth State
abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

/// [SignUpInitial] class is used Auth State Initial
class SignUpInitial extends SignUpState {}

/// [SignUpLoading] class is used Auth State Loading
class SignUpLoading extends SignUpState {}

/// [SignUpResponse] class is used Auth State Response
class SignUpResponse extends SignUpState {
  final ModelUser mModelUser;

  const SignUpResponse({required this.mModelUser});

  @override
  List<Object> get props => [mModelUser];
}

/// [SignUpFailure] class is used Auth State Failure
class SignUpFailure extends SignUpState {
  final String mError;

  const SignUpFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
