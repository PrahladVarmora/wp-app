part of 'tag_notes_bloc.dart';

/// [TagNotesEvent] abstract class is used Event of bloc.
abstract class TagNotesEvent extends Equatable {
  const TagNotesEvent();

  @override
  List<Object> get props => [];
}

/// [TagNotesTagNotes] abstract class is used Sub State Event
class TagNotesList extends TagNotesEvent {
  const TagNotesList({
    required this.url,
  });

  final String url;

  @override
  List<Object> get props => [
        url,
      ];
}
