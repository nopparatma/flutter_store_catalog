import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class GetHirePurchasePromotionRq {
  List<ArticleList> articleList;
  String creditCardNo;
  String creditCardType;
  String hierarchyType;
  String storeId;
  String tenderNo;
  DateTime tranDate;

  GetHirePurchasePromotionRq({this.articleList, this.creditCardNo, this.creditCardType, this.hierarchyType, this.storeId, this.tenderNo, this.tranDate});

  GetHirePurchasePromotionRq.fromJson(Map<String, dynamic> json) {
    if (json['articleList'] != null) {
      articleList = new List<ArticleList>();
      json['articleList'].forEach((v) {
        articleList.add(new ArticleList.fromJson(v));
      });
    }
    creditCardNo = json['creditCardNo'];
    creditCardType = json['creditCardType'];
    hierarchyType = json['hierarchyType'];
    storeId = json['storeId'];
    tenderNo = json['tenderNo'];
    tranDate = DateTimeUtil.toDateTime(json['tranDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articleList != null) {
      data['articleList'] = this.articleList.map((v) => v.toJson()).toList();
    }
    data['creditCardNo'] = this.creditCardNo;
    data['creditCardType'] = this.creditCardType;
    data['hierarchyType'] = this.hierarchyType;
    data['storeId'] = this.storeId;
    data['tenderNo'] = this.tenderNo;
    data['tranDate'] = this.tranDate?.toIso8601String();
    return data;
  }
}

class ArticleList {
  String articleId;
  num pricePerUnit;
  num qty;
  num seqNo;
  num totalAmount;

  ArticleList({this.articleId, this.pricePerUnit, this.qty, this.seqNo, this.totalAmount});

  ArticleList.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    pricePerUnit = json['pricePerUnit'];
    qty = json['qty'];
    seqNo = json['seqNo'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleId'] = this.articleId;
    data['pricePerUnit'] = this.pricePerUnit;
    data['qty'] = this.qty;
    data['seqNo'] = this.seqNo;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}
