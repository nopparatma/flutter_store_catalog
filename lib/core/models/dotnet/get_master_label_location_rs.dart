import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/message_status_rs.dart';

class GetMasterLabelLocationRs extends BaseDotnetWebApiRs {
  String storeId;
  String articleId;
  String articleDescTH;
  String articleDescEN;
  List<ArticleList> articleList;

  GetMasterLabelLocationRs({
    this.storeId,
    this.articleId,
    this.articleDescTH,
    this.articleDescEN,
    this.articleList,
  });

  GetMasterLabelLocationRs.fromJson(Map<String, dynamic> json) {
    storeId = json['StoreId'];
    articleId = json['ArticleId'];
    articleDescTH = json['ArticleDescTH'];
    articleDescEN = json['ArticleDescEN'];
    if (json['ArticleList'] != null) {
      articleList = [];
      json['ArticleList'].forEach((v) {
        articleList.add(new ArticleList.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StoreId'] = this.storeId;
    data['ArticleId'] = this.articleId;
    data['ArticleDescTH'] = this.articleDescTH;
    data['ArticleDescEN'] = this.articleDescEN;
    if (this.articleList != null) {
      data['ArticleList'] = this.articleList.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class ArticleList {
  String mainUPC;
  String uOM;
  List<LocationList> locationList;

  ArticleList({this.mainUPC, this.uOM, this.locationList});

  ArticleList.fromJson(Map<String, dynamic> json) {
    mainUPC = json['MainUPC'];
    uOM = json['UOM'];
    if (json['LocationList'] != null) {
      locationList = [];
      json['LocationList'].forEach((v) {
        locationList.add(new LocationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MainUPC'] = this.mainUPC;
    data['UOM'] = this.uOM;
    if (this.locationList != null) {
      data['LocationList'] = this.locationList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocationList {
  String locationCode;
  String locationDescTH;
  String locationDescEN;

  LocationList({this.locationCode, this.locationDescTH, this.locationDescEN});

  LocationList.fromJson(Map<String, dynamic> json) {
    locationCode = json['LocationCode'];
    locationDescTH = json['LocationDescTH'];
    locationDescEN = json['LocationDescEN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LocationCode'] = this.locationCode;
    data['LocationDescTH'] = this.locationDescTH;
    data['LocationDescEN'] = this.locationDescEN;
    return data;
  }
}
