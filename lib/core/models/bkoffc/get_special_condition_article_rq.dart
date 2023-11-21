class GetSpecialConditionArticleRq {
  List<String> articleList;
  String storeId;

  GetSpecialConditionArticleRq({this.articleList, this.storeId});

  GetSpecialConditionArticleRq.fromJson(Map<String, dynamic> json) {
    articleList = json['articleList']?.cast<String>();
    storeId = json['storeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleList'] = this.articleList;
    data['storeId'] = this.storeId;
    return data;
  }
}