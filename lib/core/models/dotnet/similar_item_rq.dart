class SimilarItemRq {
  String articleId;

  SimilarItemRq({this.articleId});

  SimilarItemRq.fromJson(Map<String, dynamic> json) {
    articleId = json['ArticleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ArticleId'] = this.articleId;
    return data;
  }
}
