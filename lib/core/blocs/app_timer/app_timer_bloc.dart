import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'app_timer_event.dart';

part 'app_timer_state.dart';

class AppTimerBloc extends Bloc<AppTimerEvent, AppTimerState> {
  final Ticker _ticker;
  final int _duration = AppConfig.instance.sessionTimeoutSec;

  StreamSubscription<int> _tickerSubscription;

  AppTimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker;

  @override
  AppTimerState get initialState => AppTimerInitial(_duration);

  @override
  Stream<AppTimerState> mapEventToState(AppTimerEvent event) async* {
    if (event is AppTimerStarted) {
      yield* _mapAppTimerStartedToState(event);
    } else if (event is AppTimerPaused) {
      yield* _mapAppTimerPausedToState(event);
    } else if (event is AppTimerResumed) {
      yield* _mapAppTimerResumedToState(event);
    } else if (event is AppTimerReset) {
      yield* _mapAppTimerResetToState(event);
    } else if (event is AppTimerTicked) {
      yield* _mapAppTimerTickedToState(event);
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Stream<AppTimerState> _mapAppTimerStartedToState(AppTimerStarted start) async* {
    yield AppTimerRunInProgress(_duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: _duration).listen((duration) => add(AppTimerTicked(duration: duration)));
  }

  Stream<AppTimerState> _mapAppTimerPausedToState(AppTimerPaused pause) async* {
    if (state is AppTimerRunInProgress) {
      _tickerSubscription?.pause();
      yield AppTimerRunPause(state.duration);
    }
  }

  Stream<AppTimerState> _mapAppTimerResumedToState(AppTimerResumed resume) async* {
    if (state is AppTimerRunPause) {
      _tickerSubscription?.resume();
      yield AppTimerRunInProgress(state.duration);
    }
  }

  Stream<AppTimerState> _mapAppTimerResetToState(AppTimerReset reset) async* {
    _tickerSubscription?.cancel();
    yield AppTimerInitial(_duration);
  }

  Stream<AppTimerState> _mapAppTimerTickedToState(AppTimerTicked tick) async* {
    yield tick.duration > 0 ? AppTimerRunInProgress(tick.duration) : AppTimerRunComplete();
  }
}

class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks - x - 1).take(ticks);
  }
}
