part of 'get_companies_bloc.dart';

/// [GetCompaniesEvent] abstract class is used Event of bloc.
/// It's an abstract class that extends Equatable and has a single property called props
abstract class GetCompaniesEvent extends Equatable {
  const GetCompaniesEvent();

  @override
  List<Object> get props => [];
}

/// [GetCompaniesUser] abstract class is used GetCompanies Event
class GetCompaniesUser extends GetCompaniesEvent {
  const GetCompaniesUser({required this.url});

  final String url;

  @override
  List<Object> get props => [
        url,
      ];
}
