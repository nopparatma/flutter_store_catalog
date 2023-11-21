import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetDsTimeGroupRs extends BaseMasterDataRs {
  List<DsTimeGroup> dsTimeGroups;

  GetDsTimeGroupRs({this.dsTimeGroups});

  GetDsTimeGroupRs.fromJson(Map<String, dynamic> json) {
    if (json['dsTimeGroups'] != null) {
      dsTimeGroups = new List<DsTimeGroup>();
      json['dsTimeGroups'].forEach((v) {
        dsTimeGroups.add(new DsTimeGroup.fromJson(v));
      });
    }
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dsTimeGroups != null) {
      data['dsTimeGroups'] = this.dsTimeGroups.map((v) => v.toJson()).toList();
    }
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class DsTimeGroup {
  DateTime lastPubDateTime;
  String refPubId;
  num seqNo;
  String timeDesc;
  String timeName;
  String timeNo;

  DsTimeGroup({this.lastPubDateTime, this.refPubId, this.seqNo, this.timeDesc, this.timeName, this.timeNo});

  DsTimeGroup.fromJson(Map<String, dynamic> json) {
    lastPubDateTime = DateTimeUtil.toDateTime(json['lastPubDateTime']);
    refPubId = json['refPubId'];
    seqNo = json['seqNo'];
    timeDesc = json['timeDesc'];
    timeName = json['timeName'];
    timeNo = json['timeNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastPubDateTime'] = this.lastPubDateTime?.toIso8601String();
    data['refPubId'] = this.refPubId;
    data['seqNo'] = this.seqNo;
    data['timeDesc'] = this.timeDesc;
    data['timeName'] = this.timeName;
    data['timeNo'] = this.timeNo;
    return data;
  }
}
