part of 'make_model_year_bloc.dart';

/// [MakeModelYearEvent] abstract class is used Event of bloc.
abstract class MakeModelYearEvent extends Equatable {
  const MakeModelYearEvent();

  @override
  List<Object> get props => [];
}

/// [GetMakeModelYearList] abstract class is used MakeModelYear Event
class GetMakeModelYearList extends MakeModelYearEvent {
  final String url;

  const GetMakeModelYearList({required this.url});

  @override
  List<Object> get props => [url];
}
