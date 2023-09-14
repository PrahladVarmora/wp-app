part of 'google_optimize_route_bloc.dart';

/// [GoogleOptimizeRouteState] abstract class is used GoogleOptimizeRoute State
abstract class GoogleOptimizeRouteState extends Equatable {
  const GoogleOptimizeRouteState();

  @override
  List<Object> get props => [];
}

/// [GoogleOptimizeRouteInitial] class is used GoogleOptimizeRoute State Initial
class GoogleOptimizeRouteInitial extends GoogleOptimizeRouteState {}

/// [GoogleOptimizeRouteLoading] class is used GoogleOptimizeRoute State Loading
class GoogleOptimizeRouteLoading extends GoogleOptimizeRouteState {}

/// [NewJobLoading] class is used NewJob State Loading
class NewJobLoading extends GoogleOptimizeRouteState {}

/// [GoogleOptimizeRouteResponse] class is used GoogleOptimizeRoute State Response
class GoogleOptimizeRouteResponse extends GoogleOptimizeRouteState {
  final ModelGoogleOptimizeRoute mModelGoogleOptimizeRoute;

  const GoogleOptimizeRouteResponse({required this.mModelGoogleOptimizeRoute});

  @override
  List<Object> get props => [mModelGoogleOptimizeRoute];
}

/// [GoogleOptimizeRouteFailure] class is used GoogleOptimizeRoute State Failure
class GoogleOptimizeRouteFailure extends GoogleOptimizeRouteState {
  final String mError;

  const GoogleOptimizeRouteFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
