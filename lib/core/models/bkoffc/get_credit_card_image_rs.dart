import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetCreditCardImageRs extends BaseMasterDataRs {
  List<CreditCardImage> creditCardImages;

  GetCreditCardImageRs({this.creditCardImages});

  GetCreditCardImageRs.fromJson(Map<String, dynamic> json) {
    if (json['creditCardImages'] != null) {
      creditCardImages = new List<CreditCardImage>();
      json['creditCardImages'].forEach((v) {
        creditCardImages.add(new CreditCardImage.fromJson(v));
      });
    }
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.creditCardImages != null) {
      data['creditCardImages'] = this.creditCardImages.map((v) => v.toJson()).toList();
    }
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class CreditCardImage {
  DateTime createDateTime;
  String createUserName;
  String creditCardDesc;
  String creditCardId;
  String creditCardImg;
  DateTime lastPubDateTime;
  String refPubId;

  CreditCardImage({this.createDateTime, this.createUserName, this.creditCardDesc, this.creditCardId, this.creditCardImg, this.lastPubDateTime, this.refPubId});

  CreditCardImage.fromJson(Map<String, dynamic> json) {
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUserName = json['createUserName'];
    creditCardDesc = json['creditCardDesc'];
    creditCardId = json['creditCardId'];
    creditCardImg = json['creditCardImg'];
    lastPubDateTime = DateTimeUtil.toDateTime(json['lastPubDateTime']);
    refPubId = json['refPubId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUserName'] = this.createUserName;
    data['creditCardDesc'] = this.creditCardDesc;
    data['creditCardId'] = this.creditCardId;
    data['creditCardImg'] = this.creditCardImg;
    data['lastPubDateTime'] = this.lastPubDateTime?.toIso8601String();
    data['refPubId'] = this.refPubId;
    return data;
  }
}
