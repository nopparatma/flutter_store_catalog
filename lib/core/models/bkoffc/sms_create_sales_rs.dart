import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';

class SmsCreateSalesRs extends BaseBackOfficeWebApiRs {
  num amount;
  String apikey;
  String currency;
  String mid;
  String name;
  String paymentmethods;
  String posId;
  String referenceId;
  String storeId;
  String urlPayment;

  List<String> cardNetworkCode;
  String qrCodeId;
  String qrCodeData;
  String qrCodeImage;

  SmsCreateSalesRs({
    this.amount,
    this.apikey,
    this.currency,
    this.mid,
    this.name,
    this.paymentmethods,
    this.posId,
    this.referenceId,
    this.storeId,
    this.urlPayment,
    this.cardNetworkCode,
    this.qrCodeId,
    this.qrCodeData,
    this.qrCodeImage,
  });

  SmsCreateSalesRs.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    apikey = json['apikey'];
    currency = json['currency'];
    message = json['message'];
    mid = json['mid'];
    name = json['name'];
    paymentmethods = json['paymentmethods'];
    posId = json['posId'];
    referenceId = json['referenceId'];
    status = json['status'];
    storeId = json['storeId'];
    urlPayment = json['urlPayment'];
    if (json['cardNetworkCode'] != null) {
      cardNetworkCode = json['cardNetworkCode'].cast<String>();
    }
    qrCodeId = json['qrCodeId'];
    qrCodeData = json['qrCodeData'];
    qrCodeImage = json['qrCodeImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['apikey'] = this.apikey;
    data['currency'] = this.currency;
    data['message'] = this.message;
    data['mid'] = this.mid;
    data['name'] = this.name;
    data['paymentmethods'] = this.paymentmethods;
    data['posId'] = this.posId;
    data['referenceId'] = this.referenceId;
    data['status'] = this.status;
    data['storeId'] = this.storeId;
    data['urlPayment'] = this.urlPayment;
    data['cardNetworkCode'] = this.cardNetworkCode;
    data['qrCodeId'] = this.qrCodeId;
    data['qrCodeData'] = this.qrCodeData;
    data['qrCodeImage'] = this.qrCodeImage;
    return data;
  }
}
