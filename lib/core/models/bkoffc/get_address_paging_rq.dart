import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetAddressPagingRq extends BaseMasterDataRq {
  String zipcode;
  String province;
  String district;
  String subDistrict;
  String lang;
  String startRow;
  String pageSize;

  GetAddressPagingRq({this.zipcode, this.province, this.district, this.subDistrict, this.lang, this.startRow, this.pageSize});

  GetAddressPagingRq.fromJson(Map<String, dynamic> json) {

    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    zipcode = json['zipcode'];
    province = json['province'];
    district = json['district'];
    subDistrict = json['subDistrict'];
    lang = json['lang'];
    startRow = json['startRow'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['zipcode'] = this.zipcode;
    data['province'] = this.province;
    data['district'] = this.district;
    data['subDistrict'] = this.subDistrict;
    data['lang'] = this.lang;
    data['startRow'] = this.startRow;
    data['pageSize'] = this.pageSize;
    return data;
  }
}
