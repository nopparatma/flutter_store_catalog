import 'package:flutter_store_catalog/core/models/salesprmtn/base_sales_promotion_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/cashier_trn.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/sales_item.dart';

class CalculatePromotionCARs extends BaseSalesPromotionWebApiRs {
  List<CashierTrn> cashierTrns;
  ExceptPromotion exceptPromotion;
  ExceptTender exceptTender;
  LackFreeGoods lackFreeGoods;
  ManyOptionPromotion manyOptionPromotion;
  num netTrnAmt;
  PromotionRedemption promotionRedemption;
  String rsMsgCode;
  String rsMsgDesc;
  String rsStatus;
  List<SalesItem> salesItems;
  List<SuggestTender> suggestTenders;
  num totalDiscountAmt;
  num totalItemDiscountAmt;
  num totalTenderDiscountAmt;
  num totalAllDiscountAmt;
  num totalTrnAmt;
  num unpaidAmt;
  num vatTrnAmt;
  num totalVatAmt;

  CalculatePromotionCARs({
    this.cashierTrns,
    this.exceptPromotion,
    this.exceptTender,
    this.lackFreeGoods,
    this.manyOptionPromotion,
    this.netTrnAmt,
    this.promotionRedemption,
    this.rsMsgCode,
    this.rsMsgDesc,
    this.rsStatus,
    this.salesItems,
    this.suggestTenders,
    this.totalDiscountAmt,
    this.totalTrnAmt,
    this.unpaidAmt,
    this.vatTrnAmt,
    this.totalVatAmt,
  });

  CalculatePromotionCARs.fromJson(Map<String, dynamic> json) {
    if (json['cashierTrns'] != null) {
      cashierTrns = new List<CashierTrn>();
      json['cashierTrns'].forEach((v) {
        cashierTrns.add(new CashierTrn.fromJson(v));
      });
    }
    exceptPromotion = json['exceptPromotion'] != null ? new ExceptPromotion.fromJson(json['exceptPromotion']) : null;
    exceptTender = json['exceptTender'] != null ? new ExceptTender.fromJson(json['exceptTender']) : null;
    lackFreeGoods = json['lackFreeGoods'] != null ? new LackFreeGoods.fromJson(json['lackFreeGoods']) : null;
    manyOptionPromotion = json['manyOptionPromotion'] != null ? new ManyOptionPromotion.fromJson(json['manyOptionPromotion']) : null;
    netTrnAmt = json['netTrnAmt'];
    promotionRedemption = json['promotionRedemption'] != null ? new PromotionRedemption.fromJson(json['promotionRedemption']) : null;
    rsMsgCode = json['rsMsgCode'];
    rsMsgDesc = json['rsMsgDesc'];
    rsStatus = json['rsStatus'];
    if (json['salesItems'] != null) {
      salesItems = new List<SalesItem>();
      json['salesItems'].forEach((v) {
        salesItems.add(new SalesItem.fromJson(v));
      });
    }
    if (json['suggestTenders'] != null) {
      suggestTenders = new List<SuggestTender>();
      json['suggestTenders'].forEach((v) {
        suggestTenders.add(new SuggestTender.fromJson(v));
      });
    }
    totalDiscountAmt = json['totalDiscountAmt'];
    totalItemDiscountAmt = json['totalItemDiscountAmt'];
    totalTenderDiscountAmt = json['totalTenderDiscountAmt'];
    totalAllDiscountAmt = json['totalAllDiscountAmt'];
    totalTrnAmt = json['totalTrnAmt'];
    unpaidAmt = json['unpaidAmt'];
    vatTrnAmt = json['vatTrnAmt'];
    totalVatAmt = json['totalVatAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cashierTrns != null) {
      data['cashierTrns'] = this.cashierTrns.map((v) => v.toJson()).toList();
    }
    if (this.exceptPromotion != null) {
      data['exceptPromotion'] = this.exceptPromotion.toJson();
    }
    if (this.exceptTender != null) {
      data['exceptTender'] = this.exceptTender.toJson();
    }
    if (this.lackFreeGoods != null) {
      data['lackFreeGoods'] = this.lackFreeGoods.toJson();
    }
    if (this.manyOptionPromotion != null) {
      data['manyOptionPromotion'] = this.manyOptionPromotion.toJson();
    }
    data['netTrnAmt'] = this.netTrnAmt;
    if (this.promotionRedemption != null) {
      data['promotionRedemption'] = this.promotionRedemption.toJson();
    }
    data['rsMsgCode'] = this.rsMsgCode;
    data['rsMsgDesc'] = this.rsMsgDesc;
    data['rsStatus'] = this.rsStatus;
    if (this.salesItems != null) {
      data['salesItems'] = this.salesItems.map((v) => v.toJson()).toList();
    }
    if (this.suggestTenders != null) {
      data['suggestTenders'] = this.suggestTenders.map((v) => v.toJson()).toList();
    }
    data['totalDiscountAmt'] = this.totalDiscountAmt;
    data['totalItemDiscountAmt'] = this.totalItemDiscountAmt;
    data['totalTenderDiscountAmt'] = this.totalTenderDiscountAmt;
    data['totalAllDiscountAmt'] = this.totalAllDiscountAmt;
    data['totalTrnAmt'] = this.totalTrnAmt;
    data['unpaidAmt'] = this.unpaidAmt;
    data['vatTrnAmt'] = this.vatTrnAmt;
    data['totalVatAmt'] = this.totalVatAmt;
    return data;
  }
}

