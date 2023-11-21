class GetMasterLabelLocationRq {
  String storeId;
  String mainUPC;
  String articleId;
  String uom;

  GetMasterLabelLocationRq({this.storeId, this.mainUPC, this.articleId, this.uom});

  GetMasterLabelLocationRq.fromJson(Map<String, dynamic> json) {
    storeId = json['StoreId'];
    mainUPC = json['MainUPC'];
    articleId = json['ArticleId'];
    uom = json['UOM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StoreId'] = this.storeId;
    data['MainUPC'] = this.mainUPC;
    data['ArticleId'] = this.articleId;
    data['UOM'] = this.uom;
    return data;
  }
}
