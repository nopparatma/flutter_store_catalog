import 'package:flutter_store_catalog/core/models/dotnet/get_calculator_rs.dart';

class CalculatorProductComponent {
  String calculatorId;
  String calculatorNameTH;
  String calculatorNameEN;
  List<CalProductChoice> listCalProductChoice;

  CalculatorProductComponent({this.calculatorId, this.calculatorNameTH, this.calculatorNameEN, this.listCalProductChoice});
}

class CalProductChoice {
  num line;
  num seq;
  String title;
  List<CalProductAnswer> listCalProductAnswer;

  CalProductChoice({this.line, this.seq, this.title, this.listCalProductAnswer});
}

class CalProductAnswer {
  bool isSelected = false;
  num value = 0;
  ComponentList component;

  CalProductAnswer({this.isSelected, this.component});
}
