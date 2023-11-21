
import 'package:flutter_store_catalog/core/models/ecat/base_ecat_rs.dart';

class GetStockRs extends BaseECatRs {
  Stock stock;

  GetStockRs({this.stock});

  GetStockRs.fromJson(Map<String, dynamic> json) {
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
    stock = json['Stock'] != null ? new Stock.fromJson(json['Stock']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    if (this.stock != null) {
      data['Stock'] = this.stock.toJson();
    }
    return data;
  }
}

class Stock {
  List<StockStores> dcStockStores;
  List<StockStores> otherStockStores;
  StockStores storeStockStore;

  Stock({this.dcStockStores, this.otherStockStores, this.storeStockStore});

  Stock.fromJson(Map<String, dynamic> json) {
    if (json['DcStockStores'] != null) {
      dcStockStores = new List<StockStores>();
      json['DcStockStores'].forEach((v) {
        dcStockStores.add(new StockStores.fromJson(v));
      });
    }
    if (json['OtherStockStores'] != null) {
      otherStockStores = new List<StockStores>();
      json['OtherStockStores'].forEach((v) {
        otherStockStores.add(new StockStores.fromJson(v));
      });
    }
    storeStockStore = json['StoreStockStore'] != null ? new StockStores.fromJson(json['StoreStockStore']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dcStockStores != null) {
      data['DcStockStores'] = this.dcStockStores.map((v) => v.toJson()).toList();
    }
    if (this.otherStockStores != null) {
      data['OtherStockStores'] = this.otherStockStores.map((v) => v.toJson()).toList();
    }
    if (this.storeStockStore != null) {
      data['StoreStockStore'] = this.storeStockStore.toJson();
    }
    return data;
  }
}

class StockStores {
  List<StockStoreArticleBos> stockStoreArticleBos;
  String storeId;
  String storeName;

  //Display field
  num saleSetStockAvailableQty;

  StockStores({this.stockStoreArticleBos, this.storeId, this.storeName});

  StockStores.fromJson(Map<String, dynamic> json) {
    if (json['StockStoreArticleBos'] != null) {
      stockStoreArticleBos = new List<StockStoreArticleBos>();
      json['StockStoreArticleBos'].forEach((v) {
        stockStoreArticleBos.add(new StockStoreArticleBos.fromJson(v));
      });
    }
    storeId = json['StoreId'];
    storeName = json['StoreName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stockStoreArticleBos != null) {
      data['StockStoreArticleBos'] = this.stockStoreArticleBos.map((v) => v.toJson()).toList();
    }
    data['StoreId'] = this.storeId;
    data['StoreName'] = this.storeName;
    return data;
  }
}

class StockStoreArticleBos {
  String articleDesc;
  String articleNo;
  num availableQty;
  List<StockStoreBatchs> stockStoreBatchs;
  String unit;
  num urSalesAmt;

  StockStoreArticleBos({this.articleDesc, this.articleNo, this.availableQty, this.stockStoreBatchs, this.unit, this.urSalesAmt});

  StockStoreArticleBos.fromJson(Map<String, dynamic> json) {
    articleDesc = json['ArticleDesc'];
    articleNo = json['ArticleNo'];
    availableQty = json['AvailableQty'];
    if (json['StockStoreBatchs'] != null) {
      stockStoreBatchs = new List<StockStoreBatchs>();
      json['StockStoreBatchs'].forEach((v) {
        stockStoreBatchs.add(new StockStoreBatchs.fromJson(v));
      });
    }
    unit = json['Unit'];
    urSalesAmt = json['UrSalesAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ArticleDesc'] = this.articleDesc;
    data['ArticleNo'] = this.articleNo;
    data['AvailableQty'] = this.availableQty;
    if (this.stockStoreBatchs != null) {
      data['StockStoreBatchs'] = this.stockStoreBatchs.map((v) => v.toJson()).toList();
    }
    data['Unit'] = this.unit;
    data['UrSalesAmt'] = this.urSalesAmt;
    return data;
  }
}

class StockStoreBatchs {
  String batchNo;
  num batchQty;

  StockStoreBatchs({this.batchNo, this.batchQty});

  StockStoreBatchs.fromJson(Map<String, dynamic> json) {
    batchNo = json['BatchNo'];
    batchQty = json['BatchQty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BatchNo'] = this.batchNo;
    data['BatchQty'] = this.batchQty;
    return data;
  }
}
