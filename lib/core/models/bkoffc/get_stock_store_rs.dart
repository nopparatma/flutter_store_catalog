import 'base_bkoffc_webapi_rs.dart';
import 'get_stock_rs.dart';

class GetStockStoreRs extends BaseBackOfficeWebApiRs {
  List<StockStores> stockList;

  GetStockStoreRs({this.stockList});

  GetStockStoreRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['stockList'] != null) {
      stockList = new List<StockStores>();
      json['stockList'].forEach((v) {
        stockList.add(new StockStores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.stockList != null) {
      data['stockList'] = this.stockList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}