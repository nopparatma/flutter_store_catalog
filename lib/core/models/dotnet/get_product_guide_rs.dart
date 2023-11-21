import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/message_status_rs.dart';

class GetProductGuideRs extends BaseDotnetWebApiRs {
  List<Grouping> grouping;

  GetProductGuideRs({this.grouping});

  GetProductGuideRs.fromJson(Map<String, dynamic> json) {
    if (json['Grouping'] != null) {
      grouping = [];
      json['Grouping'].forEach((v) {
        grouping.add(new Grouping.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.grouping != null) {
      data['Grouping'] = this.grouping.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class Grouping {
  String groupNameTh;
  String groupNameEn;
  String calculator;
  List<String> knowledgeIdList;

  Grouping({this.groupNameTh, this.groupNameEn, this.calculator, this.knowledgeIdList});

  Grouping.fromJson(Map<String, dynamic> json) {
    groupNameTh = json['GroupNameTh'];
    groupNameEn = json['GroupNameEn'];
    calculator = json['Calculator'];
    knowledgeIdList = json['KnowledgeIdList']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GroupNameTh'] = this.groupNameTh;
    data['GroupNameEn'] = this.groupNameEn;
    data['Calculator'] = this.calculator;
    data['KnowledgeIdList'] = this.knowledgeIdList;
    return data;
  }
}
