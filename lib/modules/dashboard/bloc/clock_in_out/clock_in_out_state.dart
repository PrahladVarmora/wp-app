part of 'clock_in_out_bloc.dart';

/// [ClockInOutState] abstract class is used ClockInOut State
abstract class ClockInOutState extends Equatable {
  const ClockInOutState();

  @override
  List<Object> get props => [];
}

/// [ClockInOutInitial] class is used ClockInOut State Initial
class ClockInOutInitial extends ClockInOutState {}

/// [ClockInOutLoading] class is used ClockInOut State Loading
class ClockInOutLoading extends ClockInOutState {}

/// [ClockInOutResponse] class is used ClockInOut State Response
class ClockInOutResponse extends ClockInOutState {
  final ModelCommonAuthorised mModelClockInOut;

  const ClockInOutResponse({required this.mModelClockInOut});

  @override
  List<Object> get props => [mModelClockInOut];
}

/// [ClockInOutFailure] class is used ClockInOut State Failure
class ClockInOutFailure extends ClockInOutState {
  final String mError;

  const ClockInOutFailure({required this.mError});

  @override
  List<Object> get props => [mError];
}
