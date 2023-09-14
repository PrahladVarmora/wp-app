part of 'update_availability_bloc.dart';

/// [UpdateAvailabilityState] abstract class is used Update Profile State
abstract class UpdateAvailabilityState extends Equatable {
  const UpdateAvailabilityState();

  @override
  List<Object> get props => [];
}

/// [UpdateAvailabilityInitial] class is used Update Profile State Initial
class UpdateAvailabilityInitial extends UpdateAvailabilityState {}

/// [UpdateAvailabilityLoading] class is used Update Profile State Loading
class UpdateAvailabilityLoading extends UpdateAvailabilityState {}

/// [UpdateAvailabilityResponse] class is used Update Profile Response
class UpdateAvailabilityResponse extends UpdateAvailabilityState {
  final ModelCommonAuthorised mUpdateAvailability;

  const UpdateAvailabilityResponse({required this.mUpdateAvailability});

  @override
  List<Object> get props => [mUpdateAvailability];
}

/// [UpdateAvailabilityFailure] class is used UpdateAvailability State Failure
class UpdateAvailabilityFailure extends UpdateAvailabilityState {
  final String mError;

  const UpdateAvailabilityFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
