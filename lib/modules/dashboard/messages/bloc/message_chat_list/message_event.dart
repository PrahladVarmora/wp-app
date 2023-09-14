import 'package:equatable/equatable.dart';

class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class MessageGetChatList extends MessageEvent {
  final String url;
  final Map<String, dynamic> body;

  const MessageGetChatList({required this.url, required this.body});

  @override
  List<Object?> get props => [url, body];
}
