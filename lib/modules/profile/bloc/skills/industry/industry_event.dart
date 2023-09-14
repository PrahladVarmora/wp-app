part of 'industry_bloc.dart';

/// [IndustryEvent] abstract class is used Event of bloc.
abstract class IndustryEvent extends Equatable {
  const IndustryEvent();

  @override
  List<Object> get props => [];
}

/// [GetIndustryList] abstract class is used Industry Event
class GetIndustryList extends IndustryEvent {
  final String url;

  const GetIndustryList({required this.url});

  @override
  List<Object> get props => [];
}
