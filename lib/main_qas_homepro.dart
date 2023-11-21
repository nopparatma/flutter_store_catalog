import 'package:catcher/core/catcher.dart';
import 'package:catcher/handlers/console_handler.dart';
import 'package:catcher/mode/silent_report_mode.dart';
import 'package:catcher/model/catcher_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:logger/logger.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/app.dart';
import 'app/app_config.dart';
import 'core/get_it.dart';

void main() {
  AppConfig.qas_homepro();
  Logger.level = Level.error;

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
