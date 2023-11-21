import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';

class GetSalesCartByOidRs extends BaseBackOfficeWebApiRs {
  SalesCart salesCart;

  GetSalesCartByOidRs({this.salesCart});

  GetSalesCartByOidRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    salesCart = json['salesCart'] != null ? new SalesCart.fromJson(json['salesCart']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.salesCart != null) {
      data['salesCart'] = this.salesCart.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}
