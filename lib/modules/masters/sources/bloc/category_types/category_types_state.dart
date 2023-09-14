part of 'category_types_bloc.dart';

/// [CategoryTypesState] abstract class is used CategoryTypes State
abstract class CategoryTypesState extends Equatable {
  const CategoryTypesState();

  @override
  List<Object> get props => [];
}

/// [CategoryTypesInitial] class is used CategoryTypes State Initial
class CategoryTypesInitial extends CategoryTypesState {}

/// [CategoryTypesLoading] class is used CategoryTypes State Loading
class CategoryTypesLoading extends CategoryTypesState {}

/// [CategoryTypesResponse] class is used CategoryTypes State Response
class CategoryTypesResponse extends CategoryTypesState {
  final ModelSourcesCategoryTypes mCategoryTypes;

  const CategoryTypesResponse({required this.mCategoryTypes});

  @override
  List<Object> get props => [mCategoryTypes];
}

/// [CategoryTypesFailure] class is used CategoryTypes State Failure
class CategoryTypesFailure extends CategoryTypesState {
  final String mError;

  const CategoryTypesFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
