class GetArticleRq {
  String storeId;
  String desc;
  num minPrice;
  num maxPrice;
  String category;
  num startRow;
  num pageSize;
  List<GetArticleRqBrandList> brandList;
  List<GetArticleRqFeatureList> featureList;
  List<MCHList> mCHList;
  List<SortList> sortList;
  List<Article> articleList;

  GetArticleRq({
    this.storeId,
    this.desc,
    this.minPrice,
    this.maxPrice,
    this.category,
    this.startRow,
    this.pageSize,
    this.brandList,
    this.featureList,
    this.mCHList,
    this.sortList,
    this.articleList,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StoreId'] = this.storeId;
    data['Desc'] = this.desc;
    data['MinPrice'] = this.minPrice;
    data['MaxPrice'] = this.maxPrice;
    data['Category'] = this.category;
    data['StartRow'] = this.startRow;
    data['PageSize'] = this.pageSize;
    if (this.brandList != null) {
      data['BrandList'] = this.brandList.map((v) => v.toJson()).toList();
    }
    if (this.featureList != null) {
      data['FeatureList'] = this.featureList.map((v) => v.toJson()).toList();
    }
    if (this.mCHList != null) {
      data['MCHList'] = this.mCHList.map((v) => v.toJson()).toList();
    }
    if (this.sortList != null) {
      data['SortList'] = this.sortList.map((v) => v.toJson()).toList();
    }
    if (this.articleList != null) {
      data['ArticleList'] = this.articleList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'GetArticleRq{storeId: $storeId, desc: $desc, minPrice: $minPrice, maxPrice: $maxPrice, category: $category, startRow: $startRow, pageSize: $pageSize, brandList: $brandList, featureList: $featureList, mCHList: $mCHList, sortList: $sortList, articleList: $articleList}';
  }
}

class GetArticleRqBrandList {
  String brandId;

  GetArticleRqBrandList(this.brandId);

  GetArticleRqBrandList.fromJson(Map<String, dynamic> json) {
    brandId = json['BrandId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandId'] = this.brandId;
    return data;
  }
}

class GetArticleRqFeatureList {
  String featureCode;
  String featureDesc;

  GetArticleRqFeatureList(this.featureCode, {this.featureDesc});

  GetArticleRqFeatureList.fromJson(Map<String, dynamic> json) {
    featureCode = json['FeatureCode'];
    featureDesc = json['FeatureDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FeatureCode'] = this.featureCode;
    data['FeatureDesc'] = this.featureDesc;
    return data;
  }
}

class MCHList {
  String mCHId;

  MCHList(this.mCHId);

  MCHList.fromJson(Map<String, dynamic> json) {
    mCHId = json['MCHId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCHId'] = this.mCHId;
    return data;
  }

  @override
  String toString() {
    return 'MCHList{mCHId: $mCHId}';
  }
}

class SortList {
  String sortType;
  String sortBy;

  SortList(this.sortType, this.sortBy);

  SortList.fromJson(Map<String, dynamic> json) {
    sortType = json['SortType'];
    sortBy = json['SortBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SortType'] = this.sortType;
    data['SortBy'] = this.sortBy;
    return data;
  }
}

class Article{
  String articleId;

  Article(this.articleId);

  Article.fromJson(Map<String, dynamic> json) {
    articleId = json['ArticleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ArticleId'] = this.articleId;
    return data;
  }
}
