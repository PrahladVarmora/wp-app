part of 'update_live_location_bloc.dart';

/// [UpdateLiveLocationState] abstract class is used Update Profile State
abstract class UpdateLiveLocationState extends Equatable {
  const UpdateLiveLocationState();

  @override
  List<Object> get props => [];
}

/// [UpdateLiveLocationInitial] class is used Update Profile State Initial
class UpdateLiveLocationInitial extends UpdateLiveLocationState {}

/// [UpdateLiveLocationLoading] class is used Update Profile State Loading
class UpdateLiveLocationLoading extends UpdateLiveLocationState {}

/// [UpdateLiveLocationResponse] class is used Update Profile Response
class UpdateLiveLocationResponse extends UpdateLiveLocationState {
  const UpdateLiveLocationResponse();

  @override
  List<Object> get props => [];
}

/// [UpdateLiveLocationFailure] class is used UpdateLiveLocation State Failure
class UpdateLiveLocationFailure extends UpdateLiveLocationState {
  final String mError;

  const UpdateLiveLocationFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
