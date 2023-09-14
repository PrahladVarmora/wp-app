part of 'update_availability_bloc.dart';

/// [UpdateAvailabilityEvent] abstract class is used Event of bloc.
abstract class UpdateAvailabilityEvent extends Equatable {
  const UpdateAvailabilityEvent();

  @override
  List<Object> get props => [];
}

/// [UpdateAvailabilityUser] abstract class is used Update Profile
class UpdateAvailabilityUser extends UpdateAvailabilityEvent {
  const UpdateAvailabilityUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
