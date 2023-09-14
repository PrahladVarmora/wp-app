part of 'get_companies_bloc.dart';

/// [GetCompaniesState] abstract class is used GetCompanies State
abstract class GetCompaniesState extends Equatable {
  const GetCompaniesState();

  @override
  List<Object> get props => [];
}

/// [GetCompaniesInitial] class is used GetCompanies State Initial
class GetCompaniesInitial extends GetCompaniesState {}

/// [GetCompaniesLoading] class is used GetCompanies State Loading
class GetCompaniesLoading extends GetCompaniesState {}

/// [GetCompaniesResponse] class is used GetCompanies State Response
class GetCompaniesResponse extends GetCompaniesState {
  final Companies modelGetCompanies;

  const GetCompaniesResponse({required this.modelGetCompanies});

  @override
  List<Object> get props => [modelGetCompanies];
}

/// [GetCompaniesFailure] class is used GetCompanies State Failure
class GetCompaniesFailure extends GetCompaniesState {
  final String mError;

  const GetCompaniesFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
