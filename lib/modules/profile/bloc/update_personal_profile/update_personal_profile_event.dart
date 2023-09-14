part of 'update_personal_profile_bloc.dart';

/// [UpdatePersonalProfileEvent] abstract class is used Event of bloc.
abstract class UpdatePersonalProfileEvent extends Equatable {
  const UpdatePersonalProfileEvent();

  @override
  List<Object> get props => [];
}

/// [UpdatePersonalProfileUser] abstract class is used Update Profile
class UpdatePersonalProfileUser extends UpdatePersonalProfileEvent {
  const UpdatePersonalProfileUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
