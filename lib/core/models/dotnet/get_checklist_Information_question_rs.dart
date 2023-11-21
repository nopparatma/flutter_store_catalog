import 'package:flutter_store_catalog/core/models/base_dotnet_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rs.dart';
import 'package:flutter_store_catalog/core/models/message_status_rs.dart';
import 'package:flutter_store_catalog/core/utilities/math_util.dart';

class GetCheckListInformationQuestionRs extends BaseDotnetWebApiRs {
  String mch;
  String articleID;
  String insMapping;
  List<ResidenceList> residenceList;
  List<PatternList> patternList;
  List<StandardList> standardList;

  GetCheckListInformationQuestionRs({
    this.mch,
    this.articleID,
    this.insMapping,
    this.residenceList,
    this.patternList,
    this.standardList,
  });

  GetCheckListInformationQuestionRs.fromJson(Map<String, dynamic> json) {
    mch = json['MCH'];
    articleID = json['ArticleID'];
    insMapping = json['InsMapping'];
    if (json['ResidenceList'] != null) {
      residenceList = [];
      json['ResidenceList'].forEach((v) {
        residenceList.add(new ResidenceList.fromJson(v));
      });
    }
    if (json['PatternList'] != null) {
      patternList = [];
      json['PatternList'].forEach((v) {
        patternList.add(new PatternList.fromJson(v));
      });
    }
    if (json['StandardList'] != null) {
      standardList = [];
      json['StandardList'].forEach((v) {
        standardList.add(new StandardList.fromJson(v));
      });
    }
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCH'] = this.mch;
    data['ArticleID'] = this.articleID;
    data['InsMapping'] = this.insMapping;
    if (this.residenceList != null) {
      data['ResidenceList'] = this.residenceList.map((v) => v.toJson()).toList();
    }
    if (this.patternList != null) {
      data['PatternList'] = this.patternList.map((v) => v.toJson()).toList();
    }
    if (this.standardList != null) {
      data['StandardList'] = this.standardList.map((v) => v.toJson()).toList();
    }
    if (this.messageStatusRs != null) {
      data['MessageStatusRs'] = this.messageStatusRs.toJson();
    }
    return data;
  }
}

class ResidenceList {
  String insResidenceID;
  String insResidenceName;
  bool isSelected;

  ResidenceList({this.insResidenceID, this.insResidenceName, this.isSelected = false});

  ResidenceList.fromJson(Map<String, dynamic> json) {
    insResidenceID = json['InsResidence_ID'];
    insResidenceName = json['InsResidenceName'];
    isSelected = json['IsSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InsResidence_ID'] = this.insResidenceID;
    data['InsResidenceName'] = this.insResidenceName;
    data['IsSelected'] = this.isSelected;
    return data;
  }
}

class PatternList {
  String insPatternID;
  String insPatternName;
  String insPatternType;
  String insPatternFormat;
  String insPatternMore;
  bool isSelected;
  List<ArticleList> articleList;
  List<ArtServiceList> artServiceList;
  List<ProductGPList> productGPList;
  List<PicList> picList;

  PatternList({this.insPatternID, this.insPatternName, this.insPatternType, this.insPatternFormat, this.insPatternMore, this.articleList, this.artServiceList, this.productGPList, this.picList, this.isSelected = false});

  num getCost() {
    return artServiceList.fold(0, (previousValue, element) => MathUtil.add(previousValue, (element.searchArticle.getUnitPrice() ?? 0))) ?? 0;
  }

  bool checkHaveSearchArticle() {
    for (ArtServiceList artService in artServiceList) {
      if (artService.searchArticle == null) return false;
    }

    return true;
  }

