import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:intl/intl.dart';

class StringUtil {

  static String getDefaultCurrencyFormat(num s) {
    NumberFormat defaultCurrencyFormat = new NumberFormat("#,##0.##", "en_US");
    return defaultCurrencyFormat.format(s);
  }

  static bool isNullOrEmpty(String s) {
    if (s == null) {
      return true;
    }

    if (s?.isEmpty ?? true) {
      return true;
    }

    if (s.trim() == '') {
      return true;
    }

    return false;
  }

  static bool isNotEmpty(String s) {
    return !isNullOrEmpty(s);
  }

  static String nullStringToString(String s) {
    if (isNullOrEmpty(s)) {
      return "";
    }
    return s;
  }

  static String nullNumToString(num s) {
    if (s == null) {
      return "";
    }
    return s.toString();
  }

  static String nullDoubleToString(double s) {
    if (s == null) {
      return "";
    }
    return s.toString();
  }

  static String nullIntToString(int s) {
    if (s == null) {
      return "";
    }
    return s.toString();
  }

//  static String nullDecimalToString(decimal s) {
//    if (s == null) {
//      return "";
//    }
//    return s.toString();
//  }

  static String trimLeftZero(String from) {
    if (isNullOrEmpty(from)) {
      return '';
    }
    return trimLeft(from, '0');
  }

  static String trimLeft(String from, String pattern) {
    if ((from ?? '').isEmpty || (pattern ?? '').isEmpty || pattern.length > from.length) return from;

    while (from.startsWith(pattern)) {
      from = from.substring(pattern.length);
    }
    return from;
  }

  static String trimRight(String from, String pattern) {
    if ((from ?? '').isEmpty || (pattern ?? '').isEmpty || pattern.length > from.length) return from;

    while (from.endsWith(pattern)) {
      from = from.substring(0, from.length - pattern.length);
    }
    return from;
  }

  static String trim(String from, String pattern) {
    return trimLeft(trimRight(from, pattern), pattern);
  }

  static String toStringFormat(num s, String format, {String defaultString}) {
    if (s == null) {
      return '$defaultString';
    }
    return NumberFormat(format).format(s);
  }

  static String getAddress(String village, String floor, String unit, String soi, String moo, String number, String street, String subDistrict, String district, String province, String zipCode) {
    String result = '';
    if (village != null && village.isNotEmpty) {
      result += '$village ';
    }
    if (floor != null && floor.isNotEmpty) {
      result += 'ชั้น $floor ';
    }
    if (unit != null && unit.isNotEmpty) {
      result += 'ห้อง $unit ';
    }
    if (number != null && number.isNotEmpty) {
      result += 'เลขที่ $number ';
    }
    if (soi != null && soi.isNotEmpty) {
      result += 'ซอย $soi ';
    }
    if (moo != null && moo.isNotEmpty) {
      result += 'หมู่ $moo ';
    }

    if (street != null && street.isNotEmpty) {
      result += 'ถนน $street ';
    }
    if (subDistrict != null && subDistrict.isNotEmpty) {
      result += 'ตำบล $subDistrict ';
    }
    if (district != null && district.isNotEmpty) {
      result += 'อำเภอ $district ';
    }
    if (province != null) {
      result += 'จังหวัด $province ';
    }
    if (zipCode != null && zipCode.isNotEmpty) {
      result += '$zipCode ';
    }
    return result;
  }

  static String toCurrencyFormat(num price) {
    if (price == null) {
      return NumberFormat.currency(customPattern: '#,###.##').format(0)?.toString();
    }

    return NumberFormat.currency(customPattern: '#,###.##').format(price)?.toString();
  }

  static String getCensorText(String text, String censorFormat) {
    if (text == null) return '';
    if (censorFormat == null || censorFormat.split(',').length != 2) return text;
    int start = int.parse(censorFormat.split(',')[0]);
    int length = int.parse(censorFormat.split(',')[1]);
    return text.split('').asMap().entries.map((e) => e.key >= start && e.key < start + length ? 'X' : e.value).join('');
  }
  
  static bool isValidEmail(String val) {
    if (val == null) {
      return false;
    }
    return RegExp(RegularExpression.EMAIL_FORMAT).hasMatch(val);
  }
  
  static bool isValidThaiIDCard(String val) {
    if (val == null || val.length != 13 || !RegExp(r'^[0-9]\d+$').hasMatch(val)) {
      return false;
    }
    var sum = 0;
    for (var i = 0; i < val.length - 1; i++) {
      sum += int.parse(val[i]) * (13 - i);
    }

    var checkDigit = (11 - (sum % 11)) % 10;

    return checkDigit == int.parse(val[12]);
  }
}
