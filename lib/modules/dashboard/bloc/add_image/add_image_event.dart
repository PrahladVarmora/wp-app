part of 'add_image_bloc.dart';

/// [AddImageEvent] abstract class is used Event of bloc.
abstract class AddImageEvent extends Equatable {
  const AddImageEvent();

  @override
  List<Object> get props => [];
}

/// [AddImageAddImage] abstract class is used Sub State Event
class AddImage extends AddImageEvent {
  const AddImage({
    required this.url,
    required this.body,
    required this.mFileList,
    required this.mJobData,
  });

  final String url;
  final Map<String, dynamic> body;
  final List<File> mFileList;
  final JobData mJobData;

  @override
  List<Object> get props => [
        url,
        body,
        mFileList,
      ];
}
