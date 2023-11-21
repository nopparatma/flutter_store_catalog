import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/message_status_rs.dart';

class GetProductKnowledgeRs extends BaseDotnetWebApiRs {
  String mch;
  List<KnowledgeList> knowledgeList;

  GetProductKnowledgeRs({this.mch, this.knowledgeList});

  GetProductKnowledgeRs.fromJson(Map<String, dynamic> json) {
    mch = json['MCH'];
    if (json['KnowledgeList'] != null) {
      knowledgeList = [];
      json['KnowledgeList'].forEach((v) {
        knowledgeList.add(new KnowledgeList.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCH'] = this.mch;
    if (this.knowledgeList != null) {
      data['KnowledgeList'] = this.knowledgeList.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class KnowledgeList {
  num seqNo;
  String knowledgeId;
  String knowledgeName;
  String knowledgeDetail;
  String picUrl;

  KnowledgeList({this.seqNo, this.knowledgeId, this.knowledgeName, this.knowledgeDetail, this.picUrl});

  KnowledgeList.fromJson(Map<String, dynamic> json) {
    seqNo = json['SeqNo'];
    knowledgeId = json['KnowledgeId'];
    knowledgeName = json['KnowledgeName'];
    knowledgeDetail = json['KnowledgeDetail'];
    picUrl = json['PicUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SeqNo'] = this.seqNo;
    data['KnowledgeId'] = this.knowledgeId;
    data['KnowledgeName'] = this.knowledgeName;
    data['KnowledgeDetail'] = this.knowledgeDetail;
    data['PicUrl'] = this.picUrl;
    return data;
  }
}
