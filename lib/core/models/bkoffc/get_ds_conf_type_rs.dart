import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetDsConfTypeRs extends BaseMasterDataRs {
  List<DsConfType> dsConfTypes;

  GetDsConfTypeRs({this.dsConfTypes});

  GetDsConfTypeRs.fromJson(Map<String, dynamic> json) {
    if (json['dsConfTypes'] != null) {
      dsConfTypes = new List<DsConfType>();
      json['dsConfTypes'].forEach((v) {
        dsConfTypes.add(new DsConfType.fromJson(v));
      });
    }
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dsConfTypes != null) {
      data['dsConfTypes'] = this.dsConfTypes.map((v) => v.toJson()).toList();
    }
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class DsConfType {
  String confirmTypeDesc;
  String confirmTypeId;
  DateTime createDate;
  String isActive;
  DateTime lastPublishedDateTime;
  DateTime lastUpdateDate;
  String referencePublishId;
  num seqNo;

  DsConfType({this.confirmTypeDesc, this.confirmTypeId, this.createDate, this.isActive, this.lastPublishedDateTime, this.lastUpdateDate, this.referencePublishId, this.seqNo});

  DsConfType.fromJson(Map<String, dynamic> json) {
    confirmTypeDesc = json['confirmTypeDesc'];
    confirmTypeId = json['confirmTypeId'];
    createDate = DateTimeUtil.toDateTime(json['createDate']);
    isActive = json['isActive'];
    lastPublishedDateTime = DateTimeUtil.toDateTime(json['lastPublishedDateTime']);
    lastUpdateDate = DateTimeUtil.toDateTime(json['lastUpdateDate']);
    referencePublishId = json['referencePublishId'];
    seqNo = json['seqNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['confirmTypeDesc'] = this.confirmTypeDesc;
    data['confirmTypeId'] = this.confirmTypeId;
    data['createDate'] = this.createDate?.toIso8601String();
    data['isActive'] = this.isActive;
    data['lastPublishedDateTime'] = this.lastPublishedDateTime?.toIso8601String();
    data['lastUpdateDate'] = this.lastUpdateDate?.toIso8601String();
    data['referencePublishId'] = this.referencePublishId;
    data['seqNo'] = this.seqNo;
    return data;
  }
}
