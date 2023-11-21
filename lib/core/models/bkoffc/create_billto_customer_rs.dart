
import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';

class CreateBillToCustomerRs extends BaseBackOfficeWebApiRs {
  int customerOid;

  CreateBillToCustomerRs({this.customerOid});

  CreateBillToCustomerRs.fromJson(Map<String, dynamic> json) {
    customerOid = json['customerOid'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerOid'] = this.customerOid;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
