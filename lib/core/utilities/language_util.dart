import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageUtil {
  static bool isTh(BuildContext context) {
    return 'th' == context.locale.languageCode;
  }
}
