import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetMstCrCardRangeIdRs extends BaseMasterDataRs {
  List<TenderCrCard> tenderCrCards;

  GetMstCrCardRangeIdRs({this.tenderCrCards});

  GetMstCrCardRangeIdRs.fromJson(Map<String, dynamic> json) {
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    status = json['status'];
    if (json['tenderCrCardBos'] != null) {
      tenderCrCards = new List<TenderCrCard>();
      json['tenderCrCardBos'].forEach((v) {
        tenderCrCards.add(new TenderCrCard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.tenderCrCards != null) {
      data['tenderCrCardBos'] = this.tenderCrCards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TenderCrCard {
  String creditCardId;
  String tenderId;
  CreditCardRange creditCardRangeBo;

  TenderCrCard({this.creditCardId, this.creditCardRangeBo, this.tenderId});

  TenderCrCard.fromJson(Map<String, dynamic> json) {
    creditCardId = json['creditCardId'];
    creditCardRangeBo = json['creditCardRangeBo'] != null ? new CreditCardRange.fromJson(json['creditCardRangeBo']) : null;
    tenderId = json['tenderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creditCardId'] = this.creditCardId;
    if (this.creditCardRangeBo != null) {
      data['creditCardRangeBo'] = this.creditCardRangeBo.toJson();
    }
    data['tenderId'] = this.tenderId;
    return data;
  }
}

class CreditCardRange {
  String cardLevel;
  num cardRange;
  String cardType;
  String cardVendor;
  String creditCardId;
  String creditCardRangeId;
  String isShowOnTicket;

  CreditCardRange({this.cardLevel, this.cardRange, this.cardType, this.cardVendor, this.creditCardId, this.creditCardRangeId, this.isShowOnTicket});

  CreditCardRange.fromJson(Map<String, dynamic> json) {
    cardLevel = json['cardLevel'];
    cardRange = json['cardRange'];
    cardType = json['cardType'];
    cardVendor = json['cardVendor'];
    creditCardId = json['creditCardId'];
    creditCardRangeId = json['creditCardRangeId'];
    isShowOnTicket = json['isShowOnTicket'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardLevel'] = this.cardLevel;
    data['cardRange'] = this.cardRange;
    data['cardType'] = this.cardType;
    data['cardVendor'] = this.cardVendor;
    data['creditCardId'] = this.creditCardId;
    data['creditCardRangeId'] = this.creditCardRangeId;
    data['isShowOnTicket'] = this.isShowOnTicket;
    return data;
  }
}
