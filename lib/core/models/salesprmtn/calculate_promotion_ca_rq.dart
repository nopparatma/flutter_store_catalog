import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/cashier_trn.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/sales_item.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class CalculatePromotionCARq {
  List<SalesItemDiscountManual> afterTotalAllItemDiscountManuals;
  List<SalesItemDiscountManual> beforeTotalAllItemDiscountManuals;
  String appId;
  List<CashierTrn> cashierTrns;
  String customerSapId;
  MemberCard memberCard;
  List<SalesItem> salesItems;
  String salesOrderTypeId;
  String salesTypeId;
  SelectExceptPromotion selectExceptPromotion;
  SelectExceptTender selectExceptTender;
  SelectLackFreeGoods selectLackFreeGoods;
  SelectManyOptionPromotion selectManyOptionPromotion;
  String storeId;
  List<TriggerCouponPromotion> triggerCouponPromotions;
  DateTime trnDate;
  DateTime startCalculateDateTime;
  List<SuggestTender> suggestTenders;
  bool isSkipWarning;

  CalculatePromotionCARq({
    this.afterTotalAllItemDiscountManuals,
    this.beforeTotalAllItemDiscountManuals,
    this.appId,
    this.cashierTrns,
    this.customerSapId,
    this.memberCard,
    this.salesItems,
    this.salesOrderTypeId,
    this.salesTypeId,
    this.selectExceptPromotion,
    this.selectExceptTender,
    this.selectLackFreeGoods,
    this.selectManyOptionPromotion,
    this.startCalculateDateTime,
    this.storeId,
    this.triggerCouponPromotions,
    this.trnDate,
    this.suggestTenders,
    this.isSkipWarning,
  });

  CalculatePromotionCARq.fromJson(Map<String, dynamic> json) {
    if (json['afterTotalAllItemDiscountManuals'] != null) {
      afterTotalAllItemDiscountManuals = new List<SalesItemDiscountManual>();
      json['afterTotalAllItemDiscountManuals'].forEach((v) {
        afterTotalAllItemDiscountManuals.add(new SalesItemDiscountManual.fromJson(v));
      });
    }
    if (json['beforeTotalAllItemDiscountManuals'] != null) {
      beforeTotalAllItemDiscountManuals = new List<SalesItemDiscountManual>();
      json['beforeTotalAllItemDiscountManuals'].forEach((v) {
        beforeTotalAllItemDiscountManuals.add(new SalesItemDiscountManual.fromJson(v));
      });
    }
    appId = json['appId'];
    if (json['cashierTrns'] != null) {
      cashierTrns = new List<CashierTrn>();
      json['cashierTrns'].forEach((v) {
        cashierTrns.add(new CashierTrn.fromJson(v));
      });
    }
    customerSapId = json['customerSapId'];
    memberCard = json['memberCard'] != null ? new MemberCard.fromJson(json['memberCard']) : null;
    if (json['salesItems'] != null) {
      salesItems = new List<SalesItem>();
      json['salesItems'].forEach((v) {
        salesItems.add(new SalesItem.fromJson(v));
      });
    }
    salesOrderTypeId = json['salesOrderTypeId'];
    salesTypeId = json['salesTypeId'];
    selectExceptPromotion = json['selectExceptPromotion'] != null ? new SelectExceptPromotion.fromJson(json['selectExceptPromotion']) : null;
    selectExceptTender = json['selectExceptTender'] != null ? new SelectExceptTender.fromJson(json['selectExceptTender']) : null;
    selectLackFreeGoods = json['selectLackFreeGoods'] != null ? new SelectLackFreeGoods.fromJson(json['selectLackFreeGoods']) : null;
    selectManyOptionPromotion = json['selectManyOptionPromotion'] != null ? new SelectManyOptionPromotion.fromJson(json['selectManyOptionPromotion']) : null;
    storeId = json['storeId'];
    if (json['triggerCouponPromotions'] != null) {
      triggerCouponPromotions = new List<TriggerCouponPromotion>();
      json['triggerCouponPromotions'].forEach((v) {
        triggerCouponPromotions.add(new TriggerCouponPromotion.fromJson(v));
      });
    }
    trnDate = DateTimeUtil.toDateTime(json['trnDate']);
    startCalculateDateTime = DateTimeUtil.toDateTime(json['startCalculateDateTime']);
    if (json['suggestTenders'] != null) {
      suggestTenders = new List<SuggestTender>();
      json['suggestTenders'].forEach((v) {
        suggestTenders.add(new SuggestTender.fromJson(v));
      });
    }
    isSkipWarning = json['isSkipWarning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.afterTotalAllItemDiscountManuals != null) {
      data['afterTotalAllItemDiscountManuals'] = this.afterTotalAllItemDiscountManuals.map((v) => v.toJson()).toList();
    }
    if (this.beforeTotalAllItemDiscountManuals != null) {
      data['beforeTotalAllItemDiscountManuals'] = this.beforeTotalAllItemDiscountManuals.map((v) => v.toJson()).toList();
    }
    data['appId'] = this.appId;
    if (this.cashierTrns != null) {
      data['cashierTrns'] = this.cashierTrns.map((v) => v.toJson()).toList();
    }
    data['customerSapId'] = this.customerSapId;
    if (this.memberCard != null) {
      data['memberCard'] = this.memberCard.toJson();
    }
    if (this.salesItems != null) {
      data['salesItems'] = this.salesItems.map((v) => v.toJson()).toList();
    }
    data['salesOrderTypeId'] = this.salesOrderTypeId;
    data['salesTypeId'] = this.salesTypeId;
    if (this.selectExceptPromotion != null) {
      data['selectExceptPromotion'] = this.selectExceptPromotion.toJson();
    }
    if (this.selectExceptTender != null) {
      data['selectExceptTender'] = this.selectExceptTender.toJson();
    }
    if (this.selectLackFreeGoods != null) {
      data['selectLackFreeGoods'] = this.selectLackFreeGoods.toJson();
    }
    if (this.selectManyOptionPromotion != null) {
      data['selectManyOptionPromotion'] = this.selectManyOptionPromotion.toJson();
    }
    data['storeId'] = this.storeId;
    if (this.triggerCouponPromotions != null) {
      data['triggerCouponPromotions'] = this.triggerCouponPromotions.map((v) => v.toJson()).toList();
    }
    data['trnDate'] = this.trnDate?.toIso8601String();
    data['startCalculateDateTime'] = this.startCalculateDateTime?.toIso8601String();
    if (this.suggestTenders != null) {
      data['suggestTenders'] = this.suggestTenders.map((v) => v.toJson()).toList();
    }
    data['isSkipWarning'] = this.isSkipWarning;
    return data;
  }
}

