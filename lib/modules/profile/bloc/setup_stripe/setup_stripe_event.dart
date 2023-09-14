part of 'setup_stripe_bloc.dart';

/// [SetupStripeEvent] abstract class is used Event of bloc.
abstract class SetupStripeEvent extends Equatable {
  const SetupStripeEvent();

  @override
  List<Object> get props => [];
}

/// [SetupStripeUser] abstract class is used Update Profile
class SetupStripeUser extends SetupStripeEvent {
  SetupStripeUser();

  final String url = AppUrls.apiSetupStripe;

  @override
  List<Object> get props => [url];
}
