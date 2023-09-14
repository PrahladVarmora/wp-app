part of 'update_dispatcher_bloc.dart';

/// [UpdateDispatcherState] abstract class is used UpdateDispatcher State
abstract class UpdateDispatcherState extends Equatable {
  const UpdateDispatcherState();

  @override
  List<Object> get props => [];
}

/// [UpdateDispatcherInitial] class is used UpdateDispatcher State Initial
class UpdateDispatcherInitial extends UpdateDispatcherState {}

/// [UpdateDispatcherLoading] class is used UpdateDispatcher State Loading
class UpdateDispatcherLoading extends UpdateDispatcherState {}

/// [UpdateDispatcherResponse] class is used UpdateDispatcher State Response
class UpdateDispatcherResponse extends UpdateDispatcherState {
  final ModelCommonAuthorised mModelUpdateDispatcher;

  const UpdateDispatcherResponse({required this.mModelUpdateDispatcher});

  @override
  List<Object> get props => [mModelUpdateDispatcher];
}

/// [UpdateDispatcherFailure] class is used UpdateDispatcher State Failure
class UpdateDispatcherFailure extends UpdateDispatcherState {
  final String mError;

  const UpdateDispatcherFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
