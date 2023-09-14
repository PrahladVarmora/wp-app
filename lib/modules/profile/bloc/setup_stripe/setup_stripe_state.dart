part of 'setup_stripe_bloc.dart';

/// [SetupStripeState] abstract class is used Update Profile State
abstract class SetupStripeState extends Equatable {
  const SetupStripeState();

  @override
  List<Object> get props => [];
}

/// [SetupStripeInitial] class is used Update Profile State Initial
class SetupStripeInitial extends SetupStripeState {}

/// [SetupStripeLoading] class is used Update Profile State Loading
class SetupStripeLoading extends SetupStripeState {}

/// [SetupStripeResponse] class is used Update Profile Response
class SetupStripeResponse extends SetupStripeState {
  const SetupStripeResponse();

  @override
  List<Object> get props => [];
}

/// [SetupStripeFailure] class is used SetupStripe State Failure
class SetupStripeFailure extends SetupStripeState {
  final String mError;

  const SetupStripeFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
