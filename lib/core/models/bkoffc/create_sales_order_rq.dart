import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';

class CreateSalesOrderRq {
  String channelCode;
  bool isGroupQueue;
  List<SalesCartItem> deleteSalesCartItems;
  String lat;
  String lon;
  String prdTypeNo;
  String reserveManual;
  SalesCart salesCart;
  List<SalesOrder> salesOrders;
  String servNo;
  String shippointManage;
  String soMode;
  String updateBy;
  String updateByEmpName;
  String village;
  String systemName;

  CreateSalesOrderRq({this.channelCode, this.isGroupQueue, this.deleteSalesCartItems, this.lat, this.lon, this.prdTypeNo, this.reserveManual, this.salesCart, this.salesOrders, this.servNo, this.shippointManage, this.soMode, this.updateBy, this.updateByEmpName, this.village, this.systemName});

  CreateSalesOrderRq.fromJson(Map<String, dynamic> json) {
    channelCode = json['channelCode'];
    isGroupQueue = json['isGroupQueue'];
    if (json['deleteSalesCartItems'] != null) {
      deleteSalesCartItems = new List<SalesCartItem>();
      json['deleteSalesCartItems'].forEach((v) { deleteSalesCartItems.add(new SalesCartItem.fromJson(v)); });
    }
    lat = json['lat'];
    lon = json['lon'];
    prdTypeNo = json['prdTypeNo'];
    reserveManual = json['reserveManual'];
    salesCart = json['salesCart'] != null ? new SalesCart.fromJson(json['salesCart']) : null;
    if (json['salesOrders'] != null) {
      salesOrders = new List<SalesOrder>();
      json['salesOrders'].forEach((v) { salesOrders.add(new SalesOrder.fromJson(v)); });
    }
    servNo = json['servNo'];
    shippointManage = json['shippointManage'];
    soMode = json['soMode'];
    updateBy = json['updateBy'];
    updateByEmpName = json['updateByEmpName'];
    village = json['village'];
    systemName = json['systemName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelCode'] = this.channelCode;
    data['isGroupQueue'] = this.isGroupQueue;
    if (this.deleteSalesCartItems != null) {
      data['deleteSalesCartItems'] = this.deleteSalesCartItems.map((v) => v.toJson()).toList();
    }
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['prdTypeNo'] = this.prdTypeNo;
    data['reserveManual'] = this.reserveManual;
    if (this.salesCart != null) {
      data['salesCart'] = this.salesCart.toJson();
    }
    if (this.salesOrders != null) {
      data['salesOrders'] = this.salesOrders.map((v) => v.toJson()).toList();
    }
    data['servNo'] = this.servNo;
    data['shippointManage'] = this.shippointManage;
    data['soMode'] = this.soMode;
    data['updateBy'] = this.updateBy;
    data['updateByEmpName'] = this.updateByEmpName;
    data['village'] = this.village;
    data['systemName'] = this.systemName;
    return data;
  }
}