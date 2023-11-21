import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/message_status_rs.dart';

class GetExcessProductRs extends BaseDotnetWebApiRs {
  String mch;
  String insProductGPID;
  List<ProductGPList> productGPList;

  GetExcessProductRs({
    this.mch,
    this.insProductGPID,
    this.productGPList,
  });

  GetExcessProductRs.fromJson(Map<String, dynamic> json) {
    mch = json['MCH'];
    insProductGPID = json['InsProductGP_ID'];
    if (json['ProductGPList'] != null) {
      productGPList = [];
      json['ProductGPList'].forEach((v) {
        productGPList.add(new ProductGPList.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCH'] = this.mch;
    data['InsProductGP_ID'] = this.insProductGPID;
    if (this.productGPList != null) {
      data['ProductGPList'] = this.productGPList.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class ProductGPList {
  String insProductGPID;
  String insProductGPName;
  List<ProductList> productList;

  ProductGPList({this.insProductGPID, this.insProductGPName, this.productList});

  ProductGPList.fromJson(Map<String, dynamic> json) {
    insProductGPID = json['InsProductGP_ID'];
    insProductGPName = json['InsProductGPName'];
    if (json['ProductList'] != null) {
      productList = [];
      json['ProductList'].forEach((v) {
        productList.add(new ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InsProductGP_ID'] = this.insProductGPID;
    data['InsProductGPName'] = this.insProductGPName;
    if (this.productList != null) {
      data['ProductList'] = this.productList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductList {
  String insSTDProductID;
  String insSTDProductName;
  num insSTDProductCost;
  String insSTDProductUOM;

  ProductList({this.insSTDProductID, this.insSTDProductName, this.insSTDProductCost, this.insSTDProductUOM});

  ProductList.fromJson(Map<String, dynamic> json) {
    insSTDProductID = json['InsSTDProduct_ID'];
    insSTDProductName = json['InsSTDProductName'];
    insSTDProductCost = json['InsSTDProductCost'];
    insSTDProductUOM = json['InsSTDProductUOM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InsSTDProduct_ID'] = this.insSTDProductID;
    data['InsSTDProductName'] = this.insSTDProductName;
    data['InsSTDProductCost'] = this.insSTDProductCost;
    data['InsSTDProductUOM'] = this.insSTDProductUOM;
    return data;
  }
}
