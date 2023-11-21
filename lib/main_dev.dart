import 'package:catcher/core/catcher.dart';
import 'package:catcher/handlers/console_handler.dart';
import 'package:catcher/mode/silent_report_mode.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_store_catalog/core/app_logger.dart';
import 'package:flutter_store_catalog/core/blocs/app_timer/app_timer_bloc.dart';
import 'package:logger/logger.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/app.dart';
import 'app/app_config.dart';
import 'core/get_it.dart';

void main() {
  AppConfig.dev();
  Logger.level = Level.verbose;

  BlocSupervisor.delegate = SimpleBlocDelegate();
  setupGetIt();
  // setPathUrlStrategy();

  CatcherOptions catcherOptions = CatcherOptions(
    SilentReportMode(),
    [ConsoleHandler()],
  );

  Catcher(
    runAppFunction: () {
      runApp(
        Phoenix(
          child: MainAppLocalization(),
        ),
      );
    },
    debugConfig: catcherOptions,
    releaseConfig: catcherOptions,
    profileConfig: catcherOptions,
  );
}

class SimpleBlocDelegate extends BlocDelegate {
  var log = AppLogger();

  @override
  void onEvent(Bloc bloc, Object event) {
    if (isPrintLog(bloc)) {
      log.d(event);
    }
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (isPrintLog(bloc)) {
      log.d(transition);
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    log.d(error);
    super.onError(bloc, error, stackTrace);
  }

  bool isPrintLog(Bloc bloc) {
    return bloc is! AppTimerBloc;
  }
}
