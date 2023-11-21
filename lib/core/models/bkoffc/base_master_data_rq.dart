import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class BaseMasterDataRq {
  DateTime lastMasterDataDttm;

  BaseMasterDataRq({this.lastMasterDataDttm});

  BaseMasterDataRq.fromJson(Map<String, dynamic> json) {
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    return data;
  }
}
