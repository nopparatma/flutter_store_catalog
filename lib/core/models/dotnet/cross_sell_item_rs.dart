import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/message_status_rs.dart';

class CrossSellItemRs extends BaseDotnetWebApiRs {
  List<String> crossSellItemList;

  CrossSellItemRs({this.crossSellItemList});

  CrossSellItemRs.fromJson(Map<String, dynamic> json) {
    crossSellItemList = json['CrossSellItemList']?.cast<String>();
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CrossSellItemList'] = this.crossSellItemList;
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}
