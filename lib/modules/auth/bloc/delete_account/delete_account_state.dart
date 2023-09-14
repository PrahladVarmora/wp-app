part of 'delete_account_bloc.dart';

/// [DeleteAccountState] abstract class is used DeleteAccount State
abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object> get props => [];
}

/// [DeleteAccountInitial] class is used DeleteAccount State Initial
class DeleteAccountInitial extends DeleteAccountState {}

/// [DeleteAccountLoading] class is used DeleteAccount State Loading
class DeleteAccountLoading extends DeleteAccountState {}

/// [DeleteAccountResponse] class is used DeleteAccount State Response
class DeleteAccountResponse extends DeleteAccountState {
  final ModelCommonAuthorised modelCommonAuthorised;

  const DeleteAccountResponse({required this.modelCommonAuthorised});

  @override
  List<Object> get props => [];
}

/// [DeleteAccountFailure] class is used DeleteAccount State Failure
class DeleteAccountFailure extends DeleteAccountState {
  final String mError;

  const DeleteAccountFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
