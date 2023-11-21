import 'package:flutter_store_catalog/core/models/ecat/base_ecat_rs.dart';

class GetArticleFilterRs extends BaseECatRs {
  num minPrice;
  num maxPrice;
  List<BrandList> brandList;
  List<CategoryList> categoryList;
  List<FeatureList> featureList;

  num selectedMinPrice;
  num selectedMaxPrice;
  bool isLessMore = false;
  bool isMoreLess = false;

  GetArticleFilterRs({this.minPrice, this.maxPrice, this.brandList, this.categoryList});

  GetArticleFilterRs.fromJson(Map<String, dynamic> json) {
    minPrice = json['MinPrice'];
    maxPrice = json['MaxPrice'];
    if (json['BrandList'] != null) {
      brandList = new List<BrandList>();
      json['BrandList'].forEach((v) {
        brandList.add(new BrandList.fromJson(v));
      });
    }
    if (json['CategoryList'] != null) {
      categoryList = new List<CategoryList>();
      json['CategoryList'].forEach((v) {
        categoryList.add(new CategoryList.fromJson(v));
      });
    }
    if (json['FeatureList'] != null) {
      featureList = new List<FeatureList>();
      json['FeatureList'].forEach((v) {
        featureList.add(new FeatureList.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }
}

class BrandList {
  String brandId;

  bool isSelected = false;

  BrandList({
    this.brandId,
  });

  BrandList.fromJson(Map<String, dynamic> json) {
    brandId = json['BrandId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandId'] = this.brandId;
    return data;
  }
}

class CategoryList {
  String categoryId;
  String categoryTH;
  String categoryEN;
  List<SearchTermList> searchTermList;

  bool isSelected = false;

  CategoryList({this.categoryId, this.categoryTH, this.categoryEN});

  CategoryList.fromJson(Map<String, dynamic> json) {
    categoryId = json['CategoryId'];
    categoryTH = json['CategoryTH'];
    categoryEN = json['CategoryEN'];
    if (json['SearchTermList'] != null) {
      searchTermList = new List<SearchTermList>();
      json['SearchTermList'].forEach((v) {
        searchTermList.add(new SearchTermList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoryId'] = this.categoryId;
    data['CategoryTH'] = this.categoryTH;
    data['CategoryEN'] = this.categoryEN;
    return data;
  }
}

class SearchTermList{
  String mchId;

  SearchTermList({this.mchId});

  SearchTermList.fromJson(Map<String, dynamic> json) {
    mchId = json['MCHId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCHId'] = this.mchId;
    return data;
  }
}

class FeatureList {
  String featureCode;
  String featureNameTH;
  String featureNameEN;
  List<FeatureDescList> featureDescList;

  FeatureList(
      {this.featureCode,
        this.featureNameTH,
        this.featureNameEN,
        this.featureDescList});

  FeatureList.fromJson(Map<String, dynamic> json) {
    featureCode = json['FeatureCode'];
    featureNameTH = json['FeatureNameTH'];
    featureNameEN = json['FeatureNameEN'];
    if (json['FeatureDescList'] != null) {
      featureDescList = new List<FeatureDescList>();
      json['FeatureDescList'].forEach((v) {
        featureDescList.add(new FeatureDescList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FeatureCode'] = this.featureCode;
    data['FeatureNameTH'] = this.featureNameTH;
    data['FeatureNameEN'] = this.featureNameEN;
    if (this.featureDescList != null) {
      data['FeatureDescList'] =
          this.featureDescList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeatureDescList {
  String featureDescTH;
  String featureDescEN;

  bool isSelected = false;

  FeatureDescList({this.featureDescTH, this.featureDescEN});

  FeatureDescList.fromJson(Map<String, dynamic> json) {
    featureDescTH = json['FeatureDescTH'];
    featureDescEN = json['FeatureDescEN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FeatureDescTH'] = this.featureDescTH;
    data['FeatureDescEN'] = this.featureDescEN;
    return data;
  }
}
