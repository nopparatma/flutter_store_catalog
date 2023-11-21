import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetStoreInfoRs extends BaseBackOfficeWebApiRs {
  Store store;
  DateTime transactionDate;

  GetStoreInfoRs({this.store, this.transactionDate});

  GetStoreInfoRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    transactionDate = DateTimeUtil.toDateTime(json['transactionDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.store != null) {
      data['store'] = this.store.toJson();
    }
    data['transactionDate'] = this.transactionDate?.toIso8601String();
    return data;
  }
}

class Store {
  String address1;
  String faxNo1;
  String name;
  String phoneNo1;
  String storeId;
  String storeIp;
  String taxId;
  String zipCode;

  Store({this.address1, this.faxNo1, this.name, this.phoneNo1, this.storeId, this.storeIp, this.taxId, this.zipCode});

  Store.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    faxNo1 = json['faxNo1'];
    name = json['name'];
    phoneNo1 = json['phoneNo1'];
    storeId = json['storeId'];
    storeIp = json['storeIp'];
    taxId = json['taxId'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['faxNo1'] = this.faxNo1;
    data['name'] = this.name;
    data['phoneNo1'] = this.phoneNo1;
    data['storeId'] = this.storeId;
    data['storeIp'] = this.storeIp;
    data['taxId'] = this.taxId;
    data['zipCode'] = this.zipCode;
    return data;
  }
}
