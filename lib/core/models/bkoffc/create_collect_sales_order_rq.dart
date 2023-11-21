import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';

class CreateCollectSalesOrderRq {
  String createUserId;
  String createUserName;
  SalesCart salesCart;

  CreateCollectSalesOrderRq({this.createUserId, this.createUserName, this.salesCart});

  CreateCollectSalesOrderRq.fromJson(Map<String, dynamic> json) {
    createUserId = json['createUserId'];
    createUserName = json['createUserName'];
    salesCart = json['salesCartBo'] != null ? new SalesCart.fromJson(json['salesCartBo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createUserId'] = this.createUserId;
    data['createUserName'] = this.createUserName;
    if (this.salesCart != null) {
      data['salesCartBo'] = this.salesCart.toJson();
    }
    return data;
  }
}