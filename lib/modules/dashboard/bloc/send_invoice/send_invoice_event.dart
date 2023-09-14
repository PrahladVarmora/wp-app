part of 'send_invoice_bloc.dart';

/// [SendInvoiceEvent] abstract class is used Event of bloc.
abstract class SendInvoiceEvent extends Equatable {
  const SendInvoiceEvent();

  @override
  List<Object> get props => [];
}

/// [SendInvoiceSendInvoice] abstract class is used Sub State Event
class SendInvoice extends SendInvoiceEvent {
  const SendInvoice({
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
