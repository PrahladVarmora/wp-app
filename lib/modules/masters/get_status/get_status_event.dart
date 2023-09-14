part of 'get_status_bloc.dart';

/// [GetStatusEvent] abstract class is used Event of bloc.
abstract class GetStatusEvent extends Equatable {
  const GetStatusEvent();

  @override
  List<Object> get props => [];
}

/// [GetStatusList] abstract class is used GetStatus Event
class GetStatusList extends GetStatusEvent {
  final String url;
  final bool isUpdateDispatchStatus;

  const GetStatusList({
    required this.url,
    this.isUpdateDispatchStatus = false,
  });

  @override
  List<Object> get props => [];
}
