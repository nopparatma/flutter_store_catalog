class GetItemPromotionDetailRq {
  String articleId;
  String storeId;
  String unit;

  GetItemPromotionDetailRq({this.articleId, this.storeId, this.unit});

  GetItemPromotionDetailRq.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    storeId = json['storeId'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleId'] = this.articleId;
    data['storeId'] = this.storeId;
    data['unit'] = this.unit;
    return data;
  }
}