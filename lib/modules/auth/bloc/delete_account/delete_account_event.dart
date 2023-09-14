part of 'delete_account_bloc.dart';

/// [DeleteAccountEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object> get props => [];
}

/// [DeleteAccountUser] abstract class is used DeleteAccount Event
class DeleteAccountUser extends DeleteAccountEvent {
  const DeleteAccountUser({required this.url});

  final String url;

  @override
  List<Object> get props => [
        url,
      ];
}
