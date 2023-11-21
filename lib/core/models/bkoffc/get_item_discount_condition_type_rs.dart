import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetItemDiscountConditionTypeRs extends BaseMasterDataRs {
  List<DiscountConditionType> discountConditionTypes;

  GetItemDiscountConditionTypeRs({this.discountConditionTypes});

  GetItemDiscountConditionTypeRs.fromJson(Map<String, dynamic> json) {
    if (json['discountConditionTypes'] != null) {
      discountConditionTypes = new List<DiscountConditionType>();
      json['discountConditionTypes'].forEach((v) {
        discountConditionTypes.add(new DiscountConditionType.fromJson(v));
      });
    }
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.discountConditionTypes != null) {
      data['discountConditionTypes'] = this.discountConditionTypes.map((v) => v.toJson()).toList();
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
