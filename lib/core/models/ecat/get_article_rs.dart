import 'package:flutter_store_catalog/core/models/ecat/base_ecat_rs.dart';

class GetArticleRs extends BaseECatRs {
  List<ArticleList> articleList;
  num totalSize;

  GetArticleRs({this.articleList, this.totalSize});

  GetArticleRs.fromJson(Map<String, dynamic> json) {
    if (json['ArticleList'] != null) {
      articleList = new List<ArticleList>();
      json['ArticleList'].forEach((v) {
        articleList.add(new ArticleList.fromJson(v));
      });
    }
    totalSize = json['TotalSize'];
    messageStatusRs = json['MessageStatusRs'] != null ? new MessageStatusRs.fromJson(json['MessageStatusRs']) : null;
  }
}

class ArticleList {
  String articleId;
  String articleNameTH;
  String articleNameEN;
  String articleFullNameTH;
  String articleFullNameEN;
  String brand;
  String mch9;
  String imageCover;
  List<UnitList> unitList;
  List<ImageList> imageList;
  String contentTH;
  String contentEN;
  List<ProductPropertyList> productPropertyList;
  List<ProductUsageList> productUsageList;
  List<ProductTipsList> productTipsList;
  List<ProductSafetyList> productSafetyList;
  List<FeatureList> featureList;
  bool isFreeInstall;

  bool isHaveSpecialPrice() {
    return this.unitList[0] != null ? unitList[0].promotionPrice != null && unitList[0].promotionPrice > 0 : false;
  }

  ArticleList({this.articleId, this.articleNameTH, this.articleNameEN, this.articleFullNameTH, this.articleFullNameEN, this.brand, this.mch9, this.unitList, this.imageList, this.contentTH, this.contentEN, this.productPropertyList, this.productUsageList, this.productTipsList, this.productSafetyList, this.featureList, this.imageCover, this.isFreeInstall});

  ArticleList.fromJson(Map<String, dynamic> json) {
    articleId = json['ArticleId'];
    articleNameTH = json['ArticleNameTH'];
    articleNameEN = json['ArticleNameEN'];
    articleFullNameTH = json['ArticleFullNameTH'];
    articleFullNameEN = json['ArticleFullNameEN'];
    brand = json['Brand'];
    mch9 = json['MCH9'];
    imageCover = json['ImageCover'];
    if (json['UnitList'] != null) {
      unitList = new List<UnitList>();
      json['UnitList'].forEach((v) {
        unitList.add(new UnitList.fromJson(v));
      });
    }
    if (json['ImageList'] != null) {
      imageList = new List<ImageList>();
      json['ImageList'].forEach((v) {
        imageList.add(new ImageList.fromJson(v));
      });
    }
    contentTH = json['ContentTH'];
    contentEN = json['ContentEN'];
    if (json['ProductPropertyList'] != null) {
      productPropertyList = new List<ProductPropertyList>();
      json['ProductPropertyList'].forEach((v) {
        productPropertyList.add(new ProductPropertyList.fromJson(v));
      });
    }
    if (json['ProductUsageList'] != null) {
      productUsageList = new List<ProductUsageList>();
      json['ProductUsageList'].forEach((v) {
        productUsageList.add(new ProductUsageList.fromJson(v));
      });
    }
    if (json['ProductTipsList'] != null) {
      productTipsList = new List<ProductTipsList>();
      json['ProductTipsList'].forEach((v) {
        productTipsList.add(new ProductTipsList.fromJson(v));
      });
    }
    if (json['ProductSafetyList'] != null) {
      productSafetyList = new List<ProductSafetyList>();
      json['ProductSafetyList'].forEach((v) {
        productSafetyList.add(new ProductSafetyList.fromJson(v));
      });
    }
    if (json['FeatureList'] != null) {
      featureList = new List<FeatureList>();
      json['FeatureList'].forEach((v) {
        featureList.add(new FeatureList.fromJson(v));
      });
    }
    isFreeInstall = "Y" == json['IsFreeInstall'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ArticleId'] = this.articleId;
    data['ArticleNameTH'] = this.articleNameTH;
    data['ArticleNameEN'] = this.articleNameEN;
    data['ArticleFullNameTH'] = this.articleFullNameTH;
    data['ArticleFullNameEN'] = this.articleFullNameEN;
    data['Brand'] = this.brand;
    data['MCH9'] = this.mch9;
    data['ImageCover'] = this.imageCover;
    if (this.unitList != null) {
      data['UnitList'] = this.unitList.map((v) => v.toJson()).toList();
    }
    if (this.imageList != null) {
      data['ImageList'] = this.imageList.map((v) => v.toJson()).toList();
    }
    data['ContentTH'] = this.contentTH;
    data['ContentEN'] = this.contentEN;
    if (this.productPropertyList != null) {
      data['ProductPropertyList'] = this.productPropertyList.map((v) => v.toJson()).toList();
    }
    if (this.productUsageList != null) {
      data['ProductUsageList'] = this.productUsageList.map((v) => v.toJson()).toList();
    }
    if (this.productTipsList != null) {
      data['ProductTipsList'] = this.productTipsList.map((v) => v.toJson()).toList();
    }
    if (this.productSafetyList != null) {
      data['ProductSafetyList'] = this.productSafetyList.map((v) => v.toJson()).toList();
    }
    if (this.featureList != null) {
      data['FeatureList'] = this.featureList.map((v) => v.toJson()).toList();
    }

    data['IsFreeInstall'] = this.isFreeInstall ? "Y" : "N";
    return data;
  }
}

class UnitList {
  String mainUPC;
  String unit;
  num normalPrice;
  num promotionPrice;
  num singleSalesPromotionPrice;
  String flagGetFreeGift;
  num discountAmount;

