import 'package:flutter_store_catalog/core/models/ecat/base_ecat_rs.dart';

class GetCategoryFilterRs extends BaseECatRs{
  List<FeatureList> featureList;

  GetCategoryFilterRs({this.featureList});

  GetCategoryFilterRs.fromJson(Map<String, dynamic> json) {
    if (json['FeatureList'] != null) {
      featureList = new List<FeatureList>();
      json['FeatureList'].forEach((v) {
        featureList.add(new FeatureList.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.featureList != null) {
      data['FeatureList'] = this.featureList.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class FeatureList {
  String featureCode;
  String featureNameEn;
  String featureNameTh;

  FeatureList({this.featureCode, this.featureNameEn, this.featureNameTh});

  FeatureList.fromJson(Map<String, dynamic> json) {
    featureCode = json['FeatureCode'];
    featureNameEn = json['FeatureNameEn'];
    featureNameTh = json['FeatureNameTh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FeatureCode'] = this.featureCode;
    data['FeatureNameEn'] = this.featureNameEn;
    data['FeatureNameTh'] = this.featureNameTh;
    return data;
  }
}