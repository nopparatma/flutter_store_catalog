import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetMainProductTypeByJobTypeRs extends BaseBackOfficeWebApiRs {
  List<MainProductType> mainProductTypes;

  GetMainProductTypeByJobTypeRs({this.mainProductTypes});

  GetMainProductTypeByJobTypeRs.fromJson(Map<String, dynamic> json) {
    if (json['mainProductTypes'] != null) {
      mainProductTypes = new List<MainProductType>();
      json['mainProductTypes'].forEach((v) {
        mainProductTypes.add(new MainProductType.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mainProductTypes != null) {
      data['mainProductTypes'] = this.mainProductTypes.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class MainProductType {
  DateTime createDateTime;
  String description;
  DateTime lastPublishedDateTime;
  String mainProductTypeId;
  String referencePublishId;
  String status;

  MainProductType({this.createDateTime, this.description, this.lastPublishedDateTime, this.mainProductTypeId, this.referencePublishId, this.status});

  MainProductType.fromJson(Map<String, dynamic> json) {
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    description = json['description'];
    lastPublishedDateTime = DateTimeUtil.toDateTime(json['lastPublishedDateTime']);
    mainProductTypeId = json['mainProductTypeId'];
    referencePublishId = json['referencePublishId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['description'] = this.description;
    data['lastPublishedDateTime'] = this.lastPublishedDateTime?.toIso8601String();
    data['mainProductTypeId'] = this.mainProductTypeId;
    data['referencePublishId'] = this.referencePublishId;
    data['status'] = this.status;
    return data;
  }
}
