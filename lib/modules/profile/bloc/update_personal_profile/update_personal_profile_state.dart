part of 'update_personal_profile_bloc.dart';

/// [UpdatePersonalProfileState] abstract class is used Update Profile State
abstract class UpdatePersonalProfileState extends Equatable {
  const UpdatePersonalProfileState();

  @override
  List<Object> get props => [];
}

/// [UpdatePersonalProfileInitial] class is used Update Profile State Initial
class UpdatePersonalProfileInitial extends UpdatePersonalProfileState {}

/// [UpdatePersonalProfileLoading] class is used Update Profile State Loading
class UpdatePersonalProfileLoading extends UpdatePersonalProfileState {}

/// [UpdatePersonalProfileResponse] class is used Update Profile Response
class UpdatePersonalProfileResponse extends UpdatePersonalProfileState {
  const UpdatePersonalProfileResponse();

  @override
  List<Object> get props => [];
}

/// [UpdatePersonalProfileFailure] class is used UpdatePersonalProfile State Failure
class UpdatePersonalProfileFailure extends UpdatePersonalProfileState {
  final String mError;

  const UpdatePersonalProfileFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
