import 'package:equatable/equatable.dart';

class MessageAdminDetailEvent extends Equatable {
  const MessageAdminDetailEvent();

  @override
  List<Object?> get props => [];
}

class MessageAdminGetChatDetail extends MessageAdminDetailEvent {
  final String url;
  final Map<String, dynamic> body;

  const MessageAdminGetChatDetail({required this.url, required this.body});

  @override
  List<Object?> get props => [url, body];
}
