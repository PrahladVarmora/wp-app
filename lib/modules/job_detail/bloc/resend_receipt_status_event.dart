import 'package:equatable/equatable.dart';

class ResendReceiptStatusEvent extends Equatable {
  const ResendReceiptStatusEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ResendReceipt extends ResendReceiptStatusEvent {
  final String url;
  final Map<String, dynamic> body;

  const ResendReceipt({required this.url, required this.body});

  @override
  List<Object?> get props => [url, body];
}
