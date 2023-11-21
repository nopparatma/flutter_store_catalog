class CompareArticleAttributeRq {
  List<ArticleList> articleList;

  CompareArticleAttributeRq({this.articleList});

  CompareArticleAttributeRq.fromJson(Map<String, dynamic> json) {
    if (json['ArticleList'] != null) {
      articleList = new List<ArticleList>();
      json['ArticleList'].forEach((v) {
        articleList.add(new ArticleList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articleList != null) {
      data['ArticleList'] = this.articleList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArticleList {
  String articleId;

  ArticleList({this.articleId});

  ArticleList.fromJson(Map<String, dynamic> json) {
    articleId = json['ArticleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ArticleId'] = this.articleId;
    return data;
  }
}