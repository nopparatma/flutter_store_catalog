import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class SearchCustomerByOidRq {
  num customerOid;
  String store;
  DateTime transactionDate;

  SearchCustomerByOidRq({this.customerOid, this.store, this.transactionDate});

  SearchCustomerByOidRq.fromJson(Map<String, dynamic> json) {
    customerOid = json['customerOid'];
    store = json['store'];
    transactionDate = DateTimeUtil.toDateTime(json['transactionDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerOid'] = this.customerOid;
    data['store'] = this.store;
    data['transactionDate'] = this.transactionDate?.toIso8601String();
    return data;
  }
}