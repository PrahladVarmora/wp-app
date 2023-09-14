part of 'add_image_bloc.dart';

/// [AddImageState] abstract class is used AddImage State
abstract class AddImageState extends Equatable {
  const AddImageState();

  @override
  List<Object> get props => [];
}

/// [AddImageInitial] class is used AddImage State Initial
class AddImageInitial extends AddImageState {}

/// [AddImageLoading] class is used AddImage State Loading
class AddImageLoading extends AddImageState {}

/// [AddImageResponse] class is used AddImage State Response
class AddImageResponse extends AddImageState {
  final ModelCommonAuthorised mModelAddImage;

  const AddImageResponse({required this.mModelAddImage});

  @override
  List<Object> get props => [mModelAddImage];
}

/// [AddImageFailure] class is used AddImage State Failure
class AddImageFailure extends AddImageState {
  final String mError;

  const AddImageFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
