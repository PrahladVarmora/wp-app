part of 'add_companies_bloc.dart';

/// [AddCompaniesEvent] abstract class is used Event of bloc.
abstract class AddCompaniesEvent extends Equatable {
  const AddCompaniesEvent();

  @override
  List<Object> get props => [];
}

/// [AddCompaniesUser] abstract class is used Update Profile
class AddCompaniesUser extends AddCompaniesEvent {
  const AddCompaniesUser({
    required this.url,
    required this.body,
    required this.mCompany,
  });

  final String url;
  final String mCompany;
  final Map<String, dynamic> body;

  @override
  List<Object> get props => [url, body];
}
