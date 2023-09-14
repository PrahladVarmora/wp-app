part of 'optimize_route_bloc.dart';

/// [OptimizeRouteEvent] abstract class is used Event of bloc.
abstract class OptimizeRouteEvent extends Equatable {
  const OptimizeRouteEvent();

  @override
  List<Object> get props => [];
}

class SaveOptimizedRoute extends OptimizeRouteEvent {
  const SaveOptimizedRoute({
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
