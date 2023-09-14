part of 'category_types_bloc.dart';

/// [CategoryTypesEvent] abstract class is used Event of bloc.
abstract class CategoryTypesEvent extends Equatable {
  const CategoryTypesEvent();

  @override
  List<Object> get props => [];
}

/// [GetCategoryTypesList] abstract class is used Sources Event
class GetCategoryTypesList extends CategoryTypesEvent {
  final String url;
  final Map<String, dynamic> mBody;

  const GetCategoryTypesList({required this.url, required this.mBody});

  @override
  List<Object> get props => [];
}
