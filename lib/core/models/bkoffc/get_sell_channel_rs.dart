import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';

class GetSellChannelRs extends BaseBackOfficeWebApiRs {
  List<SellChannelLists> sellChannelLists;

  GetSellChannelRs({this.sellChannelLists});

  GetSellChannelRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['sellChannelLists'] != null) {
      sellChannelLists = new List<SellChannelLists>();
      json['sellChannelLists'].forEach((v) {
        sellChannelLists.add(new SellChannelLists.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.sellChannelLists != null) {
      data['sellChannelLists'] = this.sellChannelLists.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class SellChannelLists {
  String distributionChannel;
  bool isActive;
  String salesChannel;
  String salesChannelQuotation;
  String sapOrderCode;
  String sellChannelDesc;
  String sellChannelName;
  int sellChannelOid;
  int sellChannelSeq;
  String storeCoverage;
  String storeGroupCoverage;

  SellChannelLists({this.distributionChannel, this.isActive, this.salesChannel, this.salesChannelQuotation, this.sapOrderCode, this.sellChannelDesc, this.sellChannelName, this.sellChannelOid, this.sellChannelSeq, this.storeCoverage, this.storeGroupCoverage});

  SellChannelLists.fromJson(Map<String, dynamic> json) {
    distributionChannel = json['distributionChannel'];
    isActive = json['isActive'];
    salesChannel = json['salesChannel'];
    salesChannelQuotation = json['salesChannelQuotation'];
    sapOrderCode = json['sapOrderCode'];
    sellChannelDesc = json['sellChannelDesc'];
    sellChannelName = json['sellChannelName'];
    sellChannelOid = json['sellChannelOid'];
    sellChannelSeq = json['sellChannelSeq'];
    storeCoverage = json['storeCoverage'];
    storeGroupCoverage = json['storeGroupCoverage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distributionChannel'] = this.distributionChannel;
    data['isActive'] = this.isActive;
    data['salesChannel'] = this.salesChannel;
    data['salesChannelQuotation'] = this.salesChannelQuotation;
    data['sapOrderCode'] = this.sapOrderCode;
    data['sellChannelDesc'] = this.sellChannelDesc;
    data['sellChannelName'] = this.sellChannelName;
    data['sellChannelOid'] = this.sellChannelOid;
    data['sellChannelSeq'] = this.sellChannelSeq;
    data['storeCoverage'] = this.storeCoverage;
    data['storeGroupCoverage'] = this.storeGroupCoverage;
    return data;
  }
}
