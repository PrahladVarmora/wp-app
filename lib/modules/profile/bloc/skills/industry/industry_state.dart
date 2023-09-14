part of 'industry_bloc.dart';

/// [IndustryState] abstract class is used Industry State
abstract class IndustryState extends Equatable {
  const IndustryState();

  @override
  List<Object> get props => [];
}

/// [IndustryInitial] class is used Industry State Initial
class IndustryInitial extends IndustryState {}

/// [IndustryLoading] class is used Industry State Loading
class IndustryLoading extends IndustryState {}

/// [IndustryResponse] class is used Industry State Response
class IndustryResponse extends IndustryState {
  final ModelIndustry mIndustry;

  const IndustryResponse({required this.mIndustry});

  @override
  List<Object> get props => [mIndustry];
}

/// [IndustryFailure] class is used Industry State Failure
class IndustryFailure extends IndustryState {
  final String mError;

  const IndustryFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
