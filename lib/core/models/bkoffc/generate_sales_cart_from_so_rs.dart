import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';

class GenerateSalesCartFromSoRs extends BaseBackOfficeWebApiRs {
  num salesCartOid;

  GenerateSalesCartFromSoRs({this.salesCartOid});

  GenerateSalesCartFromSoRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    salesCartOid = json['salesCartOid'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['salesCartOid'] = this.salesCartOid;
    data['status'] = this.status;
    return data;
  }
}
