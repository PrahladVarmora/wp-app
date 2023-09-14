part of 'transactions_download_bloc.dart';

/// [TransactionsDownloadEvent] abstract class is used Event of bloc.
abstract class TransactionsDownloadEvent extends Equatable {
  const TransactionsDownloadEvent();

  @override
  List<Object> get props => [];
}

/// [RequestMoneyRequestMoney] abstract class is used Sub State Event
class TransactionsDownload extends TransactionsDownloadEvent {
  const TransactionsDownload({
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
