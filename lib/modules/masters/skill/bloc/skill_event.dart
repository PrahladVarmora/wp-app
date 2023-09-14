part of 'skill_bloc.dart';

/// [SkillEvent] abstract class is used Event of bloc.
abstract class SkillEvent extends Equatable {
  const SkillEvent();

  @override
  List<Object> get props => [];
}

/// [Skill] abstract class is used Skill Event
class Skill extends SkillEvent {
  final String url;

  const Skill({required this.url});

  @override
  List<Object> get props => [];
}
