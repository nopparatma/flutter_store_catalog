import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetSystemConfigConstantRs extends BaseMasterDataRs {
  List<SystemConfiguration> systemConfigurations;

  GetSystemConfigConstantRs({this.systemConfigurations});

  GetSystemConfigConstantRs.fromJson(Map<String, dynamic> json) {
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    status = json['status'];
    if (json['systemConfigurationBos'] != null) {
      systemConfigurations = new List<SystemConfiguration>();
      json['systemConfigurationBos'].forEach((v) {
        systemConfigurations.add(new SystemConfiguration.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.systemConfigurations != null) {
      data['systemConfigurationBos'] = this.systemConfigurations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SystemConfiguration {
  String key;
  String value;

  SystemConfiguration({this.key, this.value});

  SystemConfiguration.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}
