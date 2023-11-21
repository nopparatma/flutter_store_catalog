class CalculatorRq {
  Calculator calculator;

  CalculatorRq({this.calculator});

  CalculatorRq.fromJson(Map<String, dynamic> json) {
    calculator = json['Calculator'] != null ? new Calculator.fromJson(json['Calculator']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.calculator != null) {
      data['Calculator'] = this.calculator.toJson();
    }
    return data;
  }
}

class Calculator {
  String calculatorId;
  List<ComponentList> componentList;

  Calculator({this.calculatorId, this.componentList});

  Calculator.fromJson(Map<String, dynamic> json) {
    calculatorId = json['CalculatorId'];
    if (json['ComponentList'] != null) {
      componentList = [];
      json['ComponentList'].forEach((v) {
        componentList.add(new ComponentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CalculatorId'] = this.calculatorId;
    if (this.componentList != null) {
      data['ComponentList'] = this.componentList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ComponentList {
  String componentID;
  num componentValue;

  ComponentList({this.componentID, this.componentValue});

  ComponentList.fromJson(Map<String, dynamic> json) {
    componentID = json['ComponentID'];
    componentValue = json['ComponentValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComponentID'] = this.componentID;
    data['ComponentValue'] = this.componentValue;
    return data;
  }
}
