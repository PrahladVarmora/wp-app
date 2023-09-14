part of 'optimize_route_bloc.dart';

/// [OptimizeRouteState] abstract class is used OptimizeRoute State
abstract class OptimizeRouteState extends Equatable {
  const OptimizeRouteState();

  @override
  List<Object> get props => [];
}

/// [OptimizeRouteInitial] class is used OptimizeRoute State Initial
class OptimizeRouteInitial extends OptimizeRouteState {}

/// [OptimizeRouteLoading] class is used OptimizeRoute State Loading
class OptimizeRouteLoading extends OptimizeRouteState {}

/// [OptimizeRouteResponse] class is used OptimizeRoute State Response
class OptimizeRouteResponse extends OptimizeRouteState {
  final ModelCommonAuthorised mModelOptimizeRoute;

  const OptimizeRouteResponse({required this.mModelOptimizeRoute});

  @override
  List<Object> get props => [mModelOptimizeRoute];
}

/// [OptimizeRouteFailure] class is used OptimizeRoute State Failure
class OptimizeRouteFailure extends OptimizeRouteState {
  final String mError;

  const OptimizeRouteFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
