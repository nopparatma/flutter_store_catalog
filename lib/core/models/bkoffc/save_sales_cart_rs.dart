import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';

class SaveSalesCartRs extends BaseBackOfficeWebApiRs{
  int salesCartOid;
  bool isScatException;

  SaveSalesCartRs({this.salesCartOid, this.isScatException});

  SaveSalesCartRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    salesCartOid = json['salesCartOid'];
    status = json['status'];
    isScatException = json['isScatException'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['salesCartOid'] = this.salesCartOid;
    data['status'] = this.status;
    data['isScatException'] = this.isScatException;
    return data;
  }
}
