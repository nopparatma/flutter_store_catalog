class CrossSellItemRq {
  String articleId;

  CrossSellItemRq({this.articleId});

  CrossSellItemRq.fromJson(Map<String, dynamic> json) {
    articleId = json['ArticleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ArticleId'] = this.articleId;
    return data;
  }
}
