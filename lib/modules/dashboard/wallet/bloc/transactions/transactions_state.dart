part of 'transactions_bloc.dart';

/// [TransactionsState] abstract class is used RequestMoney State
abstract class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object> get props => [];
}

/// [TransactionsInitial] class is used Transactions State Initial
class TransactionsInitial extends TransactionsState {}

/// [TransactionsLoading] class is used Transactions State Loading
class TransactionsLoading extends TransactionsState {}

/// [TransactionsResponse] class is used Transactions State Response
class TransactionsResponse extends TransactionsState {
  final ModelTransactionsHistory mModelTransactionsHistory;

  const TransactionsResponse({required this.mModelTransactionsHistory});

  @override
  List<Object> get props => [mModelTransactionsHistory];
}

/// [TransactionsFailure] class is used RequestMoney State Failure
class TransactionsFailure extends TransactionsState {
  final String mError;

  const TransactionsFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
