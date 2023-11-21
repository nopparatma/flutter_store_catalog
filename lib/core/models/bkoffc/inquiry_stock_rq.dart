class InquiryStockRq {
  String articleId;
  String flagAllSite;
  String storeId;
  String unit;

  InquiryStockRq({this.articleId, this.flagAllSite, this.storeId, this.unit});

  InquiryStockRq.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    flagAllSite = json['flagAllSite'];
    storeId = json['storeId'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleId'] = this.articleId;
    data['flagAllSite'] = this.flagAllSite;
    data['storeId'] = this.storeId;
    data['unit'] = this.unit;
    return data;
  }
}
