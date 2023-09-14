part of 'skill_bloc.dart';

/// [SkillState] abstract class is used Skill State
abstract class SkillState extends Equatable {
  const SkillState();

  @override
  List<Object> get props => [];
}

/// [SkillInitial] class is used Skill State Initial
class SkillInitial extends SkillState {}

/// [SkillLoading] class is used Skill State Loading
class SkillLoading extends SkillState {}

/// [SkillResponse] class is used Skill State Response
class SkillResponse extends SkillState {
  final ModelSkill mSkill;

  const SkillResponse({required this.mSkill});

  @override
  List<Object> get props => [mSkill];
}

/// [SkillFailure] class is used Skill State Failure
class SkillFailure extends SkillState {
  final String mError;

  const SkillFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
