part of 'make_model_year_bloc.dart';

/// [MakeModelYearState] abstract class is used MakeModelYear State
abstract class MakeModelYearState extends Equatable {
  const MakeModelYearState();

  @override
  List<Object> get props => [];
}

/// [MakeModelYearInitial] class is used MakeModelYear State Initial
class MakeModelYearInitial extends MakeModelYearState {}

/// [MakeModelYearLoading] class is used MakeModelYear State Loading
class MakeModelYearLoading extends MakeModelYearState {}

/// [MakeModelYearResponse] class is used MakeModelYear State Response
class MakeModelYearResponse extends MakeModelYearState {
  final ModelCarInfo mMakeModelYear;

  const MakeModelYearResponse({required this.mMakeModelYear});

  @override
  List<Object> get props => [mMakeModelYear];
}

/// [MakeModelYearFailure] class is used MakeModelYear State Failure
class MakeModelYearFailure extends MakeModelYearState {
  final String mError;

  const MakeModelYearFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
