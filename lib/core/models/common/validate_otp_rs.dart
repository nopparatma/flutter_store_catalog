import '../base_dotnet_webapi_rs.dart';
import '../message_status_rs.dart';

class ValidateOTPRs extends BaseDotnetWebApiRs {
  String validateStatus;
  String validateMessage;

  ValidateOTPRs(
      {this.validateStatus, this.validateMessage, messageStatusRs});

  ValidateOTPRs.fromJson(Map<String, dynamic> json) {
    validateStatus = json['ValidateStatus'];
    validateMessage = json['ValidateMessage'];
    messageStatusRs = json['MessageStatusRs'] != null
        ? new MessageStatusRs.fromJson(json['MessageStatusRs'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ValidateStatus'] = this.validateStatus;
    data['ValidateMessage'] = this.validateMessage;
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}
