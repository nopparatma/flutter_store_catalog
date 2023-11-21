import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/message_status_rs.dart';

class GetCalculatorRs extends BaseDotnetWebApiRs {
  String mCH;
  List<Calculator> calculator;

  GetCalculatorRs({this.mCH, this.calculator});

  GetCalculatorRs.fromJson(Map<String, dynamic> json) {
    mCH = json['MCH'];
    if (json['Calculator'] != null) {
      calculator = [];
      json['Calculator'].forEach((v) {
        calculator.add(new Calculator.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCH'] = this.mCH;
    if (this.calculator != null) {
      data['Calculator'] = this.calculator.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class Calculator {
  String calculatorId;
  String calculatorNameTH;
  String calculatorNameEN;
  List<Component> component;

  Calculator({this.calculatorId, this.calculatorNameTH, this.calculatorNameEN, this.component});

  Calculator.fromJson(Map<String, dynamic> json) {
    calculatorId = json['CalculatorId'];
    calculatorNameTH = json['CalculatorNameTH'];
    calculatorNameEN = json['CalculatorNameEN'];
    if (json['Component'] != null) {
      component = [];
      json['Component'].forEach((v) {
        component.add(new Component.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CalculatorId'] = this.calculatorId;
    data['CalculatorNameTH'] = this.calculatorNameTH;
    data['CalculatorNameEN'] = this.calculatorNameEN;
    if (this.component != null) {
      data['Component'] = this.component.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Component {
  num line;
  List<ComponentList> componentList;

  Component({this.line, this.componentList});

  Component.fromJson(Map<String, dynamic> json) {
    line = json['Line'];
    if (json['ComponentList'] != null) {
      componentList = [];
      json['ComponentList'].forEach((v) {
        componentList.add(new ComponentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Line'] = this.line;
    if (this.componentList != null) {
      data['ComponentList'] = this.componentList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ComponentList {
  num seq;
  String componentID;
  String componentName;
  String componentType;
  num defaultValue;
  String unit;
  String toolTip;

  ComponentList({this.seq, this.componentID, this.componentName, this.componentType, this.defaultValue, this.unit, this.toolTip});

  ComponentList.fromJson(Map<String, dynamic> json) {
    seq = json['Seq'];
    componentID = json['ComponentID'];
    componentName = json['ComponentName'];
    componentType = json['ComponentType'];
    defaultValue = json['DefaultValue'];
    unit = json['Unit'];
    toolTip = json['ToolTip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Seq'] = this.seq;
    data['ComponentID'] = this.componentID;
    data['ComponentName'] = this.componentName;
    data['ComponentType'] = this.componentType;
    data['DefaultValue'] = this.defaultValue;
    data['Unit'] = this.unit;
    data['ToolTip'] = this.toolTip;
    return data;
  }
}