class ExceptPromotion {
  List<Promotions> promotions;

  ExceptPromotion({this.promotions});

  ExceptPromotion.fromJson(Map<String, dynamic> json) {
    if (json['promotions'] != null) {
      promotions = new List<Promotions>();
      json['promotions'].forEach((v) {
        promotions.add(new Promotions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.promotions != null) {
      data['promotions'] = this.promotions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Promotions {
  String promotionDesc;
  String promotionId;
  String promotionName;
  List<ExceptPartnerPromotions> exceptPartnerPromotions;

  Promotions({this.exceptPartnerPromotions, this.promotionDesc, this.promotionId, this.promotionName});

  Promotions.fromJson(Map<String, dynamic> json) {
    if (json['exceptPartnerPromotions'] != null) {
      exceptPartnerPromotions = new List<ExceptPartnerPromotions>();
      json['exceptPartnerPromotions'].forEach((v) {
        exceptPartnerPromotions.add(new ExceptPartnerPromotions.fromJson(v));
      });
    }
    promotionDesc = json['promotionDesc'];
    promotionId = json['promotionId'];
    promotionName = json['promotionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.exceptPartnerPromotions != null) {
      data['exceptPartnerPromotions'] = this.exceptPartnerPromotions.map((v) => v.toJson()).toList();
    }
    data['promotionDesc'] = this.promotionDesc;
    data['promotionId'] = this.promotionId;
    data['promotionName'] = this.promotionName;
    return data;
  }
}

class ExceptPartnerPromotions {
  String promotionDesc;
  String promotionId;
  String promotionName;

  ExceptPartnerPromotions({this.promotionDesc, this.promotionId, this.promotionName});

  ExceptPartnerPromotions.fromJson(Map<String, dynamic> json) {
    promotionDesc = json['promotionDesc'];
    promotionId = json['promotionId'];
    promotionName = json['promotionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotionDesc'] = this.promotionDesc;
    data['promotionId'] = this.promotionId;
    data['promotionName'] = this.promotionName;
    return data;
  }
}

class ExceptTender {
  String promotionDesc;
  String promotionId;
  String promotionName;
  List<TenderExcepts> tenderExcepts;

  ExceptTender({this.promotionDesc, this.promotionId, this.promotionName, this.tenderExcepts});

  ExceptTender.fromJson(Map<String, dynamic> json) {
    promotionDesc = json['promotionDesc'];
    promotionId = json['promotionId'];
    promotionName = json['promotionName'];
    if (json['tenderExcepts'] != null) {
      tenderExcepts = new List<TenderExcepts>();
      json['tenderExcepts'].forEach((v) {
        tenderExcepts.add(new TenderExcepts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotionDesc'] = this.promotionDesc;
    data['promotionId'] = this.promotionId;
    data['promotionName'] = this.promotionName;
    if (this.tenderExcepts != null) {
      data['tenderExcepts'] = this.tenderExcepts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TenderExcepts {
  String tenderId;
  String tenderName;
  String tenderNo;

  TenderExcepts({this.tenderId, this.tenderName, this.tenderNo});

  TenderExcepts.fromJson(Map<String, dynamic> json) {
    tenderId = json['tenderId'];
    tenderName = json['tenderName'];
    tenderNo = json['tenderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenderId'] = this.tenderId;
    data['tenderName'] = this.tenderName;
    data['tenderNo'] = this.tenderNo;
    return data;
  }
}

class LackFreeGoods {
  List<LackFreeGoodsOptions> lackFreeGoodsOptions;
  String promotionDesc;
  String promotionId;
  String promotionName;

  LackFreeGoods({this.lackFreeGoodsOptions, this.promotionDesc, this.promotionId, this.promotionName});

  LackFreeGoods.fromJson(Map<String, dynamic> json) {
    if (json['lackFreeGoodsOptions'] != null) {
      lackFreeGoodsOptions = new List<LackFreeGoodsOptions>();
      json['lackFreeGoodsOptions'].forEach((v) {
        lackFreeGoodsOptions.add(new LackFreeGoodsOptions.fromJson(v));
      });
    }
    promotionDesc = json['promotionDesc'];
    promotionId = json['promotionId'];
    promotionName = json['promotionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lackFreeGoodsOptions != null) {
      data['lackFreeGoodsOptions'] = this.lackFreeGoodsOptions.map((v) => v.toJson()).toList();
    }
    data['promotionDesc'] = this.promotionDesc;
    data['promotionId'] = this.promotionId;
    data['promotionName'] = this.promotionName;
    return data;
  }
}

class LackFreeGoodsOptions {
  List<LackFreeGoodsItems> lackFreeGoodsItems;
  num optionOid;

  //DISPLAY FIELD DO NOT ADD THESE FIELD IN fromJson and toJson method
  //addToCartFlag ใช้ในกรณีคำนวณโปรแล้วได้สถานะ W001 แต่มีหลาย option ของแถม
  bool isAddToCartFlag;

  //END DISPLAY FIELD

  LackFreeGoodsOptions({this.lackFreeGoodsItems, this.optionOid});

  LackFreeGoodsOptions.fromJson(Map<String, dynamic> json) {
    if (json['lackFreeGoodsItems'] != null) {
      lackFreeGoodsItems = new List<LackFreeGoodsItems>();
      json['lackFreeGoodsItems'].forEach((v) {
        lackFreeGoodsItems.add(new LackFreeGoodsItems.fromJson(v));
      });
    }
    optionOid = json['optionOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lackFreeGoodsItems != null) {
      data['lackFreeGoodsItems'] = this.lackFreeGoodsItems.map((v) => v.toJson()).toList();
    }
    data['optionOid'] = this.optionOid;
    return data;
  }
}

class LackFreeGoodsItems {
  String promotionArtcDesc;
  String promotionArtcId;
  num qty;
  String unit;

  LackFreeGoodsItems({this.promotionArtcDesc, this.promotionArtcId, this.qty, this.unit});

  LackFreeGoodsItems.fromJson(Map<String, dynamic> json) {
    promotionArtcDesc = json['promotionArtcDesc'];
    promotionArtcId = json['promotionArtcId'];
    qty = json['qty'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotionArtcDesc'] = this.promotionArtcDesc;
    data['promotionArtcId'] = this.promotionArtcId;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    return data;
  }
}

class ManyOptionPromotion {
  String promotionDesc;
  String promotionId;
  String promotionName;
  Tier tier;

  ManyOptionPromotion({this.promotionDesc, this.promotionId, this.promotionName, this.tier});

  ManyOptionPromotion.fromJson(Map<String, dynamic> json) {
    promotionDesc = json['promotionDesc'];
    promotionId = json['promotionId'];
    promotionName = json['promotionName'];
    tier = json['tier'] != null ? new Tier.fromJson(json['tier']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotionDesc'] = this.promotionDesc;
    data['promotionId'] = this.promotionId;
    data['promotionName'] = this.promotionName;
    if (this.tier != null) {
      data['tier'] = this.tier.toJson();
    }
    return data;
  }
}

class Tier {
  List<Options> options;
  num tierOid;
  num tierValue;

  Tier({this.options, this.tierOid, this.tierValue});

  Tier.fromJson(Map<String, dynamic> json) {
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) {
        options.add(new Options.fromJson(v));
      });
    }
    tierOid = json['tierOid'];
    tierValue = json['tierValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    data['tierOid'] = this.tierOid;
    data['tierValue'] = this.tierValue;
    return data;
  }
}

class Options {
  List<OptionItems> optionItems;
  num optionOid;

  Options({this.optionItems, this.optionOid});

  Options.fromJson(Map<String, dynamic> json) {
    if (json['optionItems'] != null) {
      optionItems = new List<OptionItems>();
      json['optionItems'].forEach((v) {
        optionItems.add(new OptionItems.fromJson(v));
      });
    }
    optionOid = json['optionOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.optionItems != null) {
      data['optionItems'] = this.optionItems.map((v) => v.toJson()).toList();
    }
    data['optionOid'] = this.optionOid;
    return data;
  }
}

class OptionItems {
  String articleDesc;
  String articleId;
  String discountCode;
  String discountConditionDesc;
  num discountPremiumPriceValue;
  num discountPriceValue;
  String discountType;
  bool isCMKT;
  bool isDiscountConditionDesc;
  bool isLimitMaxValue;
  bool isReceiveFromCS;
  bool isTenderDiscount;
  bool isThisArticle;
  bool isVendorCoupon;
  num limitMaxValue;
  num limitMinValue;
  num optionItemOid;
  String promotionArtcId;
  String promotionArtcTypeDesc;
  String promotionArtcTypeId;
  num qty;
  String unit;
  String vendorId;
  String vendorName;

  OptionItems({this.articleDesc, this.articleId, this.discountCode, this.discountConditionDesc, this.discountPremiumPriceValue, this.discountPriceValue, this.discountType, this.isCMKT, this.isDiscountConditionDesc, this.isLimitMaxValue, this.isReceiveFromCS, this.isTenderDiscount, this.isThisArticle, this.isVendorCoupon, this.limitMaxValue, this.limitMinValue, this.optionItemOid, this.promotionArtcId, this.promotionArtcTypeDesc, this.promotionArtcTypeId, this.qty, this.unit, this.vendorId, this.vendorName});

  OptionItems.fromJson(Map<String, dynamic> json) {
    articleDesc = json['articleDesc'];
    articleId = json['articleId'];
    discountCode = json['discountCode'];
    discountConditionDesc = json['discountConditionDesc'];
    discountPremiumPriceValue = json['discountPremiumPriceValue'];
    discountPriceValue = json['discountPriceValue'];
    discountType = json['discountType'];
    isCMKT = json['isCMKT'];
    isDiscountConditionDesc = json['isDiscountConditionDesc'];
    isLimitMaxValue = json['isLimitMaxValue'];
    isReceiveFromCS = json['isReceiveFromCS'];
    isTenderDiscount = json['isTenderDiscount'];
    isThisArticle = json['isThisArticle'];
    isVendorCoupon = json['isVendorCoupon'];
    limitMaxValue = json['limitMaxValue'];
    limitMinValue = json['limitMinValue'];
    optionItemOid = json['optionItemOid'];
    promotionArtcId = json['promotionArtcId'];
    promotionArtcTypeDesc = json['promotionArtcTypeDesc'];
    promotionArtcTypeId = json['promotionArtcTypeId'];
    qty = json['qty'];
    unit = json['unit'];
    vendorId = json['vendorId'];
    vendorName = json['vendorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleDesc'] = this.articleDesc;
    data['articleId'] = this.articleId;
    data['discountCode'] = this.discountCode;
    data['discountConditionDesc'] = this.discountConditionDesc;
    data['discountPremiumPriceValue'] = this.discountPremiumPriceValue;
    data['discountPriceValue'] = this.discountPriceValue;
    data['discountType'] = this.discountType;
    data['isCMKT'] = this.isCMKT;
    data['isDiscountConditionDesc'] = this.isDiscountConditionDesc;
    data['isLimitMaxValue'] = this.isLimitMaxValue;
    data['isReceiveFromCS'] = this.isReceiveFromCS;
    data['isTenderDiscount'] = this.isTenderDiscount;
    data['isThisArticle'] = this.isThisArticle;
    data['isVendorCoupon'] = this.isVendorCoupon;
    data['limitMaxValue'] = this.limitMaxValue;
    data['limitMinValue'] = this.limitMinValue;
    data['optionItemOid'] = this.optionItemOid;
    data['promotionArtcId'] = this.promotionArtcId;
    data['promotionArtcTypeDesc'] = this.promotionArtcTypeDesc;
    data['promotionArtcTypeId'] = this.promotionArtcTypeId;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    data['vendorId'] = this.vendorId;
    data['vendorName'] = this.vendorName;
    return data;
  }
}

class PromotionRedemption {
  List<PromotionDiscountRedemptions> promotionDiscountRedemptions;
  List<PromotionNoReceiveRedemptions> promotionNoReceiveRedemptions;
  List<PromotionSales> promotionSales;

  PromotionRedemption({this.promotionDiscountRedemptions, this.promotionNoReceiveRedemptions, this.promotionSales});

  PromotionRedemption.fromJson(Map<String, dynamic> json) {
    if (json['promotionDiscountRedemptions'] != null) {
      promotionDiscountRedemptions = new List<PromotionDiscountRedemptions>();
      json['promotionDiscountRedemptions'].forEach((v) {
        promotionDiscountRedemptions.add(new PromotionDiscountRedemptions.fromJson(v));
      });
    }
    if (json['promotionNoReceiveRedemptions'] != null) {
      promotionNoReceiveRedemptions = new List<PromotionNoReceiveRedemptions>();
      json['promotionNoReceiveRedemptions'].forEach((v) {
        promotionNoReceiveRedemptions.add(new PromotionNoReceiveRedemptions.fromJson(v));
      });
    }
    if (json['promotionSales'] != null) {
      promotionSales = new List<PromotionSales>();
      json['promotionSales'].forEach((v) {
        promotionSales.add(new PromotionSales.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.promotionDiscountRedemptions != null) {
      data['promotionDiscountRedemptions'] = this.promotionDiscountRedemptions.map((v) => v.toJson()).toList();
    }
    if (this.promotionNoReceiveRedemptions != null) {
      data['promotionNoReceiveRedemptions'] = this.promotionNoReceiveRedemptions.map((v) => v.toJson()).toList();
    }
    if (this.promotionSales != null) {
      data['promotionSales'] = this.promotionSales.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromotionDiscountRedemptions {
  num couponQty;
  num discountAmt;
  String discountType;
  String promotionId;
  String vendorId;
  String vendorName;

  PromotionDiscountRedemptions({this.couponQty, this.discountAmt, this.discountType, this.promotionId, this.vendorId, this.vendorName});

  PromotionDiscountRedemptions.fromJson(Map<String, dynamic> json) {
    couponQty = json['couponQty'];
    discountAmt = json['discountAmt'];
    discountType = json['discountType'];
    promotionId = json['promotionId'];
    vendorId = json['vendorId'];
    vendorName = json['vendorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponQty'] = this.couponQty;
    data['discountAmt'] = this.discountAmt;
    data['discountType'] = this.discountType;
    data['promotionId'] = this.promotionId;
    data['vendorId'] = this.vendorId;
    data['vendorName'] = this.vendorName;
    return data;
  }
}

class PromotionNoReceiveRedemptions {
  num eligibleQty;
  String promotionArticleDesc;
  String promotionArticleId;
  String promotionId;
  String unit;

  PromotionNoReceiveRedemptions({this.eligibleQty, this.promotionArticleDesc, this.promotionArticleId, this.promotionId, this.unit});

  PromotionNoReceiveRedemptions.fromJson(Map<String, dynamic> json) {
    eligibleQty = json['eligibleQty'];
    promotionArticleDesc = json['promotionArticleDesc'];
    promotionArticleId = json['promotionArticleId'];
    promotionId = json['promotionId'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eligibleQty'] = this.eligibleQty;
    data['promotionArticleDesc'] = this.promotionArticleDesc;
    data['promotionArticleId'] = this.promotionArticleId;
    data['promotionId'] = this.promotionId;
    data['unit'] = this.unit;
    return data;
  }
}

class PromotionSales {
  num netAmt;
  num netTrnAmt;
  String promotionId;
  String promotionName;
  List<PromotionSalesItems> promotionSalesItems;

  PromotionSales({this.netAmt, this.netTrnAmt, this.promotionId, this.promotionName, this.promotionSalesItems});

  PromotionSales.fromJson(Map<String, dynamic> json) {
    netAmt = json['netAmt'];
    netTrnAmt = json['netTrnAmt'];
    promotionId = json['promotionId'];
    promotionName = json['promotionName'];
    if (json['promotionSalesItems'] != null) {
      promotionSalesItems = new List<PromotionSalesItems>();
      json['promotionSalesItems'].forEach((v) {
        promotionSalesItems.add(new PromotionSalesItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['netAmt'] = this.netAmt;
    data['netTrnAmt'] = this.netTrnAmt;
    data['promotionId'] = this.promotionId;
    data['promotionName'] = this.promotionName;
    if (this.promotionSalesItems != null) {
      data['promotionSalesItems'] = this.promotionSalesItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromotionSalesItems {
  String articleDesc;
  String articleId;
  num eligibleQty;
  String mainUPC;
  String mch3;
  num netAmt;
  String unit;

  PromotionSalesItems({this.articleDesc, this.articleId, this.eligibleQty, this.mainUPC, this.mch3, this.netAmt, this.unit});

  PromotionSalesItems.fromJson(Map<String, dynamic> json) {
    articleDesc = json['articleDesc'];
    articleId = json['articleId'];
    eligibleQty = json['eligibleQty'];
    mainUPC = json['mainUPC'];
    mch3 = json['mch3'];
    netAmt = json['netAmt'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleDesc'] = this.articleDesc;
    data['articleId'] = this.articleId;
    data['eligibleQty'] = this.eligibleQty;
    data['mainUPC'] = this.mainUPC;
    data['mch3'] = this.mch3;
    data['netAmt'] = this.netAmt;
    data['unit'] = this.unit;
    return data;
  }
}

class ItemDiscountManuals {
  String discountTypeId;
  num discountValue;
  String manualDiscountType;
  String remark;

  ItemDiscountManuals({this.discountTypeId, this.discountValue, this.manualDiscountType, this.remark});

  ItemDiscountManuals.fromJson(Map<String, dynamic> json) {
    discountTypeId = json['discountTypeId'];
    discountValue = json['discountValue'];
    manualDiscountType = json['manualDiscountType'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discountTypeId'] = this.discountTypeId;
    data['discountValue'] = this.discountValue;
    data['manualDiscountType'] = this.manualDiscountType;
    data['remark'] = this.remark;
    return data;
  }
}

class ItemDiscounts {
  num discountAmt;
  num discountAmtPerUnit;
  String discountTypeDesc;
  String discountTypeId;
  num discountValue;
  String remark;

  ItemDiscounts({this.discountAmt, this.discountAmtPerUnit, this.discountTypeDesc, this.discountTypeId, this.discountValue, this.remark});

  ItemDiscounts.fromJson(Map<String, dynamic> json) {
    discountAmt = json['discountAmt'];
    discountAmtPerUnit = json['discountAmtPerUnit'];
    discountTypeDesc = json['discountTypeDesc'];
    discountTypeId = json['discountTypeId'];
    discountValue = json['discountValue'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discountAmt'] = this.discountAmt;
    data['discountAmtPerUnit'] = this.discountAmtPerUnit;
    data['discountTypeDesc'] = this.discountTypeDesc;
    data['discountTypeId'] = this.discountTypeId;
    data['discountValue'] = this.discountValue;
    data['remark'] = this.remark;
    return data;
  }
}

class SalesCouponHirePurchase {
  String articleId;
  String cardType;
  String couponNo;
  String dscntCondTypId;
  bool isCalHirePurchase;
  String mailId;
  String month;
  String optionId;
  num percentDscnt;
  String promotionId;
  String tenderId;

  SalesCouponHirePurchase({this.articleId, this.cardType, this.couponNo, this.dscntCondTypId, this.isCalHirePurchase, this.mailId, this.month, this.optionId, this.percentDscnt, this.promotionId, this.tenderId});

  SalesCouponHirePurchase.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    cardType = json['cardType'];
    couponNo = json['couponNo'];
    dscntCondTypId = json['dscntCondTypId'];
    isCalHirePurchase = json['isCalHirePurchase'];
    mailId = json['mailId'];
    month = json['month'];
    optionId = json['optionId'];
    percentDscnt = json['percentDscnt'];
    promotionId = json['promotionId'];
    tenderId = json['tenderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleId'] = this.articleId;
    data['cardType'] = this.cardType;
    data['couponNo'] = this.couponNo;
    data['dscntCondTypId'] = this.dscntCondTypId;
    data['isCalHirePurchase'] = this.isCalHirePurchase;
    data['mailId'] = this.mailId;
    data['month'] = this.month;
    data['optionId'] = this.optionId;
    data['percentDscnt'] = this.percentDscnt;
    data['promotionId'] = this.promotionId;
    data['tenderId'] = this.tenderId;
    return data;
  }
}

class SuggestTender {
  String campaignNo;
  String crCardId;
  String crCardGrp;
  String crCardNoDummy;
  String description;
  String tenderId;
  String imgUrl;
  num trnAmt;

  SuggestTender({this.campaignNo, this.crCardId, this.crCardGrp, this.crCardNoDummy, this.description, this.tenderId, this.imgUrl, this.trnAmt});

  SuggestTender.fromJson(Map<String, dynamic> json) {
    campaignNo = json['campaignNo'];
    crCardId = json['crCardId'];
    crCardGrp = json['crCardGrp'];
    crCardNoDummy = json['crCardNoDummy'];
    description = json['description'];
    tenderId = json['tenderId'];
    imgUrl = json['imgUrl'];
    trnAmt = json['trnAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['campaignNo'] = this.campaignNo;
    data['crCardId'] = this.crCardId;
    data['crCardGrp'] = this.crCardGrp;
    data['crCardNoDummy'] = this.crCardNoDummy;
    data['description'] = this.description;
    data['tenderId'] = this.tenderId;
    data['imgUrl'] = this.imgUrl;
    data['trnAmt'] = this.trnAmt;
    return data;
  }
}
