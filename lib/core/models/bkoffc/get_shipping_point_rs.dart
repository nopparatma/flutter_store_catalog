import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetShippingPointRs extends BaseMasterDataRs {
  List<ShippingPoint> shippingPoints;

  GetShippingPointRs({this.shippingPoints});

  GetShippingPointRs.fromJson(Map<String, dynamic> json) {
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    if (json['shippingPoints'] != null) {
      shippingPoints = new List<ShippingPoint>();
      json['shippingPoints'].forEach((v) {
        shippingPoints.add(new ShippingPoint.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    if (this.shippingPoints != null) {
      data['shippingPoints'] = this.shippingPoints.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class ShippingPoint {
  bool isActive;
  DateTime lastPublishedDateTime;
  String name;
  String referencePublishId;
  String searchTerm;
  String shippingPointId;

  ShippingPoint({this.isActive, this.lastPublishedDateTime, this.name, this.referencePublishId, this.searchTerm, this.shippingPointId});

  ShippingPoint.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    lastPublishedDateTime = DateTimeUtil.toDateTime(json['lastPublishedDateTime']);
    name = json['name'];
    referencePublishId = json['referencePublishId'];
    searchTerm = json['searchTerm'];
    shippingPointId = json['shippingPointId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isActive'] = this.isActive;
    data['lastPublishedDateTime'] = this.lastPublishedDateTime?.toIso8601String();
    data['name'] = this.name;
    data['referencePublishId'] = this.referencePublishId;
    data['searchTerm'] = this.searchTerm;
    data['shippingPointId'] = this.shippingPointId;
    return data;
  }
}
