part of 'type_subtypes_bloc.dart';

/// [TypeSubtypesEvent] abstract class is used Event of bloc.
abstract class TypeSubtypesEvent extends Equatable {
  const TypeSubtypesEvent();

  @override
  List<Object> get props => [];
}

/// [GetTypeSubtypesList] abstract class is used Sources Event
class GetTypeSubtypesList extends TypeSubtypesEvent {
  final String url;
  final int index;
  final Map<String, dynamic> mBody;

  const GetTypeSubtypesList(
      {required this.url, required this.mBody, required this.index});

  @override
  List<Object> get props => [];
}
