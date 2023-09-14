part of 'collect_invoice_bloc.dart';

/// [CollectInvoiceEvent] abstract class is used Event of bloc.
abstract class CollectInvoiceEvent extends Equatable {
  const CollectInvoiceEvent();

  @override
  List<Object> get props => [];
}

/// [CollectInvoiceCollectInvoice] abstract class is used Sub State Event
class CollectInvoice extends CollectInvoiceEvent {
  const CollectInvoice({
    required this.url,
    required this.body,
    required this.mJobData,
    this.isPartial = false,
  });

  final String url;
  final Map<String, dynamic> body;
  final JobData mJobData;
  final bool isPartial;

  @override
  List<Object> get props => [
        url,
        body,
      ];
}
