part of 'get_profile_bloc.dart';

/// [GetProfileEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class GetProfileEvent extends Equatable {
  const GetProfileEvent();

  @override
  List<Object> get props => [];
}

/// [GetProfileUser] abstract class is used GetProfile Event
class GetProfileUser extends GetProfileEvent {
  const GetProfileUser({required this.url});

  final String url;

  @override
  List<Object> get props => [url];
}
