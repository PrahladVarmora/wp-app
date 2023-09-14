part of 'send_invoice_bloc.dart';

/// [SendInvoiceState] abstract class is used SendInvoice State
abstract class SendInvoiceState extends Equatable {
  const SendInvoiceState();

  @override
  List<Object> get props => [];
}

/// [SendInvoiceInitial] class is used SendInvoice State Initial
class SendInvoiceInitial extends SendInvoiceState {}

/// [SendInvoiceLoading] class is used SendInvoice State Loading
class SendInvoiceLoading extends SendInvoiceState {}

/// [SendInvoiceResponse] class is used SendInvoice State Response
class SendInvoiceResponse extends SendInvoiceState {
  final ModelCommonAuthorised mModelSendInvoice;

  const SendInvoiceResponse({required this.mModelSendInvoice});

  @override
  List<Object> get props => [mModelSendInvoice];
}

/// [SendInvoiceFailure] class is used SendInvoice State Failure
class SendInvoiceFailure extends SendInvoiceState {
  final String mError;

  const SendInvoiceFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
