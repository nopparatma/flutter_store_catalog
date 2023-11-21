import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';

class DateTimeUtil {
  static DateTime toDateTime(String s) {
    if (StringUtil.isNullOrEmpty(s)) {
      return null;
    }
    return DateTime.parse(s);
  }

  static DateTime toDate(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  static String toDateTimeString(DateTime d, String format, {String locale}) {
    DateFormat dateFormat = DateFormat(format, locale);
    return dateFormat.format(d);
  }
}
