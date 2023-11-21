import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';

import '../message_status_rs.dart';

class CheckVersionApplicationRs extends BaseDotnetWebApiRs {
  String errorCode;

  CheckVersionApplicationRs({this.errorCode, messageStatusRs});

  CheckVersionApplicationRs.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}
