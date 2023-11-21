import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetMCHRs extends BaseMasterDataRs {
  List<Mch> mchs;

  GetMCHRs({this.mchs});

  GetMCHRs.fromJson(Map<String, dynamic> json) {
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    if (json['mchs'] != null) {
      mchs = new List<Mch>();
      json['mchs'].forEach((v) {
        mchs.add(new Mch.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    if (this.mchs != null) {
      data['mchs'] = this.mchs.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Mch {
  DateTime lastPublishedDateTime;
  String mchId;
  String mchNm;

  Mch({this.lastPublishedDateTime, this.mchId, this.mchNm});

  Mch.fromJson(Map<String, dynamic> json) {
    lastPublishedDateTime = DateTimeUtil.toDateTime(json['lastPublishedDateTime']);
    mchId = json['mchId'];
    mchNm = json['mchNm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastPublishedDateTime'] = this.lastPublishedDateTime?.toIso8601String();
    data['mchId'] = this.mchId;
    data['mchNm'] = this.mchNm;
    return data;
  }
}
