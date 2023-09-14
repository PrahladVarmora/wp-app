import 'dart:io';

import 'package:equatable/equatable.dart';

class MessageSendEvent extends Equatable {
  const MessageSendEvent();

  @override
  List<Object?> get props => [];
}

class MessageSendRequest extends MessageSendEvent {
  final String url;
  final Map<String, dynamic> body;
  final File? imageFile;

  const MessageSendRequest(
      {required this.url, required this.body, required this.imageFile});

  @override
  List<Object?> get props => [url, body, imageFile];
}
