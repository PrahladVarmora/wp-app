part of 'sources_bloc.dart';

/// [SourcesProvidersState] abstract class is used SourcesProviders State
abstract class SourcesProvidersState extends Equatable {
  const SourcesProvidersState();

  @override
  List<Object> get props => [];
}

/// [SourcesProvidersInitial] class is used SourcesProviders State Initial
class SourcesProvidersInitial extends SourcesProvidersState {}

/// [SourcesProvidersLoading] class is used SourcesProviders State Loading
class SourcesProvidersLoading extends SourcesProvidersState {}

/// [SourcesProvidersResponse] class is used SourcesProviders State Response
class SourcesProvidersResponse extends SourcesProvidersState {
  final ModelSourcesList mSourcesProviders;

  const SourcesProvidersResponse({required this.mSourcesProviders});

  @override
  List<Object> get props => [mSourcesProviders];
}

/// [SourcesProvidersFailure] class is used SourcesProviders State Failure
class SourcesProvidersFailure extends SourcesProvidersState {
  final String mError;

  const SourcesProvidersFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
