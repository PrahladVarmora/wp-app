part of 'request_money_bloc.dart';

/// [SendAndRequestMoneyEvent] abstract class is used Event of bloc.
abstract class SendAndRequestMoneyEvent extends Equatable {
  const SendAndRequestMoneyEvent();

  @override
  List<Object> get props => [];
}

/// [RequestMoneyRequestMoney] abstract class is used Sub State Event
class SendAndRequestMoney extends SendAndRequestMoneyEvent {
  const SendAndRequestMoney({
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
