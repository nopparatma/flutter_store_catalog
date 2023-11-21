import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetMstTenderGroupRs extends BaseMasterDataRs {
  List<MstTenderGroup> mstTenderGroups;

  GetMstTenderGroupRs({this.mstTenderGroups});

  GetMstTenderGroupRs.fromJson(Map<String, dynamic> json) {
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    if (json['mstTenderGroups'] != null) {
      mstTenderGroups = new List<MstTenderGroup>();
      json['mstTenderGroups'].forEach((v) {
        mstTenderGroups.add(new MstTenderGroup.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    if (this.mstTenderGroups != null) {
      data['mstTenderGroups'] = this.mstTenderGroups.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class MstTenderGroup {
  DateTime createDateTime;
  String createUserName;
  bool isTenderAR;
  DateTime lastPubDateTime;
  List<MstTenderGroupDet> mstTenderGroupDetBos;
  String refPubId;
  num seqNo;
  String tenderGroupId;
  String tenderGroupName;

  MstTenderGroup({this.createDateTime, this.createUserName, this.isTenderAR, this.lastPubDateTime, this.mstTenderGroupDetBos, this.refPubId, this.seqNo, this.tenderGroupId, this.tenderGroupName});

  MstTenderGroup.fromJson(Map<String, dynamic> json) {
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUserName = json['createUserName'];
    isTenderAR = json['isTenderAR'];
    lastPubDateTime = DateTimeUtil.toDateTime(json['lastPubDateTime']);
    if (json['mstTenderGroupDetBos'] != null) {
      mstTenderGroupDetBos = new List<MstTenderGroupDet>();
      json['mstTenderGroupDetBos'].forEach((v) {
        mstTenderGroupDetBos.add(new MstTenderGroupDet.fromJson(v));
      });
    }
    refPubId = json['refPubId'];
    seqNo = json['seqNo'];
    tenderGroupId = json['tenderGroupId'];
    tenderGroupName = json['tenderGroupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUserName'] = this.createUserName;
    data['isTenderAR'] = this.isTenderAR;
    data['lastPubDateTime'] = this.lastPubDateTime?.toIso8601String();
    if (this.mstTenderGroupDetBos != null) {
      data['mstTenderGroupDetBos'] = this.mstTenderGroupDetBos.map((v) => v.toJson()).toList();
    }
    data['refPubId'] = this.refPubId;
    data['seqNo'] = this.seqNo;
    data['tenderGroupId'] = this.tenderGroupId;
    data['tenderGroupName'] = this.tenderGroupName;
    return data;
  }
}

class MstTenderGroupDet {
  String cardDummy;
  DateTime createDateTime;
  String createUserName;
  String image;
  bool isShowImg;
  DateTime lastPubDateTime;
  MstTenderGroup mstTenderGroupBo;
  String refPubId;
  num seqNo;
  String tenderGrpDetId;
  String tenderId;
  String tenderName;
  String tenderNo;

  MstTenderGroupDet({this.cardDummy, this.createDateTime, this.createUserName, this.image, this.isShowImg, this.lastPubDateTime, this.mstTenderGroupBo, this.refPubId, this.seqNo, this.tenderGrpDetId, this.tenderId, this.tenderName, this.tenderNo});

  MstTenderGroupDet.fromJson(Map<String, dynamic> json) {
    cardDummy = json['cardDummy'];
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUserName = json['createUserName'];
    image = json['image'];
    isShowImg = json['isShowImg'];
    lastPubDateTime = DateTimeUtil.toDateTime(json['lastPubDateTime']);
    mstTenderGroupBo = json['mstTenderGroupBo'] != null ? new MstTenderGroup.fromJson(json['mstTenderGroupBo']) : null;
    refPubId = json['refPubId'];
    seqNo = json['seqNo'];
    tenderGrpDetId = json['tenderGrpDetId'];
    tenderId = json['tenderId'];
    tenderName = json['tenderName'];
    tenderNo = json['tenderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardDummy'] = this.cardDummy;
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUserName'] = this.createUserName;
    data['image'] = this.image;
    data['isShowImg'] = this.isShowImg;
    data['lastPubDateTime'] = this.lastPubDateTime?.toIso8601String();
    if (this.mstTenderGroupBo != null) {
      data['mstTenderGroupBo'] = this.mstTenderGroupBo.toJson();
    }
    data['refPubId'] = this.refPubId;
    data['seqNo'] = this.seqNo;
    data['tenderGrpDetId'] = this.tenderGrpDetId;
    data['tenderId'] = this.tenderId;
    data['tenderName'] = this.tenderName;
    data['tenderNo'] = this.tenderNo;
    return data;
  }
}
