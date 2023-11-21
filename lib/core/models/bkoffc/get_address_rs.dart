import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetAddressRs extends BaseMasterDataRs {
  List<AddressList> addressList;

  GetAddressRs({this.addressList});

  GetAddressRs.fromJson(Map<String, dynamic> json) {
    if (json['addressList'] != null) {
      addressList = new List<AddressList>();
      json['addressList'].forEach((v) {
        addressList.add(new AddressList.fromJson(v));
      });
    }
    lastMasterDataDttm = DateTimeUtil.toDateTime(json['lastMasterDataDttm']);
    masterDataStatus = json['masterDataStatus'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressList != null) {
      data['addressList'] = this.addressList.map((v) => v.toJson()).toList();
    }
    data['lastMasterDataDttm'] = this.lastMasterDataDttm?.toIso8601String();
    data['masterDataStatus'] = this.masterDataStatus;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class AddressList {
  String districtEng;
  String districtName;
  String nameEng;
  String nameThai;
  String subDistrictEng;
  String subDistrictName;
  String zipCode;

  AddressList({this.districtEng, this.districtName, this.nameEng, this.nameThai, this.subDistrictEng, this.subDistrictName, this.zipCode});

  AddressList.fromJson(Map<String, dynamic> json) {
    districtEng = json['districtEng'];
    districtName = json['districtName'];
    nameEng = json['nameEng'];
    nameThai = json['nameThai'];
    subDistrictEng = json['subDistrictEng'];
    subDistrictName = json['subDistrictName'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtEng'] = this.districtEng;
    data['districtName'] = this.districtName;
    data['nameEng'] = this.nameEng;
    data['nameThai'] = this.nameThai;
    data['subDistrictEng'] = this.subDistrictEng;
    data['subDistrictName'] = this.subDistrictName;
    data['zipCode'] = this.zipCode;
    return data;
  }
}
