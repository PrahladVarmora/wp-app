part of 'skills_bloc.dart';

/// [AuthState] abstract class is used Auth State
abstract class SkillState extends Equatable {
  const SkillState();

  @override
  List<Object> get props => [];
}

/// [AuthInitial] class is used Auth State Initial
class SkillsInitial extends SkillState {}

/// [AuthLoading] class is used Auth State Loading
class SkillsLoading extends SkillState {}

/// [SkillsGetDataResponse] class is used Auth State Response
class SkillsGetDataResponse extends SkillState {
  final ModelGetSkills modelGetSkill;

  const SkillsGetDataResponse({required this.modelGetSkill});

  @override
  List<Object> get props => [modelGetSkill];
}

/// [SkillsGetDataResponse] class is used Auth State Response
class SkillsSetDataResponse extends SkillState {
  final ModelCommonAuthorised commonResponse;

  const SkillsSetDataResponse({required this.commonResponse});

  @override
  List<Object> get props => [commonResponse];
}

/// [SkillsFailure] class is used Auth State Failure
class SkillsFailure extends SkillState {
  final String mError;

  const SkillsFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
