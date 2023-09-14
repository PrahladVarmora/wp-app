part of 'type_subtypes_bloc.dart';

/// [TypeSubtypesState] abstract class is used TypeSubtypes State
abstract class TypeSubtypesState extends Equatable {
  const TypeSubtypesState();

  @override
  List<Object> get props => [];
}

/// [TypeSubtypesInitial] class is used TypeSubtypes State Initial
class TypeSubtypesInitial extends TypeSubtypesState {}

/// [TypeSubtypesLoading] class is used TypeSubtypes State Loading
class TypeSubtypesLoading extends TypeSubtypesState {}

/// [TypeSubtypesResponse] class is used TypeSubtypes State Response
class TypeSubtypesResponse extends TypeSubtypesState {
  final ModelSourcesSubtypes mTypeSubtypes;
  final int index;

  const TypeSubtypesResponse(
      {required this.mTypeSubtypes, required this.index});

  @override
  List<Object> get props => [mTypeSubtypes];
}

/// [TypeSubtypesFailure] class is used TypeSubtypes State Failure
class TypeSubtypesFailure extends TypeSubtypesState {
  final String mError;

  const TypeSubtypesFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
