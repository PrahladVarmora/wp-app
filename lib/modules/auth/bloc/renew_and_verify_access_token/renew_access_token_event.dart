part of 'renew_access_token_bloc.dart';

/// [RenewAccessTokenEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class RenewAccessTokenEvent extends Equatable {
  const RenewAccessTokenEvent();

  @override
  List<Object> get props => [];
}

/// [RenewAccessTokenUser] abstract class is used RenewAccessToken Event
class RenewAccessTokenUser extends RenewAccessTokenEvent {
  const RenewAccessTokenUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
