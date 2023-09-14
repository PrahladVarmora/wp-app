part of 'tag_notes_bloc.dart';

/// [TagNotesState] abstract class is used TagNotes State
abstract class TagNotesState extends Equatable {
  const TagNotesState();

  @override
  List<Object> get props => [];
}

/// [TagNotesInitial] class is used TagNotes State Initial
class TagNotesInitial extends TagNotesState {}

/// [TagNotesLoading] class is used TagNotes State Loading
class TagNotesLoading extends TagNotesState {}

/// [TagNotesResponse] class is used TagNotes State Response
class TagNotesResponse extends TagNotesState {
  final List<TagsNotes> tagsNotes;

  const TagNotesResponse({required this.tagsNotes});

  @override
  List<Object> get props => [tagsNotes];
}

/// [TagNotesFailure] class is used TagNotes State Failure
class TagNotesFailure extends TagNotesState {
  final String mError;

  const TagNotesFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
