import 'package:decimal/decimal.dart';

class MathUtil {

  static num add(num num1, num num2) {
    Decimal decimal1 = Decimal.parse(num1.toString());
    Decimal decimal2 = Decimal.parse(num2.toString());
    return num.parse((decimal1 + decimal2).toString());
  }

  static num subtract(num num1, num num2) {
    Decimal decimal1 = Decimal.parse(num1.toString());
    Decimal decimal2 = Decimal.parse(num2.toString());
    return num.parse((decimal1 - decimal2).toString());
  }

  static num multiple(num num1, num num2) {
    Decimal decimal1 = Decimal.parse(num1.toString());
    Decimal decimal2 = Decimal.parse(num2.toString());
    return num.parse((decimal1 * decimal2).toString());
  }

  static num divide(num num1, num num2) {
    Decimal decimal1 = Decimal.parse(num1.toString());
    Decimal decimal2 = Decimal.parse(num2.toString());
    return num.parse((decimal1 / decimal2).toString());
  }
}
