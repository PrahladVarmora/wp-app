part of 'add_invoice_bloc.dart';

/// [AddInvoiceState] abstract class is used AddInvoice State
abstract class AddInvoiceState extends Equatable {
  const AddInvoiceState();

  @override
  List<Object> get props => [];
}

/// [AddInvoiceInitial] class is used AddInvoice State Initial
class AddInvoiceInitial extends AddInvoiceState {}

/// [AddInvoiceLoading] class is used AddInvoice State Loading
class AddInvoiceLoading extends AddInvoiceState {}

/// [AddInvoiceResponse] class is used AddInvoice State Response
class AddInvoiceResponse extends AddInvoiceState {
  final ModelCommonAuthorised mModelAddInvoice;

  const AddInvoiceResponse({required this.mModelAddInvoice});

  @override
  List<Object> get props => [mModelAddInvoice];
}

/// [AddInvoiceFailure] class is used AddInvoice State Failure
class AddInvoiceFailure extends AddInvoiceState {
  final String mError;

  const AddInvoiceFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
