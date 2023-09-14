part of 'google_optimize_route_bloc.dart';

/// [GoogleOptimizeRouteEvent] abstract class is used Event of bloc.
abstract class GoogleOptimizeRouteEvent extends Equatable {
  const GoogleOptimizeRouteEvent();

  @override
  List<Object> get props => [];
}

/// [GoogleOptimizeRouteGoogleOptimizeRoute] abstract class is used Auth Event
class GoogleOptimizeRouteGoogleOptimizeRoute extends GoogleOptimizeRouteEvent {
  const GoogleOptimizeRouteGoogleOptimizeRoute({
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
