import 'package:equatable/equatable.dart';

class MessageDetailEvent extends Equatable {
  const MessageDetailEvent();

  @override
  List<Object?> get props => [];
}

class MessageGetChatDetail extends MessageDetailEvent {
  final String url;
  final Map<String, dynamic> body;
  final bool showLoader;

  const MessageGetChatDetail(
      {required this.url, required this.body, required this.showLoader});

  @override
  List<Object?> get props => [url, body];
}