  UnitList({this.mainUPC, this.unit, this.normalPrice, this.promotionPrice, this.singleSalesPromotionPrice, this.flagGetFreeGift, this.discountAmount});

  UnitList.fromJson(Map<String, dynamic> json) {
    mainUPC = json['MainUPC'];
    unit = json['Unit'];
    normalPrice = json['NormalPrice'];
    promotionPrice = json['PromotionPrice'];
    singleSalesPromotionPrice = json['SingleSalesPromotionPrice'];
    flagGetFreeGift = json['FlagGetFreeGift'];
    discountAmount = json['DiscountAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MainUPC'] = this.mainUPC;
    data['Unit'] = this.unit;
    data['NormalPrice'] = this.normalPrice;
    data['PromotionPrice'] = this.promotionPrice;
    data['SingleSalesPromotionPrice'] = this.singleSalesPromotionPrice;
    data['FlagGetFreeGift'] = this.flagGetFreeGift;
    data['DiscountAmount'] = this.discountAmount;
    return data;
  }
}

class ImageList {
  String imageSmall;
  String imageMedium;
  String imageLarge;

  ImageList({this.imageSmall, this.imageMedium, this.imageLarge});

  ImageList.fromJson(Map<String, dynamic> json) {
    imageSmall = json['ImageSmall'];
    imageMedium = json['ImageMedium'];
    imageLarge = json['ImageLarge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ImageSmall'] = this.imageSmall;
    data['ImageMedium'] = this.imageMedium;
    data['ImageLarge'] = this.imageLarge;
    return data;
  }
}

class ProductPropertyList {
  List<ProductPropertyListTH> productPropertyListTH;
  List<ProductPropertyListEN> productPropertyListEN;

  ProductPropertyList({this.productPropertyListTH, this.productPropertyListEN});

