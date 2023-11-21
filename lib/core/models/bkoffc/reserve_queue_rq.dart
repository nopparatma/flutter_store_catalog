import 'package:flutter_store_catalog/core/models/bkoffc/queue_sale.dart';

class ReserveQueueRq {
  String channelCode;
  String districtName;
  String lat;
  String lon;
  String posId;
  String postcode;
  String prdTypeNo;
  String provinceName;
  List<QueueSale> queueSales;
  String reserveManual;
  String servNo;
  String shipToSapId;
  String shippointManage;
  String soMode;
  String soldToSapId;
  String storeId;
  String subDistrictName;
  String ticketNo;
  String transDate;
  String updateBy;
  String updateByEmpName;
  String village;

  ReserveQueueRq({this.channelCode, this.districtName, this.lat, this.lon, this.posId, this.postcode, this.prdTypeNo, this.provinceName, this.queueSales, this.reserveManual, this.servNo, this.shipToSapId, this.shippointManage, this.soMode, this.soldToSapId, this.storeId, this.subDistrictName, this.ticketNo, this.transDate, this.updateBy, this.updateByEmpName, this.village});

  ReserveQueueRq.fromJson(Map<String, dynamic> json) {
    channelCode = json['channelCode'];
    districtName = json['districtName'];
    lat = json['lat'];
    lon = json['lon'];
    posId = json['posId'];
    postcode = json['postcode'];
    prdTypeNo = json['prdTypeNo'];
    provinceName = json['provinceName'];
    if (json['queueSalesBos'] != null) {
      queueSales = new List<QueueSale>();
      json['queueSalesBos'].forEach((v) {
        queueSales.add(new QueueSale.fromJson(v));
      });
    }
    reserveManual = json['reserveManual'];
    servNo = json['servNo'];
    shipToSapId = json['shipToSapId'];
    shippointManage = json['shippointManage'];
    soMode = json['soMode'];
    soldToSapId = json['soldToSapId'];
    storeId = json['storeId'];
    subDistrictName = json['subDistrictName'];
    ticketNo = json['ticketNo'];
    transDate = json['transDate'];
    updateBy = json['updateBy'];
    updateByEmpName = json['updateByEmpName'];
    village = json['village'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelCode'] = this.channelCode;
    data['districtName'] = this.districtName;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['posId'] = this.posId;
    data['postcode'] = this.postcode;
    data['prdTypeNo'] = this.prdTypeNo;
    data['provinceName'] = this.provinceName;
    if (this.queueSales != null) {
      data['queueSalesBos'] = this.queueSales.map((v) => v.toJson()).toList();
    }
    data['reserveManual'] = this.reserveManual;
    data['servNo'] = this.servNo;
    data['shipToSapId'] = this.shipToSapId;
    data['shippointManage'] = this.shippointManage;
    data['soMode'] = this.soMode;
    data['soldToSapId'] = this.soldToSapId;
    data['storeId'] = this.storeId;
    data['subDistrictName'] = this.subDistrictName;
    data['ticketNo'] = this.ticketNo;
    data['transDate'] = this.transDate;
    data['updateBy'] = this.updateBy;
    data['updateByEmpName'] = this.updateByEmpName;
    data['village'] = this.village;
    return data;
  }
}
