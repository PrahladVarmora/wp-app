part of 'sub_status_bloc.dart';

/// [SubStatusState] abstract class is used SubStatus State
abstract class SubStatusState extends Equatable {
  const SubStatusState();

  @override
  List<Object> get props => [];
}

/// [SubStatusInitial] class is used SubStatus State Initial
class SubStatusInitial extends SubStatusState {}

/// [SubStatusLoading] class is used SubStatus State Loading
class SubStatusLoading extends SubStatusState {}

/// [SubStatusResponse] class is used SubStatus State Response
class SubStatusResponse extends SubStatusState {
  final ModelJobSubStatus mModelSubStatus;

  const SubStatusResponse({required this.mModelSubStatus});

  @override
  List<Object> get props => [mModelSubStatus];
}

/// [SubStatusFailure] class is used SubStatus State Failure
class SubStatusFailure extends SubStatusState {
  final String mError;

  const SubStatusFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
