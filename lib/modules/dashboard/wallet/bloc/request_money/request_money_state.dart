part of 'request_money_bloc.dart';

/// [SendAndRequestMoneyState] abstract class is used RequestMoney State
abstract class SendAndRequestMoneyState extends Equatable {
  const SendAndRequestMoneyState();

  @override
  List<Object> get props => [];
}

/// [SendAndRequestMoneyInitial] class is used SendAndRequestMoney State Initial
class SendAndRequestMoneyInitial extends SendAndRequestMoneyState {}

/// [SendAndRequestMoneyLoading] class is used SendAndRequestMoney State Loading
class SendAndRequestMoneyLoading extends SendAndRequestMoneyState {}

/// [SendAndRequestMoneyResponse] class is used SendAndRequestMoney State Response
class SendAndRequestMoneyResponse extends SendAndRequestMoneyState {
  final ModelCommonAuthorised mModelRequestMoney;

  const SendAndRequestMoneyResponse({required this.mModelRequestMoney});

  @override
  List<Object> get props => [mModelRequestMoney];
}

/// [SendAndRequestMoneyFailure] class is used RequestMoney State Failure
class SendAndRequestMoneyFailure extends SendAndRequestMoneyState {
  final String mError;

  const SendAndRequestMoneyFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
