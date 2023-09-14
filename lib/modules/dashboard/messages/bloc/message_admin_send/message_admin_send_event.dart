import 'dart:io';

import 'package:equatable/equatable.dart';

class MessageAdminSendEvent extends Equatable {
  const MessageAdminSendEvent();

  @override
  List<Object?> get props => [];
}

class MessageAdminSendRequest extends MessageAdminSendEvent {
  final String url;
  final Map<String, dynamic> body;
  final File? imageFile;

  const MessageAdminSendRequest(
      {required this.url, required this.body, required this.imageFile});

  @override
  List<Object?> get props => [url, body, imageFile];
}
