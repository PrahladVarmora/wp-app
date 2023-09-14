part of 'sources_categories_bloc.dart';

/// [SourcesCategoriesState] abstract class is used SourcesCategories State
abstract class SourcesCategoriesState extends Equatable {
  const SourcesCategoriesState();

  @override
  List<Object> get props => [];
}

/// [SourcesCategoriesInitial] class is used SourcesCategories State Initial
class SourcesCategoriesInitial extends SourcesCategoriesState {}

/// [SourcesCategoriesLoading] class is used SourcesCategories State Loading
class SourcesCategoriesLoading extends SourcesCategoriesState {}

/// [SourcesCategoriesResponse] class is used SourcesCategories State Response
class SourcesCategoriesResponse extends SourcesCategoriesState {
  final ModelSourcesCategories mSourcesCategories;

  const SourcesCategoriesResponse({required this.mSourcesCategories});

  @override
  List<Object> get props => [mSourcesCategories];
}

/// [SourcesCategoriesFailure] class is used SourcesCategories State Failure
class SourcesCategoriesFailure extends SourcesCategoriesState {
  final String mError;

  const SourcesCategoriesFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
