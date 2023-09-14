part of 'add_invoice_bloc.dart';

/// [AddInvoiceEvent] abstract class is used Event of bloc.
abstract class AddInvoiceEvent extends Equatable {
  const AddInvoiceEvent();

  @override
  List<Object> get props => [];
}

/// [AddInvoiceAddInvoice] abstract class is used Sub State Event
class AddInvoice extends AddInvoiceEvent {
  const AddInvoice({
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

class UpdateInvoice extends AddInvoiceEvent {
  const UpdateInvoice({
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
