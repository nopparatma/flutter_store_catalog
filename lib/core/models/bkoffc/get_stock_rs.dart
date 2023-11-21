import 'base_bkoffc_webapi_rs.dart';

class GetStockRs extends BaseBackOfficeWebApiRs {
  Stock stock;

  GetStockRs({this.stock});

  GetStockRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    stock = json['stock'] != null ? new Stock.fromJson(json['stock']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.stock != null) {
      data['stock'] = this.stock.toJson();
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
    if (json['dcStockStores'] != null) {
      dcStockStores = new List<StockStores>();
      json['dcStockStores'].forEach((v) {
        dcStockStores.add(new StockStores.fromJson(v));
      });
    }
    if (json['otherStockStores'] != null) {
      otherStockStores = new List<StockStores>();
      json['otherStockStores'].forEach((v) {
        otherStockStores.add(new StockStores.fromJson(v));
      });
    }
    storeStockStore = json['storeStockStore'] != null ? new StockStores.fromJson(json['storeStockStore']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dcStockStores != null) {
      data['dcStockStores'] = this.dcStockStores.map((v) => v.toJson()).toList();
    }
    if (this.otherStockStores != null) {
      data['otherStockStores'] = this.otherStockStores.map((v) => v.toJson()).toList();
    }
    if (this.storeStockStore != null) {
      data['storeStockStore'] = this.storeStockStore.toJson();
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
    if (json['stockStoreArticleBos'] != null) {
      stockStoreArticleBos = new List<StockStoreArticleBos>();
      json['stockStoreArticleBos'].forEach((v) {
        stockStoreArticleBos.add(new StockStoreArticleBos.fromJson(v));
      });
    }
    storeId = json['storeId'];
    storeName = json['storeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stockStoreArticleBos != null) {
      data['stockStoreArticleBos'] = this.stockStoreArticleBos.map((v) => v.toJson()).toList();
    }
    data['storeId'] = this.storeId;
    data['storeName'] = this.storeName;
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
    articleDesc = json['articleDesc'];
    articleNo = json['articleNo'];
    availableQty = json['availableQty'];
    if (json['stockStoreBatchs'] != null) {
      stockStoreBatchs = new List<StockStoreBatchs>();
      json['stockStoreBatchs'].forEach((v) {
        stockStoreBatchs.add(new StockStoreBatchs.fromJson(v));
      });
    }
    unit = json['unit'];
    urSalesAmt = json['urSalesAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleDesc'] = this.articleDesc;
    data['articleNo'] = this.articleNo;
    data['availableQty'] = this.availableQty;
    if (this.stockStoreBatchs != null) {
      data['stockStoreBatchs'] = this.stockStoreBatchs.map((v) => v.toJson()).toList();
    }
    data['unit'] = this.unit;
    data['urSalesAmt'] = this.urSalesAmt;
    return data;
  }
}

class StockStoreBatchs {
  String batchNo;
  num batchQty;

  StockStoreBatchs({this.batchNo, this.batchQty});

  StockStoreBatchs.fromJson(Map<String, dynamic> json) {
    batchNo = json['batchNo'];
    batchQty = json['batchQty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batchNo'] = this.batchNo;
    data['batchQty'] = this.batchQty;
    return data;
  }
}
