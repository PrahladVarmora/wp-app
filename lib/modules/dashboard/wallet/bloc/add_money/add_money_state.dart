part of 'add_money_bloc.dart';

/// [AddMoneyState] abstract class is used RequestMoney State
abstract class AddMoneyState extends Equatable {
  const AddMoneyState();

  @override
  List<Object> get props => [];
}

/// [AddMoneyInitial] class is used AddMoney State Initial
class AddMoneyInitial extends AddMoneyState {}

/// [AddMoneyLoading] class is used AddMoney State Loading
class AddMoneyLoading extends AddMoneyState {}

/// [AddMoneyResponse] class is used AddMoney State Response
class AddMoneyResponse extends AddMoneyState {
  final ModelCommonAuthorised mModelRequestMoney;

  const AddMoneyResponse({required this.mModelRequestMoney});

  @override
  List<Object> get props => [mModelRequestMoney];
}

/// [AddMoneyFailure] class is used RequestMoney State Failure
class AddMoneyFailure extends AddMoneyState {
  final String mError;

  const AddMoneyFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
