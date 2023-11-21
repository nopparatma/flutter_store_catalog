import 'base_bkoffc_webapi_rs.dart';

class CancelCollSOSalesCartPaymentRs extends BaseBackOfficeWebApiRs {
  CancelCollSOSalesCartPaymentRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
