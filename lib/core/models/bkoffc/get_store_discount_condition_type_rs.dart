import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetStoreDiscountConditionTypeRs extends BaseMasterDataRs {
  DiscountConditionType discountConditionType;

  GetStoreDiscountConditionTypeRs({this.discountConditionType});

  GetStoreDiscountConditionTypeRs.fromJson(Map<String, dynamic> json) {
    discountConditionType = json['discountConditionType'] != null ? new DiscountConditionType.fromJson(json['discountConditionType']) : null;
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.discountConditionType != null) {
      data['discountConditionType'] = this.discountConditionType.toJson();
    }
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    data['status'] = this.status;
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
