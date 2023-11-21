import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/message_status_rs.dart';

class CalculatorRs extends BaseDotnetWebApiRs {
  num resultCalculator;
  String featureCode;
  String beforeResultTextTh;
  String beforeResultTextEn;
  String afterResultTextTh;
  String afterResultTextEn;
  String remarkTh;
  String remarkEn;
  List<String> mchs;

  CalculatorRs({
    this.resultCalculator,
    this.featureCode,
    this.beforeResultTextTh,
    this.beforeResultTextEn,
    this.afterResultTextTh,
    this.afterResultTextEn,
    this.remarkTh,
    this.remarkEn,
    this.mchs,
  });

  CalculatorRs.fromJson(Map<String, dynamic> json) {
    resultCalculator = json['ResultCalculator'];
    featureCode = json['FeatureCode'];
    beforeResultTextTh = json['BeforeResultTextTh'];
    beforeResultTextEn = json['BeforeResultTextEn'];
    afterResultTextTh = json['AfterResultTextTh'];
    afterResultTextEn = json['AfterResultTextEn'];
    remarkTh = json['RemarkTh'];
    remarkEn = json['RemarkEn'];
    mchs = json['MCHs']?.cast<String>();
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ResultCalculator'] = this.resultCalculator;
    data['FeatureCode'] = this.featureCode;
    data['BeforeResultTextTh'] = this.beforeResultTextTh;
    data['BeforeResultTextEn'] = this.beforeResultTextEn;
    data['AfterResultTextTh'] = this.afterResultTextTh;
    data['AfterResultTextEn'] = this.afterResultTextEn;
    data['RemarkTh'] = this.remarkTh;
    data['RemarkEn'] = this.remarkEn;
    data['MCHs'] = this.mchs;
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}
