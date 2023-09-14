part of 'verify_access_token_bloc.dart';

/// [VerifyAccessTokenEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class VerifyAccessTokenEvent extends Equatable {
  const VerifyAccessTokenEvent();

  @override
  List<Object> get props => [];
}

/// [VerifyAccessTokenUser] abstract class is used VerifyAccessToken Event
class VerifyAccessTokenUser extends VerifyAccessTokenEvent {
  const VerifyAccessTokenUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
