part of 'call_customer_bloc.dart';

/// [CallCustomerState] abstract class is used CallCustomer State
abstract class CallCustomerState extends Equatable {
  const CallCustomerState();

  @override
  List<Object> get props => [];
}

/// [CallCustomerInitial] class is used CallCustomer State Initial
class CallCustomerInitial extends CallCustomerState {}

/// [CallCustomerLoading] class is used CallCustomer State Loading
class CallCustomerLoading extends CallCustomerState {}

/// [CallCustomerResponse] class is used CallCustomer State Response
class CallCustomerResponse extends CallCustomerState {
  final ModelCommonAuthorised mModelCallCustomer;

  const CallCustomerResponse({required this.mModelCallCustomer});

  @override
  List<Object> get props => [mModelCallCustomer];
}

/// [CallCustomerFailure] class is used CallCustomer State Failure
class CallCustomerFailure extends CallCustomerState {
  final String mError;

  const CallCustomerFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