class SalesItemDiscountManual {
  String discountTypeId;
  num discountValue;
  String manualDiscountType;
  String remark;

  SalesItemDiscountManual({this.discountTypeId, this.discountValue, this.manualDiscountType, this.remark});

  SalesItemDiscountManual.fromJson(Map<String, dynamic> json) {
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

class MemberCard {
  String discountCardNo;
  String discountCardNo2;
  String discountMemberCardTypeId;
  String discountMemberCardTypeId2;
  String rewardCardNo;
  String rewardMemberCardTypeId;

  MemberCard({this.discountCardNo, this.discountCardNo2, this.discountMemberCardTypeId, this.discountMemberCardTypeId2, this.rewardCardNo, this.rewardMemberCardTypeId});

  MemberCard.fromJson(Map<String, dynamic> json) {
    discountCardNo = json['discountCardNo'];
    discountCardNo2 = json['discountCardNo2'];
    discountMemberCardTypeId = json['discountMemberCardTypeId'];
    discountMemberCardTypeId2 = json['discountMemberCardTypeId2'];
    rewardCardNo = json['rewardCardNo'];
    rewardMemberCardTypeId = json['rewardMemberCardTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discountCardNo'] = this.discountCardNo;
    data['discountCardNo2'] = this.discountCardNo2;
    data['discountMemberCardTypeId'] = this.discountMemberCardTypeId;
    data['discountMemberCardTypeId2'] = this.discountMemberCardTypeId2;
    data['rewardCardNo'] = this.rewardCardNo;
    data['rewardMemberCardTypeId'] = this.rewardMemberCardTypeId;
    return data;
  }
}

class ItemDiscountManual {
  String discountTypeId;
  num discountValue;
  String manualDiscountType;
  String remark;

  ItemDiscountManual({this.discountTypeId, this.discountValue, this.manualDiscountType, this.remark});

  ItemDiscountManual.fromJson(Map<String, dynamic> json) {
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

class ItemDiscount {
  num discountAmt;
  num discountAmtPerUnit;
  String discountTypeDesc;
  String discountTypeId;
  num discountValue;
  String remark;

  ItemDiscount({this.discountAmt, this.discountAmtPerUnit, this.discountTypeDesc, this.discountTypeId, this.discountValue, this.remark});

  ItemDiscount.fromJson(Map<String, dynamic> json) {
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

class SelectExceptPromotion {
  List<SelectExceptPromotionItem> selectExceptPromotionItems;

  SelectExceptPromotion({this.selectExceptPromotionItems});

  SelectExceptPromotion.fromJson(Map<String, dynamic> json) {
    if (json['selectExceptPromotionItems'] != null) {
      selectExceptPromotionItems = new List<SelectExceptPromotionItem>();
      json['selectExceptPromotionItems'].forEach((v) {
        selectExceptPromotionItems.add(new SelectExceptPromotionItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.selectExceptPromotionItems != null) {
      data['selectExceptPromotionItems'] = this.selectExceptPromotionItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectExceptPromotionItem {
  bool choice;
  String promotionId;

  SelectExceptPromotionItem({this.choice, this.promotionId});

  SelectExceptPromotionItem.fromJson(Map<String, dynamic> json) {
    choice = json['choice'];
    promotionId = json['promotionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['choice'] = this.choice;
    data['promotionId'] = this.promotionId;
    return data;
  }
}

class SelectLackFreeGoodsItem {
  bool choice;
  String promotionId;

  SelectLackFreeGoodsItem({this.choice, this.promotionId});

  SelectLackFreeGoodsItem.fromJson(Map<String, dynamic> json) {
    choice = json['choice'];
    promotionId = json['promotionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['choice'] = this.choice;
    data['promotionId'] = this.promotionId;
    return data;
  }
}

class SelectExceptTenderItem {
  bool choice;
  String promotionId;

  SelectExceptTenderItem({this.choice, this.promotionId});

  SelectExceptTenderItem.fromJson(Map<String, dynamic> json) {
    choice = json['choice'];
    promotionId = json['promotionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['choice'] = this.choice;
    data['promotionId'] = this.promotionId;
    return data;
  }
}

class SelectExceptTender {
  List<SelectExceptTenderItem> selectExceptTenderItems;

  SelectExceptTender({this.selectExceptTenderItems});

  SelectExceptTender.fromJson(Map<String, dynamic> json) {
    if (json['selectExceptTenderItems'] != null) {
      selectExceptTenderItems = new List<SelectExceptTenderItem>();
      json['selectExceptTenderItems'].forEach((v) {
        selectExceptTenderItems.add(new SelectExceptTenderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.selectExceptTenderItems != null) {
      data['selectExceptTenderItems'] = this.selectExceptTenderItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectLackFreeGoods {
  List<SelectLackFreeGoodsItem> selectLackFreeGoodsItems;

  SelectLackFreeGoods({this.selectLackFreeGoodsItems});

  SelectLackFreeGoods.fromJson(Map<String, dynamic> json) {
    if (json['selectLackFreeGoodsItems'] != null) {
      selectLackFreeGoodsItems = new List<SelectLackFreeGoodsItem>();
      json['selectLackFreeGoodsItems'].forEach((v) {
        selectLackFreeGoodsItems.add(new SelectLackFreeGoodsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.selectLackFreeGoodsItems != null) {
      data['selectLackFreeGoodsItems'] = this.selectLackFreeGoodsItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectManyOptionPromotion {
  List<SelectManyOptionPromotionItem> selectManyOptionPromotionItems;

  SelectManyOptionPromotion({this.selectManyOptionPromotionItems});

  SelectManyOptionPromotion.fromJson(Map<String, dynamic> json) {
    if (json['selectManyOptionPromotionItems'] != null) {
      selectManyOptionPromotionItems = new List<SelectManyOptionPromotionItem>();
      json['selectManyOptionPromotionItems'].forEach((v) {
        selectManyOptionPromotionItems.add(new SelectManyOptionPromotionItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.selectManyOptionPromotionItems != null) {
      data['selectManyOptionPromotionItems'] = this.selectManyOptionPromotionItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectManyOptionPromotionItem {
  bool choice;
  num optionOid;
  String promotionId;
  num tierOid;

  SelectManyOptionPromotionItem({this.choice, this.optionOid, this.promotionId, this.tierOid});

  SelectManyOptionPromotionItem.fromJson(Map<String, dynamic> json) {
    choice = json['choice'];
    optionOid = json['optionOid'];
    promotionId = json['promotionId'];
    tierOid = json['tierOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['choice'] = this.choice;
    data['optionOid'] = this.optionOid;
    data['promotionId'] = this.promotionId;
    data['tierOid'] = this.tierOid;
    return data;
  }
}

class TriggerCouponPromotion {
  String promotionId;

  TriggerCouponPromotion({this.promotionId});

  TriggerCouponPromotion.fromJson(Map<String, dynamic> json) {
    promotionId = json['promotionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotionId'] = this.promotionId;
    return data;
  }
}
