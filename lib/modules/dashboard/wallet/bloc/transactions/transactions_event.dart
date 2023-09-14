part of 'transactions_bloc.dart';

/// [TransactionsEvent] abstract class is used Event of bloc.
abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object> get props => [];
}

/// [RequestMoneyRequestMoney] abstract class is used Sub State Event
class Transactions extends TransactionsEvent {
  const Transactions({
    required this.url,
    required this.body,
  });

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [
        url,
        body,
      ];
}
