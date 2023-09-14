part of 'sources_bloc.dart';

/// [SourcesProvidersEvent] abstract class is used Event of bloc.
abstract class SourcesProvidersEvent extends Equatable {
  const SourcesProvidersEvent();

  @override
  List<Object> get props => [];
}

/// [GetSourcesList] abstract class is used Sources Event
class GetSourcesList extends SourcesProvidersEvent {
  final String url;

  const GetSourcesList({required this.url});

  @override
  List<Object> get props => [];
}
