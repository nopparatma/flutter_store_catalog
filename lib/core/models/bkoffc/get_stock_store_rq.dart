class GetStockStoreRq {
  List<SapArticle> sapArticles;
  String storeId;

  GetStockStoreRq({this.sapArticles, this.storeId});

  GetStockStoreRq.fromJson(Map<String, dynamic> json) {
    if (json['sapArticles'] != null) {
      sapArticles = new List<SapArticle>();
      json['sapArticles'].forEach((v) {
        sapArticles.add(new SapArticle.fromJson(v));
      });
    }
    storeId = json['storeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sapArticles != null) {
      data['sapArticles'] = this.sapArticles.map((v) => v.toJson()).toList();
    }
    data['storeId'] = this.storeId;
    return data;
  }
}

class SapArticle {
  String articleNo;
  String unit;

  SapArticle({this.articleNo, this.unit});

  SapArticle.fromJson(Map<String, dynamic> json) {
    articleNo = json['articleNo'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleNo'] = this.articleNo;
    data['unit'] = this.unit;
    return data;
  }
}