  ProductPropertyList.fromJson(Map<String, dynamic> json) {
    if (json['ProductPropertyListTH'] != null) {
      productPropertyListTH = new List<ProductPropertyListTH>();
      json['ProductPropertyListTH'].forEach((v) {
        productPropertyListTH.add(new ProductPropertyListTH.fromJson(v));
      });
    }
    if (json['ProductPropertyListEN'] != null) {
      productPropertyListEN = new List<ProductPropertyListEN>();
      json['ProductPropertyListEN'].forEach((v) {
        productPropertyListEN.add(new ProductPropertyListEN.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productPropertyListTH != null) {
      data['ProductPropertyListTH'] = this.productPropertyListTH.map((v) => v.toJson()).toList();
    }
    if (this.productPropertyListEN != null) {
      data['ProductPropertyListEN'] = this.productPropertyListEN.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductPropertyListTH {
  String productPropertyDesc;

  ProductPropertyListTH({this.productPropertyDesc});

  ProductPropertyListTH.fromJson(Map<String, dynamic> json) {
    productPropertyDesc = json['ProductPropertyDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductPropertyDesc'] = this.productPropertyDesc;
    return data;
  }
}

class ProductPropertyListEN {
  String productPropertyDesc;

  ProductPropertyListEN({this.productPropertyDesc});

  ProductPropertyListEN.fromJson(Map<String, dynamic> json) {
    productPropertyDesc = json['ProductPropertyDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductPropertyDesc'] = this.productPropertyDesc;
    return data;
  }
}

class ProductUsageList {
  List<ProductUsageListTH> productUsageListTH;
  List<ProductUsageListEN> productUsageListEN;

  ProductUsageList({this.productUsageListTH, this.productUsageListEN});

  ProductUsageList.fromJson(Map<String, dynamic> json) {
    if (json['ProductUsageListTH'] != null) {
      productUsageListTH = new List<ProductUsageListTH>();
      json['ProductUsageListTH'].forEach((v) {
        productUsageListTH.add(new ProductUsageListTH.fromJson(v));
      });
    }
    if (json['ProductUsageListEN'] != null) {
      productUsageListEN = new List<ProductUsageListEN>();
      json['ProductUsageListEN'].forEach((v) {
        productUsageListEN.add(new ProductUsageListEN.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productUsageListTH != null) {
      data['ProductUsageListTH'] = this.productUsageListTH.map((v) => v.toJson()).toList();
    }
    if (this.productUsageListEN != null) {
      data['ProductUsageListEN'] = this.productUsageListEN.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductUsageListTH {
  String productUsageDesc;

  ProductUsageListTH({this.productUsageDesc});

  ProductUsageListTH.fromJson(Map<String, dynamic> json) {
    productUsageDesc = json['ProductUsageDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductUsageDesc'] = this.productUsageDesc;
    return data;
  }
}

class ProductUsageListEN {
  String productUsageDesc;

  ProductUsageListEN({this.productUsageDesc});

  ProductUsageListEN.fromJson(Map<String, dynamic> json) {
    productUsageDesc = json['ProductUsageDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductUsageDesc'] = this.productUsageDesc;
    return data;
  }
}

class ProductTipsList {
  List<ProductTipsListTH> productTipsListTH;
  List<ProductTipsListEN> productTipsListEN;

  ProductTipsList({this.productTipsListTH, this.productTipsListEN});

  ProductTipsList.fromJson(Map<String, dynamic> json) {
    if (json['ProductTipsListTH'] != null) {
      productTipsListTH = new List<ProductTipsListTH>();
      json['ProductTipsListTH'].forEach((v) {
        productTipsListTH.add(new ProductTipsListTH.fromJson(v));
      });
    }
    if (json['ProductTipsListEN'] != null) {
      productTipsListEN = new List<ProductTipsListEN>();
      json['ProductTipsListEN'].forEach((v) {
        productTipsListEN.add(new ProductTipsListEN.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productTipsListTH != null) {
      data['ProductTipsListTH'] = this.productTipsListTH.map((v) => v.toJson()).toList();
    }
    if (this.productTipsListEN != null) {
      data['ProductTipsListEN'] = this.productTipsListEN.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductTipsListTH {
  String productTipsDesc;

  ProductTipsListTH({this.productTipsDesc});

  ProductTipsListTH.fromJson(Map<String, dynamic> json) {
    productTipsDesc = json['ProductTipsDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductTipsDesc'] = this.productTipsDesc;
    return data;
  }
}

class ProductTipsListEN {
  String productTipsDesc;

  ProductTipsListEN({this.productTipsDesc});

  ProductTipsListEN.fromJson(Map<String, dynamic> json) {
    productTipsDesc = json['ProductTipsDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductTipsDesc'] = this.productTipsDesc;
    return data;
  }
}

class ProductSafetyList {
  List<ProductSafetyListTH> productSafetyListTH;
  List<ProductSafetyListEN> productSafetyListEN;

  ProductSafetyList({this.productSafetyListTH, this.productSafetyListEN});

  ProductSafetyList.fromJson(Map<String, dynamic> json) {
    if (json['ProductSafetyListTH'] != null) {
      productSafetyListTH = new List<ProductSafetyListTH>();
      json['ProductSafetyListTH'].forEach((v) {
        productSafetyListTH.add(new ProductSafetyListTH.fromJson(v));
      });
    }
    if (json['ProductSafetyListEN'] != null) {
      productSafetyListEN = new List<ProductSafetyListEN>();
      json['ProductSafetyListEN'].forEach((v) {
        productSafetyListEN.add(new ProductSafetyListEN.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productSafetyListTH != null) {
      data['ProductSafetyListTH'] = this.productSafetyListTH.map((v) => v.toJson()).toList();
    }
    if (this.productSafetyListEN != null) {
      data['ProductSafetyListEN'] = this.productSafetyListEN.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductSafetyListTH {
  String productSafetyDesc;

  ProductSafetyListTH({this.productSafetyDesc});

  ProductSafetyListTH.fromJson(Map<String, dynamic> json) {
    productSafetyDesc = json['ProductSafetyDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductSafetyDesc'] = this.productSafetyDesc;
    return data;
  }
}

class ProductSafetyListEN {
  String productSafetyDesc;

  ProductSafetyListEN({this.productSafetyDesc});

  ProductSafetyListEN.fromJson(Map<String, dynamic> json) {
    productSafetyDesc = json['ProductSafetyDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductSafetyDesc'] = this.productSafetyDesc;
    return data;
  }
}

class FeatureList {
  String featureCode;
  String featureNameTH;
  String featureNameEN;
  String featureDescTH;
  String featureDescEN;

  FeatureList({this.featureCode, this.featureNameTH, this.featureNameEN, this.featureDescTH, this.featureDescEN});

  FeatureList.fromJson(Map<String, dynamic> json) {
    featureCode = json['FeatureCode'];
    featureNameTH = json['FeatureNameTH'];
    featureNameEN = json['FeatureNameEN'];
    featureDescTH = json['FeatureDescTH'];
    featureDescEN = json['FeatureDescEN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FeatureCode'] = this.featureCode;
    data['FeatureNameTH'] = this.featureNameTH;
    data['FeatureNameEN'] = this.featureNameEN;
    data['FeatureDescTH'] = this.featureDescTH;
    data['FeatureDescEN'] = this.featureDescEN;
    return data;
  }
}
