import '../base_dotnet_webapi_rs.dart';
import '../message_status_rs.dart';

class GetConfigRs extends BaseDotnetWebApiRs {
  List<Config> configs;

  GetConfigRs({this.configs, messageStatusRs});

  GetConfigRs.fromJson(Map<String, dynamic> json) {
    if (json['Configs'] != null) {
      configs = new List<Config>();
      json['Configs'].forEach((v) {
        configs.add(new Config.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null
        ? new MessageStatusRs.fromJson(json['MessageStatusRs'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.configs != null) {
      data['Configs'] = this.configs.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class Config {
  String keyname;
  String data1;
  String data2;
  String description;

  Config({this.keyname, this.data1, this.data2, this.description});

  Config.fromJson(Map<String, dynamic> json) {
    keyname = json['Keyname'];
    data1 = json['Data1'];
    data2 = json['Data2'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Keyname'] = this.keyname;
    data['Data1'] = this.data1;
    data['Data2'] = this.data2;
    data['Description'] = this.description;
    return data;
  }
}