part of 'app_timer_bloc.dart';

abstract class AppTimerState extends Equatable {
  final int duration;

  const AppTimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

class AppTimerInitial extends AppTimerState {
  const AppTimerInitial(int duration) : super(duration);

  @override
  String toString() => 'Ready { duration: $duration }';
}

class AppTimerRunPause extends AppTimerState {
  const AppTimerRunPause(int duration) : super(duration);

  @override
  String toString() => 'Paused { duration: $duration }';
}

class AppTimerRunInProgress extends AppTimerState {
  const AppTimerRunInProgress(int duration) : super(duration);

  @override
  String toString() => 'Running { duration: $duration }';
}

class AppTimerRunComplete extends AppTimerState {
  const AppTimerRunComplete() : super(0);
}