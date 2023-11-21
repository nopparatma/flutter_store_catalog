import '../base_dotnet_webapi_rs.dart';
import '../message_status_rs.dart';

class SendOTPRs extends BaseDotnetWebApiRs {
  String sendStatus;
  String sendMessage;
  String refCode;
  String transID;

  SendOTPRs(
      {this.sendStatus,
        this.sendMessage,
        this.refCode,
        this.transID,
        messageStatusRs});

  SendOTPRs.fromJson(Map<String, dynamic> json) {
    sendStatus = json['SendStatus'];
    sendMessage = json['SendMessage'];
    refCode = json['RefCode'];
    transID = json['TransID'];
    messageStatusRs = json['MessageStatusRs'] != null
        ? new MessageStatusRs.fromJson(json['MessageStatusRs'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SendStatus'] = this.sendStatus;
    data['SendMessage'] = this.sendMessage;
    data['RefCode'] = this.refCode;
    data['TransID'] = this.transID;
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}
