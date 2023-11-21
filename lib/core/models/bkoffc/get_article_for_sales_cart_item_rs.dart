import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';
import 'package:intl/intl.dart';

import 'base_bkoffc_webapi_rs.dart';

class GetArticleForSalesCartItemRs extends BaseBackOfficeWebApiRs {
  SearchArticle searchArticle;

  GetArticleForSalesCartItemRs({this.searchArticle});

  GetArticleForSalesCartItemRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    searchArticle = json['searchArticleBo'] != null ? new SearchArticle.fromJson(json['searchArticleBo']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.searchArticle != null) {
      data['searchArticleBo'] = this.searchArticle.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class SearchArticle {
  String accountAssignmentGroup;
  String articleCategoryId;
  String articleDescription;
  List<ArticleFeature> articleFeatures;
  String articleId;
  String articleName;
  List<ArticleSets> articleSets;
  List<ArticleSpecs> articleSpecs;
  String blockCodeId;
  bool isFreeInstallService;
  bool isLotReq;
  bool isPriceRequired;
  bool isQuantityRequired;
  bool isSalesSet;
  String itemUpc;
  String mchId;
  num normalPrice;
  DateTime promotionEndDate;
  num promotionPrice;
  String promotionSapEventNo;
  DateTime promotionStartDate;
  String rpType;
  List<ScalingPrice> scalingPriceBos;
  String sellUnit;
  List<String> unitList;

  SearchArticle({this.accountAssignmentGroup, this.articleCategoryId, this.articleDescription, this.articleFeatures, this.articleId, this.articleName, this.articleSets, this.articleSpecs, this.blockCodeId, this.isFreeInstallService, this.isLotReq, this.isPriceRequired, this.isQuantityRequired, this.isSalesSet, this.itemUpc, this.mchId, this.normalPrice, this.promotionEndDate, this.promotionPrice, this.promotionSapEventNo, this.promotionStartDate, this.rpType, this.scalingPriceBos, this.sellUnit, this.unitList});

  num getUnitPrice() {
    return promotionPrice != null && promotionPrice > 0 ? promotionPrice : normalPrice;
  }

  SearchArticle.fromJson(Map<String, dynamic> json) {
    accountAssignmentGroup = json['accountAssignmentGroup'];
    articleCategoryId = json['articleCategoryId'];
    articleDescription = json['articleDescription'];
    if (json['articleFeatures'] != null) {
      articleFeatures = new List<ArticleFeature>();
      json['articleFeatures'].forEach((v) {
        articleFeatures.add(new ArticleFeature.fromJson(v));
      });
    }
    articleId = json['articleId'];
    articleName = json['articleName'];
    if (json['articleSets'] != null) {
      articleSets = new List<ArticleSets>();
      json['articleSets'].forEach((v) {
        articleSets.add(new ArticleSets.fromJson(v));
      });
    }
    if (json['articleSpecs'] != null) {
      articleSpecs = new List<ArticleSpecs>();
      json['articleSpecs'].forEach((v) {
        articleSpecs.add(new ArticleSpecs.fromJson(v));
      });
    }
    blockCodeId = json['blockCodeId'];
    isFreeInstallService = json['isFreeInstallService'];
    isLotReq = json['isLotReq'];
    isPriceRequired = json['isPriceRequired'];
    isQuantityRequired = json['isQuantityRequired'];
    isSalesSet = json['isSalesSet'];
    itemUpc = json['itemUpc'];
    mchId = json['mchId'];
    normalPrice = json['normalPrice'];
    promotionEndDate = DateTimeUtil.toDateTime(json['promotionEndDate']);
    promotionPrice = json['promotionPrice'];
    promotionSapEventNo = json['promotionSapEventNo'];
    promotionStartDate = DateTimeUtil.toDateTime(json['promotionStartDate']);
    rpType = json['rpType'];
    if (json['scalingPriceBos'] != null) {
      scalingPriceBos = new List<ScalingPrice>();
      json['scalingPriceBos'].forEach((v) {
        scalingPriceBos.add(new ScalingPrice.fromJson(v));
      });
    }
    sellUnit = json['sellUnit'];
    unitList = json['unitList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountAssignmentGroup'] = this.accountAssignmentGroup;
    data['articleCategoryId'] = this.articleCategoryId;
    data['articleDescription'] = this.articleDescription;
    if (this.articleFeatures != null) {
      data['articleFeatures'] = this.articleFeatures.map((v) => v.toJson()).toList();
    }
    data['articleId'] = this.articleId;
    data['articleName'] = this.articleName;
    if (this.articleSets != null) {
      data['articleSets'] = this.articleSets.map((v) => v.toJson()).toList();
    }
    if (this.articleSpecs != null) {
      data['articleSpecs'] = this.articleSpecs.map((v) => v.toJson()).toList();
    }
    data['blockCodeId'] = this.blockCodeId;
    data['isFreeInstallService'] = this.isFreeInstallService;
    data['isLotReq'] = this.isLotReq;
    data['isPriceRequired'] = this.isPriceRequired;
    data['isQuantityRequired'] = this.isQuantityRequired;
    data['isSalesSet'] = this.isSalesSet;
    data['itemUpc'] = this.itemUpc;
    data['mchId'] = this.mchId;
    data['normalPrice'] = this.normalPrice;
    data['promotionEndDate'] = this.promotionEndDate?.toIso8601String();
    data['promotionPrice'] = this.promotionPrice;
    data['promotionSapEventNo'] = this.promotionSapEventNo;
    data['promotionStartDate'] = this.promotionStartDate?.toIso8601String();
    data['rpType'] = this.rpType;
    if (this.scalingPriceBos != null) {
      data['scalingPriceBos'] = this.scalingPriceBos.map((v) => v.toJson()).toList();
    }
    data['sellUnit'] = this.sellUnit;
    data['unitList'] = this.unitList;
    return data;
  }

  String getPromotionDateDisplay() {
    if (this.promotionStartDate == null || this.promotionEndDate == null) {
      return '';
    }
    return '${new DateFormat("dd/MM/yyyy").format(this.promotionStartDate)} - ${new DateFormat("dd/MM/yyyy").format(this.promotionEndDate)}';
//      return '${this.promotionStartDate} - ${this.promotionEndDate}';
  }
}

class ArticleFeature {
  String featureDetail;

  ArticleFeature({this.featureDetail});

  ArticleFeature.fromJson(Map<String, dynamic> json) {
    featureDetail = json['featureDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['featureDetail'] = this.featureDetail;
    return data;
  }
}

class ArticleSets {
  String artcSetId;
  String articleNo;
  String itemDescription;
  num qty;
  String unit;

  ArticleSets({this.artcSetId, this.articleNo, this.itemDescription, this.qty, this.unit});

  ArticleSets.fromJson(Map<String, dynamic> json) {
    artcSetId = json['artcSetId'];
    articleNo = json['articleNo'];
    itemDescription = json['itemDescription'];
    qty = json['qty'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artcSetId'] = this.artcSetId;
    data['articleNo'] = this.articleNo;
    data['itemDescription'] = this.itemDescription;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    return data;
  }
}

class ArticleSpecs {
  String specDescription;
  String specTitle;

  ArticleSpecs({this.specDescription, this.specTitle});

  ArticleSpecs.fromJson(Map<String, dynamic> json) {
    specDescription = json['specDescription'];
    specTitle = json['specTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specDescription'] = this.specDescription;
    data['specTitle'] = this.specTitle;
    return data;
  }
}

class ScalingPrice {
  num qty;
  num unitprice;

  ScalingPrice({this.qty, this.unitprice});

  ScalingPrice.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
    unitprice = json['unitprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qty'] = this.qty;
    data['unitprice'] = this.unitprice;
    return data;
  }
}
