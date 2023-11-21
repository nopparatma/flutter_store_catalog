import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetAvailableQueueTimesRq {
  DateTime deliveryDate;
  String deliverySite;
  String districtName;
  String integrateDate;
  bool isGroupQueue;
  String jobNo;
  String lat;
  String lon;
  String prdTypeNo;
  String provinceName;
  String reserveQueueMode;
  List<SalesCartItem> salesCartItems;
  String servNo;
  String shipToNo;
  String shippoint;
  String shippointManage;
  String soMode;
  String soldToNo;
  String storeId;
  String subDistrictName;
  String timeNo;
  String timeType;
  String updateBy;
  String updateByEmpName;
  String village;
  String workNo;
  String systemName;

  GetAvailableQueueTimesRq(
      {this.deliveryDate,
        this.deliverySite,
        this.districtName,
        this.integrateDate,
        this.isGroupQueue,
        this.jobNo,
        this.lat,
        this.lon,
        this.prdTypeNo,
        this.provinceName,
        this.reserveQueueMode,
        this.salesCartItems,
        this.servNo,
        this.shipToNo,
        this.shippoint,
        this.shippointManage,
        this.soMode,
        this.soldToNo,
        this.storeId,
        this.subDistrictName,
        this.timeNo,
        this.timeType,
        this.updateBy,
        this.updateByEmpName,
        this.village,
        this.workNo,
        this.systemName});

  GetAvailableQueueTimesRq.fromJson(Map<String, dynamic> json) {
    deliveryDate = DateTimeUtil.toDateTime(json['deliveryDate']);
    deliverySite = json['deliverySite'];
    districtName = json['districtName'];
    integrateDate = json['integrateDate'];
    isGroupQueue = json['isGroupQueue'];
    jobNo = json['jobNo'];
    lat = json['lat'];
    lon = json['lon'];
    prdTypeNo = json['prdTypeNo'];
    provinceName = json['provinceName'];
    reserveQueueMode = json['reserveQueueMode'];
    if (json['salesCartItems'] != null) {
      salesCartItems = new List<SalesCartItem>();
      json['salesCartItems'].forEach((v) {
        salesCartItems.add(new SalesCartItem.fromJson(v));
      });
    }
    servNo = json['servNo'];
    shipToNo = json['shipToNo'];
    shippoint = json['shippoint'];
    shippointManage = json['shippointManage'];
    soMode = json['soMode'];
    soldToNo = json['soldToNo'];
    storeId = json['storeId'];
    subDistrictName = json['subDistrictName'];
    timeNo = json['timeNo'];
    timeType = json['timeType'];
    updateBy = json['updateBy'];
    updateByEmpName = json['updateByEmpName'];
    village = json['village'];
    workNo = json['workNo'];
    systemName = json['systemName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryDate'] = this.deliveryDate?.toIso8601String();
    data['deliverySite'] = this.deliverySite;
    data['districtName'] = this.districtName;
    data['integrateDate'] = this.integrateDate;
    data['isGroupQueue'] = this.isGroupQueue;
    data['jobNo'] = this.jobNo;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['prdTypeNo'] = this.prdTypeNo;
    data['provinceName'] = this.provinceName;
    data['reserveQueueMode'] = this.reserveQueueMode;
    if (this.salesCartItems != null) {
      data['salesCartItems'] =
          this.salesCartItems.map((v) => v.toJson()).toList();
    }
    data['servNo'] = this.servNo;
    data['shipToNo'] = this.shipToNo;
    data['shippoint'] = this.shippoint;
    data['shippointManage'] = this.shippointManage;
    data['soMode'] = this.soMode;
    data['soldToNo'] = this.soldToNo;
    data['storeId'] = this.storeId;
    data['subDistrictName'] = this.subDistrictName;
    data['timeNo'] = this.timeNo;
    data['timeType'] = this.timeType;
    data['updateBy'] = this.updateBy;
    data['updateByEmpName'] = this.updateByEmpName;
    data['village'] = this.village;
    data['workNo'] = this.workNo;
    data['systemName'] = this.systemName;
    return data;
  }
}
