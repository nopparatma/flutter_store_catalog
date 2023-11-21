import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetDeliveryMngRs extends BaseMasterDataRs {
  List<DeliveryMng> deliveryMngs;

  GetDeliveryMngRs({this.deliveryMngs});

  GetDeliveryMngRs.fromJson(Map<String, dynamic> json) {
    if (json['deliveryMngBos'] != null) {
      deliveryMngs = new List<DeliveryMng>();
      json['deliveryMngBos'].forEach((v) {
        deliveryMngs.add(new DeliveryMng.fromJson(v));
      });
    }
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deliveryMngs != null) {
      data['deliveryMngBos'] = this.deliveryMngs.map((v) => v.toJson()).toList();
    }
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class DeliveryMng {
  String deliveryMng;
  String description;
  String shippoint;

  DeliveryMng({this.deliveryMng, this.description, this.shippoint});

  DeliveryMng.fromJson(Map<String, dynamic> json) {
    deliveryMng = json['delivery_mng'];
    description = json['description'];
    shippoint = json['shippoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_mng'] = this.deliveryMng;
    data['description'] = this.description;
    data['shippoint'] = this.shippoint;
    return data;
  }
}
