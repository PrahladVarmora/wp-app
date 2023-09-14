part of 'update_profile_bloc.dart';

/// [UpdateProfileState] abstract class is used Update Profile State
abstract class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object> get props => [];
}

/// [UpdateProfileInitial] class is used Update Profile State Initial
class UpdateProfileInitial extends UpdateProfileState {}

/// [UpdateProfileLoading] class is used Update Profile State Loading
class UpdateProfileLoading extends UpdateProfileState {}

/// [UpdateProfileResponse] class is used Update Profile Response
class UpdateProfileResponse extends UpdateProfileState {
  final ModelCommonAuthorised mUpdateProfile;

  const UpdateProfileResponse({required this.mUpdateProfile});

  @override
  List<Object> get props => [mUpdateProfile];
}

/// [UpdateProfilePictureResponse] class is used Update Profile State Response
class UpdateProfilePictureResponse extends UpdateProfileState {
  final ModelCommonAuthorised mUpdateProfilePicture;

  const UpdateProfilePictureResponse({required this.mUpdateProfilePicture});

  @override
  List<Object> get props => [mUpdateProfilePicture];
}

/// [DrivingLicenceUpdateResponse] class is used Update Driving Licence
class DrivingLicenceUpdateResponse extends UpdateProfileState {
  final ModelCommonAuthorised mDrivingLicenceUpdate;

  const DrivingLicenceUpdateResponse({required this.mDrivingLicenceUpdate});

  @override
  List<Object> get props => [mDrivingLicenceUpdate];
}

/// [UpdateProfileFailure] class is used UpdateProfile State Failure
class UpdateProfileFailure extends UpdateProfileState {
  final String mError;

  const UpdateProfileFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
