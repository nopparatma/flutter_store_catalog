import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetCustomerTitlesRs extends BaseMasterDataRs {
  List<CustomerTitle> lstCustomerTitles;

  GetCustomerTitlesRs({this.lstCustomerTitles});

  GetCustomerTitlesRs.fromJson(Map<String, dynamic> json) {
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    if (json['lstCustomerTitle'] != null) {
      lstCustomerTitles = new List<CustomerTitle>();
      json['lstCustomerTitle'].forEach((v) {
        lstCustomerTitles.add(new CustomerTitle.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    if (this.lstCustomerTitles != null) {
      data['lstCustomerTitle'] = this.lstCustomerTitles.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class CustomerTitle {
  DateTime lastPublishedDateTime;
  String titleId;
  String name;
  String type;

  CustomerTitle({this.lastPublishedDateTime, this.titleId, this.name, this.type});

  CustomerTitle.fromJson(Map<String, dynamic> json) {
    lastPublishedDateTime = DateTimeUtil.toDateTime(json['lastPublishedDateTime']);
    titleId = json['titleId'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastPublishedDateTime'] = this.lastPublishedDateTime?.toIso8601String();
    data['titleId'] = this.titleId;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}
