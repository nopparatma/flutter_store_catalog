import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_close_dialog_button.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_snackbar.dart';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';

import '../app_exception.dart';
import '../app_logger.dart';

class DialogUtil {

  static Future<void> showLoadingDialog(BuildContext context) async {
    try {
      context.showLoaderOverlay();
    } catch (error) {
      AppLogger().e(error);
    }
  }

  static Future<void> hideLoadingDialog(BuildContext context) async {
    try {
      context.hideLoaderOverlay();
    } catch (error) {
      AppLogger().e(error);
    }
  }

  static Future<void> showErrorDialog(BuildContext context, dynamic error, {String title}) async {
    AppLogger().e(error);

    IconData icon = Icons.warning;
    Color textColor = colorDialogErrorText;
    Color backgroundColor = colorDialogErrorBackground;

    String errorMsg;
    String errorMsgOther;
    if (error is AppException) {
      if (error.error is WarningWebApiException) {
        WarningWebApiException warnError = error.error;
        errorMsg = '${warnError.error}';
        errorMsgOther = warnError.url;
        textColor = colorDialogWarningText;
        backgroundColor = colorDialogWarningBackground;
      } else if (error.error is ErrorWebApiException) {
        ErrorWebApiException errorError = error.error;
        errorMsg = '${errorError.error}';
        errorMsgOther = errorError.url;
      } else if (error.error is DioError) {
        DioError dioError = error.error;
        errorMsg = 'common.msg.cannot_connect_to_api'.tr() + ' : ${dioError.message}';
        errorMsgOther = '${dioError.request.path}';
        if (dioError.response != null && dioError.response.data != null) {
          errorMsgOther += '\n${dioError.response.data}';
        }
      } else {
        errorMsg = '${error.error}';
        if (error.stackTrace != null) {
          errorMsgOther = '${error.stackTrace}';
        }
        if (error.errorType == ErrorType.WARNING) {
          textColor = colorDialogWarningText;
          backgroundColor = colorDialogWarningBackground;
        }
      }
    } else if (error is Exception) {
      errorMsg = '$error';
      var stackTrace = StackTrace.current;
      if (stackTrace != null) {
        errorMsgOther = '$stackTrace';
      }
    } else if (error is Error) {
      errorMsg = '$error';
      if (error.stackTrace != null) {
        errorMsgOther = '${error.stackTrace}';
      }
    } else {
      errorMsg = '$error';
    }

    showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: '${'common.error_occurred_system'.tr()} : $errorMsg',
        backgroundColor: colorRed1.withOpacity(0.6),
      ),
    );
  }

  static Future<bool> showConfirmDialog(
    BuildContext context, {
    String title,
    String message,
    String textOk,
    Color colorOk = colorBlue7,
    String textCancel,
    Color colorCancel = colorAccent,
    Color backgroundColor = Colors.white,
    bool isShowCloseButton = true,
    double width = 450,
  }) async {
    return await showCustomDialog(
      context,
      isShowCloseButton: isShowCloseButton,
      child: Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title ?? '',
              style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                message ?? '',
                style: Theme.of(context).textTheme.normal,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        primary: colorCancel,
                        padding: const EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text(
                        textCancel ?? 'text.back'.tr(),
                        style: Theme.of(context).textTheme.normal.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        primary: colorOk,
                        padding: const EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        textOk ?? 'common.dialog_button_ok'.tr(),
                        style: Theme.of(context).textTheme.normal.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showWarningDialog(BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorDialogWarningBackground,
          title: Row(
            children: <Widget>[
              Icon(Icons.info, color: colorDialogWarningText),
              Padding(padding: EdgeInsets.only(right: 8)),
              Expanded(
                child: Text(
                  title ?? '',
                  style: TextStyle(color: colorDialogWarningText),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message ?? '',
                  style: TextStyle(color: colorDialogWarningText),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'common.dialog_button_ok'.tr(),
                style: TextStyle(color: colorDialogWarningText),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<dynamic> showCustomDialog(
    BuildContext context, {
    Widget child,
    Color backgroundColor,
    bool isShowCloseButton = true,
    bool barrierDismissible = false,
    Color closeButtonColor = colorDark,
    double elevation = 8,
    bool isScrollView = true,
    Function onTapClose,
  }) async {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: barrierDismissible ?? false,
      barrierColor: colorBlue2.withOpacity(0.6),
      builder: (BuildContext context) {

        bool isPortrait = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
        double dialogPadding = MediaQuery.of(context).size.height * 0.3;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: AlertDialog(
            elevation: elevation,
            backgroundColor: backgroundColor ?? Colors.grey[100],
            contentPadding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
            titlePadding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
            insetPadding: isPortrait ? EdgeInsets.only(bottom: dialogPadding, top: 30) : null,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isShowCloseButton)
                  CustomCloseDialogButton(
                    closeButtonColor: closeButtonColor,
                    isInkStyle: false,
                    onTap: onTapClose ?? () {
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
            content: isScrollView
                ? SingleChildScrollView(
                    child: PointerInterceptor(child: child),
                  )
                : PointerInterceptor(child: child),
          ),
        );
      },
    );
  }
}
