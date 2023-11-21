import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';

class SaveSalesCartRq {
  SalesCart salesCartBo;

  SaveSalesCartRq({this.salesCartBo});

  SaveSalesCartRq.fromJson(Map<String, dynamic> json) {
    salesCartBo = json['salesCartBo'] != null ? new SalesCart.fromJson(json['salesCartBo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.salesCartBo != null) {
      data['salesCartBo'] = this.salesCartBo.toJson();
    }
    return data;
  }
}