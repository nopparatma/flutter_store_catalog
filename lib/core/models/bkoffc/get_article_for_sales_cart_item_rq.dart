class GetArticleForSalesCartItemRq {
  bool isCheckStock;
  String searchData;
  String storeId;
  String unit;

  GetArticleForSalesCartItemRq({this.isCheckStock, this.searchData, this.storeId, this.unit});

  GetArticleForSalesCartItemRq.fromJson(Map<String, dynamic> json) {
    isCheckStock = json['isCheckStock'];
    searchData = json['searchData'];
    storeId = json['storeId'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isCheckStock'] = this.isCheckStock;
    data['searchData'] = this.searchData;
    data['storeId'] = this.storeId;
    data['unit'] = this.unit;
    return data;
  }
}