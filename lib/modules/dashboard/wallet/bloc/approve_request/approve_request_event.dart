part of 'approve_request_bloc.dart';

/// [ApproveRequestEvent] abstract class is used Event of bloc.
abstract class ApproveRequestEvent extends Equatable {
  const ApproveRequestEvent();

  @override
  List<Object> get props => [];
}

/// [RequestMoneyRequestMoney] abstract class is used Sub State Event
class ApproveRequest extends ApproveRequestEvent {
  const ApproveRequest({
    required this.url,
    required this.body,
  });

  final String url;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [
        url,
        body,
      ];
}
