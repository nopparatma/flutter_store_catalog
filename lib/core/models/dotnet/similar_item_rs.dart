import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/message_status_rs.dart';

class SimilarItemRs extends BaseDotnetWebApiRs {
  List<String> similarItemList;

  SimilarItemRs({this.similarItemList});

  SimilarItemRs.fromJson(Map<String, dynamic> json) {
    similarItemList = json['SimilarItemList']?.cast<String>();
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SimilarItemList'] = this.similarItemList;
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}
