class SearchPromotionRq {
  String articleNo;
  num pagesize;
  num startRow;
  String storeId;
  String unit;

  SearchPromotionRq({this.articleNo, this.pagesize, this.startRow, this.storeId, this.unit});

  SearchPromotionRq.fromJson(Map<String, dynamic> json) {
    articleNo = json['articleNo'];
    pagesize = json['pagesize'];
    startRow = json['startRow'];
    storeId = json['storeId'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleNo'] = this.articleNo;
    data['pagesize'] = this.pagesize;
    data['startRow'] = this.startRow;
    data['storeId'] = this.storeId;
    data['unit'] = this.unit;
    return data;
  }
}