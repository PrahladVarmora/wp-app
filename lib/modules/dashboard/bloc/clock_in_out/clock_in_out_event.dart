part of 'clock_in_out_bloc.dart';

/// [ClockInOutEvent] abstract class is used Event of bloc.
abstract class ClockInOutEvent extends Equatable {
  const ClockInOutEvent();

  @override
  List<Object> get props => [];
}

/// [ClockInOutClockInOut] abstract class is used Sub State Event
class ClockInOut extends ClockInOutEvent {
  const ClockInOut({
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

/// The class "ClockInStatus" is a subclass of "ClockInOutEvent" in Dart programming
/// language.
class ClockInStatus extends ClockInOutEvent {
  const ClockInStatus({
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
