class GetTopWorkerRq {
  List<GetTopWorkerRqArticle> articleList;
  String jobType;
  String shiptoNo;

  GetTopWorkerRq({this.articleList, this.jobType, this.shiptoNo});

  GetTopWorkerRq.fromJson(Map<String, dynamic> json) {
    if (json['articleList'] != null) {
      articleList = new List<GetTopWorkerRqArticle>();
      json['articleList'].forEach((v) {
        articleList.add(new GetTopWorkerRqArticle.fromJson(v));
      });
    }
    jobType = json['jobType'];
    shiptoNo = json['shiptoNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articleList != null) {
      data['articleList'] = this.articleList.map((v) => v.toJson()).toList();
    }
    data['jobType'] = this.jobType;
    data['shiptoNo'] = this.shiptoNo;
    return data;
  }
}

class GetTopWorkerRqArticle {
  String article;

  GetTopWorkerRqArticle({this.article});

  GetTopWorkerRqArticle.fromJson(Map<String, dynamic> json) {
    article = json['article'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['article'] = this.article;
    return data;
  }
}
