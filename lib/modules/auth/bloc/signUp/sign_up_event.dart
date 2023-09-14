part of 'sign_up_bloc.dart';

/// [SignUpEvent] abstract class is used Event of bloc.
abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

/// [SignUpSignUp] abstract class is used Auth Event
class SignUpSignUp extends SignUpEvent {
  const SignUpSignUp({
    required this.url,
    this.imageFile,
    required this.body,
  });

  final String url;
  final File? imageFile;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [
        url,
        body,
      ];
}
