part of 'renew_access_token_bloc.dart';

/// [RenewAccessTokenState] abstract class is used RenewAccessToken State
abstract class RenewAccessTokenState extends Equatable {
  const RenewAccessTokenState();

  @override
  List<Object> get props => [];
}

/// [RenewAccessTokenInitial] class is used RenewAccessToken State Initial
class RenewAccessTokenInitial extends RenewAccessTokenState {}

/// [RenewAccessTokenLoading] class is used RenewAccessToken State Loading
class RenewAccessTokenLoading extends RenewAccessTokenState {}

/// [RenewAccessTokenResponse] class is used RenewAccessToken State Response
class RenewAccessTokenResponse extends RenewAccessTokenState {
  final ModelUser mRenewAccessToken;

  const RenewAccessTokenResponse({required this.mRenewAccessToken});

  @override
  List<Object> get props => [mRenewAccessToken];
}

/// [RenewAccessTokenFailure] class is used RenewAccessToken State Failure
class RenewAccessTokenFailure extends RenewAccessTokenState {
  final String mError;

  const RenewAccessTokenFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
