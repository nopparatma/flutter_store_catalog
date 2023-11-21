import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetMstMbrCardGroupRs extends BaseMasterDataRs {
  List<MstMbrCardGroup> mstMbrCardGroups;

  GetMstMbrCardGroupRs({this.mstMbrCardGroups});

  GetMstMbrCardGroupRs.fromJson(Map<String, dynamic> json) {
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    if (json['mstMbrCardGroups'] != null) {
      mstMbrCardGroups = new List<MstMbrCardGroup>();
      json['mstMbrCardGroups'].forEach((v) {
        mstMbrCardGroups.add(new MstMbrCardGroup.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    if (this.mstMbrCardGroups != null) {
      data['mstMbrCardGroups'] = this.mstMbrCardGroups.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class MstMbrCardGroup {
  DateTime createDateTime;
  String createUserName;
  bool isDscnt;
  bool isRwd;
  DateTime lastPubDateTime;
  String mbrCardGroupId;
  String mbrCardGroupName;
  List<MstMbrCardGroupDet> mstMbrCardGroupDets;
  String refPubId;
  num seqNo;

  MstMbrCardGroup({this.createDateTime, this.createUserName, this.isDscnt, this.isRwd, this.lastPubDateTime, this.mbrCardGroupId, this.mbrCardGroupName, this.mstMbrCardGroupDets, this.refPubId, this.seqNo});

  MstMbrCardGroup.fromJson(Map<String, dynamic> json) {
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUserName = json['createUserName'];
    isDscnt = json['isDscnt'];
    isRwd = json['isRwd'];
    lastPubDateTime = DateTimeUtil.toDateTime(json['lastPubDateTime']);
    mbrCardGroupId = json['mbrCardGroupId'];
    mbrCardGroupName = json['mbrCardGroupName'];
    if (json['mstMbrCardGroupDetBos'] != null) {
      mstMbrCardGroupDets = new List<MstMbrCardGroupDet>();
      json['mstMbrCardGroupDetBos'].forEach((v) {
        mstMbrCardGroupDets.add(new MstMbrCardGroupDet.fromJson(v));
      });
    }
    refPubId = json['refPubId'];
    seqNo = json['seqNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUserName'] = this.createUserName;
    data['isDscnt'] = this.isDscnt;
    data['isRwd'] = this.isRwd;
    data['lastPubDateTime'] = this.lastPubDateTime?.toIso8601String();
    data['mbrCardGroupId'] = this.mbrCardGroupId;
    data['mbrCardGroupName'] = this.mbrCardGroupName;
    if (this.mstMbrCardGroupDets != null) {
      data['mstMbrCardGroupDetBos'] = this.mstMbrCardGroupDets.map((v) => v.toJson()).toList();
    }
    data['refPubId'] = this.refPubId;
    data['seqNo'] = this.seqNo;
    return data;
  }
}

class MbrCardType {
  DateTime createDateTime;
  String createUser;
  bool discountCard1;
  bool discountCard2;
  DiscountConditionType discountConditionType;
  num isPaymentCard;
  DateTime lastPublishedDateTime;
  List<MstMbrCardGroup> memberCardPrivileges;
  String memberCardTypeId;
  String name;
  bool proCard;
  bool promotionParticipation;
  String referencePublishId;
  bool rewardCard;

  MbrCardType({this.createDateTime, this.createUser, this.discountCard1, this.discountCard2, this.discountConditionType, this.isPaymentCard, this.lastPublishedDateTime, this.memberCardPrivileges, this.memberCardTypeId, this.name, this.proCard, this.promotionParticipation, this.referencePublishId, this.rewardCard});

  MbrCardType.fromJson(Map<String, dynamic> json) {
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUser = json['createUser'];
    discountCard1 = json['discountCard1'];
    discountCard2 = json['discountCard2'];
    discountConditionType = json['discountConditionTypeBo'] != null ? new DiscountConditionType.fromJson(json['discountConditionTypeBo']) : null;
    isPaymentCard = json['isPaymentCard'];
    lastPublishedDateTime = DateTimeUtil.toDateTime(json['lastPublishedDateTime']);
    if (json['memberCardPrivileges'] != null) {
      memberCardPrivileges = new List<MstMbrCardGroup>();
      json['memberCardPrivileges'].forEach((v) {
        memberCardPrivileges.add(new MstMbrCardGroup.fromJson(v));
      });
    }
    memberCardTypeId = json['memberCardTypeId'];
    name = json['name'];
    proCard = json['proCard'];
    promotionParticipation = json['promotionParticipation'];
    referencePublishId = json['referencePublishId'];
    rewardCard = json['rewardCard'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUser'] = this.createUser;
    data['discountCard1'] = this.discountCard1;
    data['discountCard2'] = this.discountCard2;
    if (this.discountConditionType != null) {
      data['discountConditionTypeBo'] = this.discountConditionType.toJson();
    }
    data['isPaymentCard'] = this.isPaymentCard;
    data['lastPublishedDateTime'] = this.lastPublishedDateTime?.toIso8601String();
    if (this.memberCardPrivileges != null) {
      data['memberCardPrivileges'] = this.memberCardPrivileges.map((v) => v.toJson()).toList();
    }
    data['memberCardTypeId'] = this.memberCardTypeId;
    data['name'] = this.name;
    data['proCard'] = this.proCard;
    data['promotionParticipation'] = this.promotionParticipation;
    data['referencePublishId'] = this.referencePublishId;
    data['rewardCard'] = this.rewardCard;
    return data;
  }
}

class DiscountConditionType {
  String description;
  String discountConditionTypeId;
  num discountType;
  bool isPercentDiscount;

  DiscountConditionType({this.description, this.discountConditionTypeId, this.discountType, this.isPercentDiscount});

  DiscountConditionType.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    discountConditionTypeId = json['discountConditionTypeId'];
    discountType = json['discountType'];
    isPercentDiscount = json['isPercentDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['discountConditionTypeId'] = this.discountConditionTypeId;
    data['discountType'] = this.discountType;
    data['isPercentDiscount'] = this.isPercentDiscount;
    return data;
  }
}

class MstMbrCardGroupDet {
  DateTime createDateTime;
  String createUserName;
  String dummyCardNo;
  String image;
  bool isShowImg;
  DateTime lastPubDateTime;
  String mbrCardGrpDetId;
  String mbrCardGrpDetName;
  MbrCardType mbrCardTypeBo;
  MstMbrCardGroup mstMbrCardGroupBo;
  String refPubId;
  num seqNo;

  MstMbrCardGroupDet({this.createDateTime, this.createUserName, this.dummyCardNo, this.image, this.isShowImg, this.lastPubDateTime, this.mbrCardGrpDetId, this.mbrCardGrpDetName, this.mbrCardTypeBo, this.mstMbrCardGroupBo, this.refPubId, this.seqNo});

  MstMbrCardGroupDet.fromJson(Map<String, dynamic> json) {
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUserName = json['createUserName'];
    dummyCardNo = json['dummyCardNo'];
    image = json['image'];
    isShowImg = json['isShowImg'];
    lastPubDateTime = DateTimeUtil.toDateTime(json['lastPubDateTime']);
    mbrCardGrpDetId = json['mbrCardGrpDetId'];
    mbrCardGrpDetName = json['mbrCardGrpDetName'];
    mbrCardTypeBo = json['mbrCardTypeBo'] != null ? new MbrCardType.fromJson(json['mbrCardTypeBo']) : null;
    mstMbrCardGroupBo = json['mstMbrCardGroupBo'] != null ? new MstMbrCardGroup.fromJson(json['mstMbrCardGroupBo']) : null;
    refPubId = json['refPubId'];
    seqNo = json['seqNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUserName'] = this.createUserName;
    data['dummyCardNo'] = this.dummyCardNo;
    data['image'] = this.image;
    data['isShowImg'] = this.isShowImg;
    data['lastPubDateTime'] = this.lastPubDateTime?.toIso8601String();
    data['mbrCardGrpDetId'] = this.mbrCardGrpDetId;
    data['mbrCardGrpDetName'] = this.mbrCardGrpDetName;
    if (this.mbrCardTypeBo != null) {
      data['mbrCardTypeBo'] = this.mbrCardTypeBo.toJson();
    }
    if (this.mstMbrCardGroupBo != null) {
      data['mstMbrCardGroupBo'] = this.mstMbrCardGroupBo.toJson();
    }
    data['refPubId'] = this.refPubId;
    data['seqNo'] = this.seqNo;
    return data;
  }
}
