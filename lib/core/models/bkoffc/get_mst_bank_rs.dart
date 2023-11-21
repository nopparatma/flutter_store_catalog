import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetMstBankRs extends BaseMasterDataRs {
  List<MstBank> mstBanks;

  GetMstBankRs({this.mstBanks});

  GetMstBankRs.fromJson(Map<String, dynamic> json) {
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    if (json['mstBanks'] != null) {
      mstBanks = <MstBank>[];
      json['mstBanks'].forEach((v) {
        mstBanks.add(new MstBank.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    if (this.mstBanks != null) {
      data['mstBanks'] = this.mstBanks.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class MstBank {
  String bankId;
  String bankName;
  DateTime createDateTime;
  String createUserName;
  List<CreditCard> creditCardBos;
  String image;
  DateTime lastPublishedDateTime;
  DateTime lastUpdateDate;
  String lastUpdateUser;
  String referencePublishId;
  num seqNo;
  bool status;

  MstBank({this.bankId, this.bankName, this.createDateTime, this.createUserName, this.creditCardBos, this.image, this.lastPublishedDateTime, this.lastUpdateDate, this.lastUpdateUser, this.referencePublishId, this.seqNo, this.status});

  MstBank.fromJson(Map<String, dynamic> json) {
    bankId = json['bankId'];
    bankName = json['bankName'];
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUserName = json['createUserName'];
    if (json['creditCardBos'] != null) {
      creditCardBos = new List<CreditCard>();
      json['creditCardBos'].forEach((v) {
        creditCardBos.add(new CreditCard.fromJson(v));
      });
    }
    image = json['image'];
    lastPublishedDateTime = DateTimeUtil.toDateTime(json['lastPublishedDateTime']);
    lastUpdateDate = DateTimeUtil.toDateTime(json['lastUpdateDate']);
    lastUpdateUser = json['lastUpdateUser'];
    referencePublishId = json['referencePublishId'];
    seqNo = json['seqNo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankId'] = this.bankId;
    data['bankName'] = this.bankName;
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUserName'] = this.createUserName;
    if (this.creditCardBos != null) {
      data['creditCardBos'] = this.creditCardBos.map((v) => v.toJson()).toList();
    }
    data['image'] = this.image;
    data['lastPublishedDateTime'] = this.lastPublishedDateTime?.toIso8601String();
    data['lastUpdateDate'] = this.lastUpdateDate?.toIso8601String();
    data['lastUpdateUser'] = this.lastUpdateUser;
    data['referencePublishId'] = this.referencePublishId;
    data['seqNo'] = this.seqNo;
    data['status'] = this.status;
    return data;
  }
}

class CreditCard {
  String creditCardId;
  List<CreditCardOption> creditCardOptionLists;
  String creditCardType;
  String mailId;
  String remark;
  String tenderId;
  String tenderName;
  String tenderNo;

  CreditCard({this.creditCardId, this.creditCardOptionLists, this.creditCardType, this.mailId, this.remark, this.tenderId, this.tenderName, this.tenderNo});

  CreditCard.fromJson(Map<String, dynamic> json) {
    creditCardId = json['creditCardId'];
    if (json['creditCardOptionLists'] != null) {
      creditCardOptionLists = new List<CreditCardOption>();
      json['creditCardOptionLists'].forEach((v) {
        creditCardOptionLists.add(new CreditCardOption.fromJson(v));
      });
    }
    creditCardType = json['creditCardType'];
    mailId = json['mailId'];
    remark = json['remark'];
    tenderId = json['tenderId'];
    tenderName = json['tenderName'];
    tenderNo = json['tenderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creditCardId'] = this.creditCardId;
    if (this.creditCardOptionLists != null) {
      data['creditCardOptionLists'] = this.creditCardOptionLists.map((v) => v.toJson()).toList();
    }
    data['creditCardType'] = this.creditCardType;
    data['mailId'] = this.mailId;
    data['remark'] = this.remark;
    data['tenderId'] = this.tenderId;
    data['tenderName'] = this.tenderName;
    data['tenderNo'] = this.tenderNo;
    return data;
  }
}

class CreditCardOption {
  String month;
  String optionId;
  num percentDiscount;

  CreditCardOption({this.month, this.optionId, this.percentDiscount});

  CreditCardOption.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    optionId = json['optionId'];
    percentDiscount = json['percentDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['optionId'] = this.optionId;
    data['percentDiscount'] = this.percentDiscount;
    return data;
  }
}
