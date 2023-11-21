import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';
import 'package:intl/intl.dart';

import 'base_bkoffc_webapi_rs.dart';

class SearchPromotionRs extends BaseBackOfficeWebApiRs {
  List<Promotions> promotions;

  SearchPromotionRs({this.promotions});

  SearchPromotionRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['promotions'] != null) {
      promotions = new List<Promotions>();
      json['promotions'].forEach((v) {
        promotions.add(new Promotions.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.promotions != null) {
      data['promotions'] = this.promotions.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Promotions {
  String description;
  DateTime endDate;
  String name;
  String promotionId;
  String promotionOId;
  String promotionTypeId;
  DateTime startDate;

  Promotions({this.description, this.endDate, this.name, this.promotionId, this.promotionOId, this.promotionTypeId, this.startDate});

  Promotions.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    endDate = DateTimeUtil.toDateTime(json['endDate']);
    name = json['name'];
    promotionId = json['promotionId'];
    promotionOId = json['promotionOId'];
    promotionTypeId = json['promotionTypeId'];
    startDate = DateTimeUtil.toDateTime(json['startDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['endDate'] = this.endDate?.toIso8601String();
    data['name'] = this.name;
    data['promotionId'] = this.promotionId;
    data['promotionOId'] = this.promotionOId;
    data['promotionTypeId'] = this.promotionTypeId;
    data['startDate'] = this.startDate?.toIso8601String();
    return data;
  }

  String getDisplayDate() {
    if (this.startDate == null || this.endDate == null) {
      return '';
    }
    return '${new DateFormat("dd/MM/yyyy").format(this.startDate)} - ${new DateFormat("dd/MM/yyyy").format(this.endDate)}';
  }
}
