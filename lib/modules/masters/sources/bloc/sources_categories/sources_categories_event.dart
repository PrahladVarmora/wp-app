part of 'sources_categories_bloc.dart';

/// [SourcesCategoriesEvent] abstract class is used Event of bloc.
abstract class SourcesCategoriesEvent extends Equatable {
  const SourcesCategoriesEvent();

  @override
  List<Object> get props => [];
}

/// [GetSourcesCategoriesList] abstract class is used Sources Event
class GetSourcesCategoriesList extends SourcesCategoriesEvent {
  final String url;
  final Map<String, dynamic> mBody;

  const GetSourcesCategoriesList({required this.url, required this.mBody});

  @override
  List<Object> get props => [];
}
