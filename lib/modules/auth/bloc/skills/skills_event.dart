part of 'skills_bloc.dart';

/// [SkillsEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class SkillsEvent extends Equatable {
  const SkillsEvent();

  @override
  List<Object> get props => [];
}

/// [AuthUser] abstract class is used Auth Event
class SkillsGetData extends SkillsEvent {
  final String url;

  const SkillsGetData({required this.url});

  @override
  List<Object> get props => [url];
}

class SkillsSetData extends SkillsEvent {
  const SkillsSetData({required this.url, required this.body});

  final String url;
  final List<IndustryRequest> body;

  @override
  List<Object> get props => [url, body];
}
