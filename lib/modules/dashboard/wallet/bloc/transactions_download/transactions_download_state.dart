part of 'transactions_download_bloc.dart';

/// [TransactionsDownloadState] abstract class is used RequestMoney State
abstract class TransactionsDownloadState extends Equatable {
  const TransactionsDownloadState();

  @override
  List<Object> get props => [];
}

/// [TransactionsDownloadInitial] class is used TransactionsDownload State Initial
class TransactionsDownloadInitial extends TransactionsDownloadState {}

/// [TransactionsDownloadLoading] class is used TransactionsDownload State Loading
class TransactionsDownloadLoading extends TransactionsDownloadState {}

/// [TransactionsDownloadResponse] class is used TransactionsDownload State Response
class TransactionsDownloadResponse extends TransactionsDownloadState {
  const TransactionsDownloadResponse();

  @override
  List<Object> get props => [];
}

/// [TransactionsDownloadFailure] class is used RequestMoney State Failure
class TransactionsDownloadFailure extends TransactionsDownloadState {
  final String mError;

  const TransactionsDownloadFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
