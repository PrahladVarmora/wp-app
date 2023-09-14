part of 'update_profile_bloc.dart';

/// [UpdateProfileEvent] abstract class is used Event of bloc.
abstract class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object> get props => [];
}

/// [UpdateProfilePicture] abstract class is used Update Profile Picture Event
class PictureUpdateProfile extends UpdateProfileEvent {
  const PictureUpdateProfile({
    required this.url,
    this.imageFile,
  });

  final String url;
  final File? imageFile;

  @override
  List<Object> get props => [
        url,
      ];
}

/// [DrivingLicenceUpdateProfile] abstract class is used Update Driving Licence
class DrivingLicenceUpdateProfile extends UpdateProfileEvent {
  const DrivingLicenceUpdateProfile({
    required this.url,
    required this.frontImageFile,
    required this.backImageFile,
    this.isFromEdit = false,
  });

  final String url;
  final File frontImageFile;
  final File backImageFile;
  final bool isFromEdit;

  @override
  List<Object> get props => [
        url,
      ];
}

/// [UpdateProfileUser] abstract class is used Update Profile
class UpdateProfileUser extends UpdateProfileEvent {
  const UpdateProfileUser({required this.url, required this.body});

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
