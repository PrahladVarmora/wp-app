part of 'call_customer_bloc.dart';

/// [CallCustomerEvent] abstract class is used Event of bloc.
abstract class CallCustomerEvent extends Equatable {
  const CallCustomerEvent();

  @override
  List<Object> get props => [];
}

/// [CallCustomerCallCustomer] abstract class is used Sub State Event
class CallCustomer extends CallCustomerEvent {
  const CallCustomer({
    required this.url,
    required this.body,
    this.isSendMessage = false,
    required this.phoneNumber,
  });

  final String url;
  final bool isSendMessage;
  final String phoneNumber;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [
        url,
        isSendMessage,
        body,
      ];
}
