class GetStockRq {
  bool isAllSite;
  bool isStock;
  String itemUpc;
  List<SapArticles> sapArticles;
  String storeId;

  GetStockRq(
      {this.isAllSite,
        this.isStock,
        this.itemUpc,
        this.sapArticles,
        this.storeId});

  GetStockRq.fromJson(Map<String, dynamic> json) {
    isAllSite = json['isAllSite'];
    isStock = json['isStock'];
    itemUpc = json['itemUpc'];
    if (json['sapArticles'] != null) {
      sapArticles = new List<SapArticles>();
      json['sapArticles'].forEach((v) {
        sapArticles.add(new SapArticles.fromJson(v));
      });
    }
    storeId = json['storeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isAllSite'] = this.isAllSite;
    data['isStock'] = this.isStock;
    data['itemUpc'] = this.itemUpc;
    if (this.sapArticles != null) {
      data['sapArticles'] = this.sapArticles.map((v) => v.toJson()).toList();
    }
    data['storeId'] = this.storeId;
    return data;
  }
}

class SapArticles {
  String articleName;
  String articleNo;
  String unit;

  SapArticles({this.articleName, this.articleNo, this.unit});

  SapArticles.fromJson(Map<String, dynamic> json) {
    articleName = json['articleName'];
    articleNo = json['articleNo'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleName'] = this.articleName;
    data['articleNo'] = this.articleNo;
    data['unit'] = this.unit;
    return data;
  }
}
