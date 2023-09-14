part of 'add_money_bloc.dart';

/// [AddMoneyEvent] abstract class is used Event of bloc.
abstract class AddMoneyEvent extends Equatable {
  const AddMoneyEvent();

  @override
  List<Object> get props => [];
}

/// [RequestMoneyRequestMoney] abstract class is used Sub State Event
class AddMoney extends AddMoneyEvent {
  const AddMoney({
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
