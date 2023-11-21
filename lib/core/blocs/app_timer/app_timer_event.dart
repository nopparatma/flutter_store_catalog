part of 'app_timer_bloc.dart';

abstract class AppTimerEvent extends Equatable {
  const AppTimerEvent();

  @override
  List<Object> get props => [];
}

class AppTimerStarted extends AppTimerEvent {}

class AppTimerPaused extends AppTimerEvent {}

class AppTimerResumed extends AppTimerEvent {}

class AppTimerReset extends AppTimerEvent {}

class AppTimerTicked extends AppTimerEvent {
  final int duration;

  const AppTimerTicked({@required this.duration});

  @override
  List<Object> get props => [duration];

  @override
  String toString() => "Tick { duration: $duration }";
}