  PatternList.fromJson(Map<String, dynamic> json) {
    insPatternID = json['InsPattern_ID'];
    insPatternName = json['InsPatternName'];
    insPatternType = json['InsPatternType'];
    insPatternFormat = json['InsPatternFormat'];
    insPatternMore = json['InsPatternMore'];
    isSelected = json['IsSelected'];
    if (json['ArticleList'] != null) {
      articleList = [];
      json['ArticleList'].forEach((v) {
        articleList.add(new ArticleList.fromJson(v));
      });
    }
    if (json['ArtServiceList'] != null) {
      artServiceList = [];
      json['ArtServiceList'].forEach((v) {
        artServiceList.add(new ArtServiceList.fromJson(v));
      });
    }
    if (json['ProductGPList'] != null) {
      productGPList = [];
      json['ProductGPList'].forEach((v) {
        productGPList.add(new ProductGPList.fromJson(v));
      });
    }
    if (json['PicList'] != null) {
      picList = [];
      json['PicList'].forEach((v) {
        picList.add(new PicList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InsPattern_ID'] = this.insPatternID;
    data['InsPatternName'] = this.insPatternName;
    data['InsPatternType'] = this.insPatternType;
    data['InsPatternFormat'] = this.insPatternFormat;
    data['InsPatternMore'] = this.insPatternMore;
    data['IsSelected'] = this.isSelected;
    if (this.articleList != null) {
      data['ArticleList'] = this.articleList.map((v) => v.toJson()).toList();
    }
    if (this.artServiceList != null) {
      data['ArtServiceList'] = this.artServiceList.map((v) => v.toJson()).toList();
    }
    if (this.productGPList != null) {
      data['ProductGPList'] = this.productGPList.map((v) => v.toJson()).toList();
    }
    if (this.picList != null) {
      data['PicList'] = this.picList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArticleList {
  String artcID;

  ArticleList({this.artcID});

  ArticleList.fromJson(Map<String, dynamic> json) {
    artcID = json['ArtcID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ArtcID'] = this.artcID;
    return data;
  }
}

class ArtServiceList {
  String artcID;
  SearchArticle searchArticle;

  ArtServiceList({this.artcID});

  ArtServiceList.fromJson(Map<String, dynamic> json) {
    artcID = json['ArtcID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ArtcID'] = this.artcID;
    return data;
  }
}

class ProductGPList {
  String insProductGPID;
  String insProductGPName;
  List<ProductList> productList;

  ProductGPList({this.insProductGPID, this.insProductGPName, this.productList});

  ProductGPList.fromJson(Map<String, dynamic> json) {
    insProductGPID = json['InsProductGP_ID'];
    insProductGPName = json['InsProductGPName'];
    if (json['ProductList'] != null) {
      productList = [];
      json['ProductList'].forEach((v) {
        productList.add(new ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InsProductGP_ID'] = this.insProductGPID;
    data['InsProductGPName'] = this.insProductGPName;
    if (this.productList != null) {
      data['ProductList'] = this.productList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductList {
  String insSTDProductID;
  String insSTDProductName;
  num insSTDProductUsed;
  String insSTDProductUOM;

  ProductList({this.insSTDProductID, this.insSTDProductName, this.insSTDProductUsed, this.insSTDProductUOM});

  ProductList.fromJson(Map<String, dynamic> json) {
    insSTDProductID = json['InsSTDProduct_ID'];
    insSTDProductName = json['InsSTDProductName'];
    insSTDProductUsed = json['InsSTDProductUsed'];
    insSTDProductUOM = json['InsSTDProductUOM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InsSTDProduct_ID'] = this.insSTDProductID;
    data['InsSTDProductName'] = this.insSTDProductName;
    data['InsSTDProductUsed'] = this.insSTDProductUsed;
    data['InsSTDProductUOM'] = this.insSTDProductUOM;
    return data;
  }
}

class PicList {
  String picUrl;

  PicList({this.picUrl});

  PicList.fromJson(Map<String, dynamic> json) {
    picUrl = json['PicUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PicUrl'] = this.picUrl;
    return data;
  }
}

class StandardList {
  String insStandardID;
  String insStandardName;
  String insStandardDetail;

  StandardList({this.insStandardID, this.insStandardName, this.insStandardDetail});

  StandardList.fromJson(Map<String, dynamic> json) {
    insStandardID = json['InsStandard_ID'];
    insStandardName = json['InsStandardName'];
    insStandardDetail = json['InsStandardDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InsStandard_ID'] = this.insStandardID;
    data['InsStandardName'] = this.insStandardName;
    data['InsStandardDetail'] = this.insStandardDetail;
    return data;
  }
}
