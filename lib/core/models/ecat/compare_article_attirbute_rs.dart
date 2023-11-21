import 'package:flutter_store_catalog/core/models/ecat/base_ecat_rs.dart';

class CompareArticleAttributeRs extends BaseECatRs {
  List<CompareAttributeList> compareAttributeList;
  String mCH3NameTH;
  String mCH3NameEN;

  CompareArticleAttributeRs({
    this.compareAttributeList,
    this.mCH3NameTH,
    this.mCH3NameEN,
  });

  CompareArticleAttributeRs.fromJson(Map<String, dynamic> json) {
    if (json['CompareAttributeList'] != null) {
      compareAttributeList = new List<CompareAttributeList>();
      json['CompareAttributeList'].forEach((v) {
        compareAttributeList.add(new CompareAttributeList.fromJson(v));
      });
    }
    mCH3NameTH = json['MCH3NameTH'];
    mCH3NameEN = json['MCH3NameEN'];
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.compareAttributeList != null) {
      data['CompareAttributeList'] = this.compareAttributeList.map((v) => v.toJson()).toList();
    }
    data['MCH3NameTH'] = this.mCH3NameTH;
    data['MCH3NameEN'] = this.mCH3NameEN;
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class CompareAttributeList {
  String attributeNameTH;
  String attributeNameEN;
  List<AttributeList> attributeList;

  CompareAttributeList({this.attributeNameTH, this.attributeNameEN, this.attributeList});

  CompareAttributeList.fromJson(Map<String, dynamic> json) {
    attributeNameTH = json['AttributeNameTH'];
    attributeNameEN = json['AttributeNameEN'];
    if (json['AttributeList'] != null) {
      attributeList = new List<AttributeList>();
      json['AttributeList'].forEach((v) {
        attributeList.add(new AttributeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AttributeNameTH'] = this.attributeNameTH;
    data['AttributeNameEN'] = this.attributeNameEN;
    if (this.attributeList != null) {
      data['AttributeList'] = this.attributeList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttributeList {
  String attributeDataTH;
  String attributeDataEN;

  AttributeList({this.attributeDataTH, this.attributeDataEN});

  AttributeList.fromJson(Map<String, dynamic> json) {
    attributeDataTH = json['AttributeDataTH'];
    attributeDataEN = json['AttributeDataEN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AttributeDataTH'] = this.attributeDataTH;
    data['AttributeDataEN'] = this.attributeDataEN;
    return data;
  }
}
