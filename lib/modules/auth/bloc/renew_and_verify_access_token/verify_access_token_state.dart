part of 'verify_access_token_bloc.dart';

/// [VerifyAccessTokenState] abstract class is used VerifyAccessToken State
abstract class VerifyAccessTokenState extends Equatable {
  const VerifyAccessTokenState();

  @override
  List<Object> get props => [];
}

/// [VerifyAccessTokenInitial] class is used VerifyAccessToken State Initial
class VerifyAccessTokenInitial extends VerifyAccessTokenState {}

/// [VerifyAccessTokenLoading] class is used VerifyAccessToken State Loading
class VerifyAccessTokenLoading extends VerifyAccessTokenState {}

/// [VerifyAccessTokenResponse] class is used VerifyAccessToken State Response
class VerifyAccessTokenResponse extends VerifyAccessTokenState {
  final ModelCommonAuthorised mVerifyAccessToken;

  const VerifyAccessTokenResponse({required this.mVerifyAccessToken});

  @override
  List<Object> get props => [mVerifyAccessToken];
}

/// [VerifyAccessTokenFailure] class is used VerifyAccessToken State Failure
class VerifyAccessTokenFailure extends VerifyAccessTokenState {
  final String mError;

  const VerifyAccessTokenFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
