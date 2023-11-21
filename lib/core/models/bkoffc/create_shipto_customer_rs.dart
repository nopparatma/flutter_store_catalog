
import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';

class CreateShiptoCustomerRs extends BaseBackOfficeWebApiRs {
  int customerOid;

  CreateShiptoCustomerRs({this.customerOid});

  CreateShiptoCustomerRs.fromJson(Map<String, dynamic> json) {
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
