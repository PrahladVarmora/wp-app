part of 'add_companies_bloc.dart';

/// [AddCompaniesState] abstract class is used Update Profile State
abstract class AddCompaniesState extends Equatable {
  const AddCompaniesState();

  @override
  List<Object> get props => [];
}

/// [AddCompaniesInitial] class is used Update Profile State Initial
class AddCompaniesInitial extends AddCompaniesState {}

/// [AddCompaniesLoading] class is used Update Profile State Loading
class AddCompaniesLoading extends AddCompaniesState {}

/// [AddCompaniesResponse] class is used Update Profile Response
class AddCompaniesResponse extends AddCompaniesState {
  final ModelCommonAuthorised mAddCompanies;
  final String mCompany;

  const AddCompaniesResponse(
      {required this.mAddCompanies, required this.mCompany});

  @override
  List<Object> get props => [mAddCompanies];
}

/// [AddCompaniesFailure] class is used AddCompanies State Failure
class AddCompaniesFailure extends AddCompaniesState {
  final String mError;

  const AddCompaniesFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
