part of 'get_profile_bloc.dart';

/// [GetProfileState] abstract class is used GetProfile State
abstract class GetProfileState extends Equatable {
  const GetProfileState();

  @override
  List<Object> get props => [];
}

/// [GetProfileInitial] class is used GetProfile State Initial
class GetProfileInitial extends GetProfileState {}

/// [GetProfileLoading] class is used GetProfile State Loading
class GetProfileLoading extends GetProfileState {}

/// [GetProfileResponse] class is used GetProfile State Response
class GetProfileResponse extends GetProfileState {
  final ModelGetProfile modelGetProfile;

  const GetProfileResponse({required this.modelGetProfile});

  @override
  List<Object> get props => [modelGetProfile];
}

/// [GetProfileFailure] class is used GetProfile State Failure
class GetProfileFailure extends GetProfileState {
  final String mError;

  const GetProfileFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
