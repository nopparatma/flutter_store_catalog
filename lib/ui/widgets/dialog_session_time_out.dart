import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_store_catalog/core/blocs/app_timer/app_timer_bloc.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_line_icon_icons.dart';

const int DIALOG_TIME_OUT_SEC = 60;

class DialogSessionTimeOut extends StatefulWidget {
  final int timeOutSec;

  DialogSessionTimeOut({this.timeOutSec = DIALOG_TIME_OUT_SEC});

  _DialogSessionTimeOutState createState() => _DialogSessionTimeOutState();
}

class _DialogSessionTimeOutState extends State<DialogSessionTimeOut> {
  CountdownTimerController _countdownController;

  @override
  void initState() {
    super.initState();

    _countdownController = CountdownTimerController(
      endTime: DateTime.now().add(Duration(seconds: widget.timeOutSec)).millisecondsSinceEpoch,
      onEnd: onEndCountdown,
    );
  }

  @override
  void dispose() {
    _countdownController?.dispose();
    super.dispose();
  }

  onPressedOk() {
    Navigator.of(context).pop(true);
  }

  onEndCountdown() {
    Phoenix.rebirth(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'text.out_of_time'.tr(),
              style: Theme.of(context).textTheme.larger.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorRed1,
                  ),
            ),
            SizedBox(height: 20),
            Text(
              'text.want_to_continue'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.normal,
                    color: colorDark,
                  ),
            ),
            SizedBox(height: 20),
            _buildCountdownView(),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        primary: colorBlue7,
                        padding: const EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        onPressedOk();
                      },
                      child: Text(
                        'common.dialog_button_ok'.tr(),
                        style: Theme.of(context).textTheme.normal.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownView() {
    return CountdownTimer(
      controller: _countdownController,
      widgetBuilder: (_, CurrentRemainingTime time) {
        int min = time?.min ?? 0;
        int sec = time?.sec ?? 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.timer, color: colorDark),
            SizedBox(
              width: 5,
            ),
            Text(
              '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.normal.copyWith(color: colorDark),
            ),
          ],
        );
      },
    );
  }
}
