part of 'collect_invoice_bloc.dart';

/// [CollectInvoiceState] abstract class is used CollectInvoice State
abstract class CollectInvoiceState extends Equatable {
  const CollectInvoiceState();

  @override
  List<Object> get props => [];
}

/// [CollectInvoiceInitial] class is used CollectInvoice State Initial
class CollectInvoiceInitial extends CollectInvoiceState {}

/// [CollectInvoiceLoading] class is used CollectInvoice State Loading
class CollectInvoiceLoading extends CollectInvoiceState {}

/// [CollectInvoiceResponse] class is used CollectInvoice State Response
class CollectInvoiceResponse extends CollectInvoiceState {
  final ModelCollectPayment mModelCollectInvoice;

  const CollectInvoiceResponse({required this.mModelCollectInvoice});

  @override
  List<Object> get props => [mModelCollectInvoice];
}

/// [CollectInvoiceFailure] class is used CollectInvoice State Failure
class CollectInvoiceFailure extends CollectInvoiceState {
  final String mError;

  const CollectInvoiceFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
