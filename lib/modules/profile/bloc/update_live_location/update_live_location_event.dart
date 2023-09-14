part of 'update_live_location_bloc.dart';

/// [UpdateLiveLocationEvent] abstract class is used Event of bloc.
abstract class UpdateLiveLocationEvent extends Equatable {
  const UpdateLiveLocationEvent();

  @override
  List<Object> get props => [];
}

/// [UpdateLiveLocationUser] abstract class is used Update Profile
class UpdateLiveLocationUser extends UpdateLiveLocationEvent {
  const UpdateLiveLocationUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
