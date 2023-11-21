import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class SmsCreateSalesRq {
  String collectSalesOrderNo;
  String createUserId;
  String createUserName;
  String phoneNo;
  List<CashTrn> lstCashTrn;
  String posId;
  PromotionRdptn promotionRdptn;
  String rewardCardNo;
  String storeId;
  DateTime tranDate;
  num paymentRef;
  String paymentMethod;
  List<SalesTrnItem> lstSalesTrnItem;
  num netTrnAmount;
  num totVatTrnAmt;
  num totalDiscountAmt;
  num totalTrnAmt;
  num vatTrnAmt;
  String email;
  String billToCustNo;
  String salesChannel;
  String sapOrderCode;

  SmsCreateSalesRq({
    this.collectSalesOrderNo,
    this.createUserId,
    this.createUserName,
    this.phoneNo,
    this.lstCashTrn,
    this.posId,
    this.promotionRdptn,
    this.rewardCardNo,
    this.storeId,
    this.tranDate,
    this.lstSalesTrnItem,
    this.netTrnAmount,
    this.totVatTrnAmt,
    this.totalDiscountAmt,
    this.totalTrnAmt,
    this.vatTrnAmt,
    this.email,
    this.billToCustNo,
    this.salesChannel,
    this.sapOrderCode,
  });

  SmsCreateSalesRq.fromJson(Map<String, dynamic> json) {
    collectSalesOrderNo = json['collectSalesOrderNo'];
    createUserId = json['createUserId'];
    createUserName = json['createUserName'];
    phoneNo = json['phoneNo'];
    if (json['lstCashTrn'] != null) {
      lstCashTrn = new List<CashTrn>();
      json['lstCashTrn'].forEach((v) {
        lstCashTrn.add(new CashTrn.fromJson(v));
      });
    }
    posId = json['posId'];
    promotionRdptn = json['promotionRdptn'] != null ? new PromotionRdptn.fromJson(json['promotionRdptn']) : null;
    rewardCardNo = json['rewardCardNo'];
    storeId = json['storeId'];
    tranDate = DateTimeUtil.toDateTime(json['tranDate']);
    paymentRef = json['paymentRef'];
    paymentMethod = json['paymentMethod'];
    if (json['lstSalesTrnItem'] != null) {
      lstSalesTrnItem = new List<SalesTrnItem>();
      json['lstSalesTrnItem'].forEach((v) {
        lstSalesTrnItem.add(new SalesTrnItem.fromJson(v));
      });
    }
    netTrnAmount = json['netTrnAmount'];
    totVatTrnAmt = json['totVatTrnAmt'];
    totalDiscountAmt = json['totalDiscountAmt'];
    totalTrnAmt = json['totalTrnAmt'];
    vatTrnAmt = json['vatTrnAmt'];
    email = json['email'];
    billToCustNo = json['billToCustNo'];
    salesChannel = json['salesChannel'];
    sapOrderCode = json['sapOrderCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['collectSalesOrderNo'] = this.collectSalesOrderNo;
    data['createUserId'] = this.createUserId;
    data['createUserName'] = this.createUserName;
    data['phoneNo'] = this.phoneNo;
    if (this.lstCashTrn != null) {
      data['lstCashTrn'] = this.lstCashTrn.map((v) => v.toJson()).toList();
    }
    data['posId'] = this.posId;
    if (this.promotionRdptn != null) {
      data['promotionRdptn'] = this.promotionRdptn.toJson();
    }
    data['rewardCardNo'] = this.rewardCardNo;
    data['storeId'] = this.storeId;
    data['tranDate'] = this.tranDate?.toIso8601String();
    data['paymentRef'] = this.paymentRef;
    data['paymentMethod'] = this.paymentMethod;
    if (this.lstSalesTrnItem != null) {
      data['lstSalesTrnItem'] = this.lstSalesTrnItem.map((v) => v.toJson()).toList();
    }
    data['netTrnAmount'] = this.netTrnAmount;
    data['totVatTrnAmt'] = this.totVatTrnAmt;
    data['totalDiscountAmt'] = this.totalDiscountAmt;
    data['totalTrnAmt'] = this.totalTrnAmt;
    data['vatTrnAmt'] = this.vatTrnAmt;
    data['email'] = this.email;
    data['billToCustNo'] = this.billToCustNo;
    data['salesChannel'] = this.salesChannel;
    data['sapOrderCode'] = this.sapOrderCode;
    return data;
  }
}

class CashTrn {
  String creditCardApproveCode;
  String promotionId;
  String refInfo;
  String tenderId;
  num trnAmt;

  CashTrn({this.creditCardApproveCode, this.promotionId, this.refInfo, this.tenderId, this.trnAmt});

  CashTrn.fromJson(Map<String, dynamic> json) {
    creditCardApproveCode = json['creditCardApproveCode'];
    promotionId = json['promotionId'];
    refInfo = json['refInfo'];
    tenderId = json['tenderId'];
    trnAmt = json['trnAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creditCardApproveCode'] = this.creditCardApproveCode;
    data['promotionId'] = this.promotionId;
    data['refInfo'] = this.refInfo;
    data['tenderId'] = this.tenderId;
    data['trnAmt'] = this.trnAmt;
    return data;
  }
}

class PromotionRdptn {
  List<PromotionDscntRedemption> lstPromotionDscntRedemption;
  List<PromotionSale> lstPromotionSale;
  String prmtnTyp;
  String status;

  PromotionRdptn({this.lstPromotionDscntRedemption, this.lstPromotionSale, this.prmtnTyp, this.status});

  PromotionRdptn.fromJson(Map<String, dynamic> json) {
    if (json['lstPromotionDscntRedemption'] != null) {
      lstPromotionDscntRedemption = new List<PromotionDscntRedemption>();
      json['lstPromotionDscntRedemption'].forEach((v) {
        lstPromotionDscntRedemption.add(new PromotionDscntRedemption.fromJson(v));
      });
    }
    if (json['lstPromotionSale'] != null) {
      lstPromotionSale = new List<PromotionSale>();
      json['lstPromotionSale'].forEach((v) {
        lstPromotionSale.add(new PromotionSale.fromJson(v));
      });
    }
    prmtnTyp = json['prmtnTyp'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstPromotionDscntRedemption != null) {
      data['lstPromotionDscntRedemption'] = this.lstPromotionDscntRedemption.map((v) => v.toJson()).toList();
    }
    if (this.lstPromotionSale != null) {
      data['lstPromotionSale'] = this.lstPromotionSale.map((v) => v.toJson()).toList();
    }
    data['prmtnTyp'] = this.prmtnTyp;
    data['status'] = this.status;
    return data;
  }
}

class PromotionDscntRedemption {
  num couponQty;
  num dscntAmt;
  String dscntCondtyp;
  String prmtnId;
  String vendorId;
  String vendorNm;

  PromotionDscntRedemption({this.couponQty, this.dscntAmt, this.dscntCondtyp, this.prmtnId, this.vendorId, this.vendorNm});

  PromotionDscntRedemption.fromJson(Map<String, dynamic> json) {
    couponQty = json['couponQty'];
    dscntAmt = json['dscntAmt'];
    dscntCondtyp = json['dscntCondtyp'];
    prmtnId = json['prmtnId'];
    vendorId = json['vendorId'];
    vendorNm = json['vendorNm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponQty'] = this.couponQty;
    data['dscntAmt'] = this.dscntAmt;
    data['dscntCondtyp'] = this.dscntCondtyp;
    data['prmtnId'] = this.prmtnId;
    data['vendorId'] = this.vendorId;
    data['vendorNm'] = this.vendorNm;
    return data;
  }
}

class PromotionSale {
  List<PromotionSalesItem> lstPromotionSalesItem;
  num netAmt;
  num netTrnAmt;
  String prmtnId;
  String prmtnNm;
  List<PromotionSalesItem> promotionSalesItems;
  String salesType;

  PromotionSale({this.lstPromotionSalesItem, this.netAmt, this.netTrnAmt, this.prmtnId, this.prmtnNm, this.promotionSalesItems, this.salesType});

  PromotionSale.fromJson(Map<String, dynamic> json) {
    if (json['lstPromotionSalesItem'] != null) {
      lstPromotionSalesItem = new List<PromotionSalesItem>();
      json['lstPromotionSalesItem'].forEach((v) {
        lstPromotionSalesItem.add(new PromotionSalesItem.fromJson(v));
      });
    }
    netAmt = json['netAmt'];
    netTrnAmt = json['netTrnAmt'];
    prmtnId = json['prmtnId'];
    prmtnNm = json['prmtnNm'];
    if (json['promotionSalesItems'] != null) {
      promotionSalesItems = new List<PromotionSalesItem>();
      json['promotionSalesItems'].forEach((v) {
        promotionSalesItems.add(new PromotionSalesItem.fromJson(v));
      });
    }
    salesType = json['salesType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lstPromotionSalesItem != null) {
      data['lstPromotionSalesItem'] = this.lstPromotionSalesItem.map((v) => v.toJson()).toList();
    }
    data['netAmt'] = this.netAmt;
    data['netTrnAmt'] = this.netTrnAmt;
    data['prmtnId'] = this.prmtnId;
    data['prmtnNm'] = this.prmtnNm;
    if (this.promotionSalesItems != null) {
      data['promotionSalesItems'] = this.promotionSalesItems.map((v) => v.toJson()).toList();
    }
    data['salesType'] = this.salesType;
    return data;
  }
}

class PromotionSalesItem {
  String articleDescription;
  String articleId;
  num eligibleQuantity;
  String mainUPC;
  String mch3;
  String netAmount;
  String unit;

  PromotionSalesItem({this.articleDescription, this.articleId, this.eligibleQuantity, this.mainUPC, this.mch3, this.netAmount, this.unit});

  PromotionSalesItem.fromJson(Map<String, dynamic> json) {
    articleDescription = json['articleDescription'];
    articleId = json['articleId'];
    eligibleQuantity = json['eligibleQuantity'];
    mainUPC = json['mainUPC'];
    mch3 = json['mch3'];
    netAmount = json['netAmount'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleDescription'] = this.articleDescription;
    data['articleId'] = this.articleId;
    data['eligibleQuantity'] = this.eligibleQuantity;
    data['mainUPC'] = this.mainUPC;
    data['mch3'] = this.mch3;
    data['netAmount'] = this.netAmount;
    data['unit'] = this.unit;
    return data;
  }
}

class SalesTrnItem {
  bool isFreeGood;
  List<ItemDiscount> itemDiscounts;
  num memberDiscountAmount;
  num normalPrice;
  num price;
  num promotionPrice;
  num netItemAmount;
  num salesOrderItemOid;
  int seqNo;
  num specialDiscountAmount;
  num vatItemAmt;
  num qty;

  SalesTrnItem({this.isFreeGood, this.itemDiscounts, this.memberDiscountAmount, this.normalPrice, this.price, this.promotionPrice, this.netItemAmount, this.salesOrderItemOid, this.seqNo, this.specialDiscountAmount, this.vatItemAmt, this.qty});

  SalesTrnItem.fromJson(Map<String, dynamic> json) {
    isFreeGood = json['isFreeGood'];
    if (json['itemDiscounts'] != null) {
      itemDiscounts = new List<ItemDiscount>();
      json['itemDiscounts'].forEach((v) {
        itemDiscounts.add(new ItemDiscount.fromJson(v));
      });
    }
    memberDiscountAmount = json['memberDiscountAmount'];
    normalPrice = json['normalPrice'];
    price = json['price'];
    promotionPrice = json['promotionPrice'];
    netItemAmount = json['netItemAmount'];
    salesOrderItemOid = json['salesOrderItemOid'];
    seqNo = json['seqNo'];
    specialDiscountAmount = json['specialDiscountAmount'];
    vatItemAmt = json['vatItemAmt'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFreeGood'] = this.isFreeGood;
    if (this.itemDiscounts != null) {
      data['itemDiscounts'] = this.itemDiscounts.map((v) => v.toJson()).toList();
    }
    data['memberDiscountAmount'] = this.memberDiscountAmount;
    data['normalPrice'] = this.normalPrice;
    data['price'] = this.price;
    data['promotionPrice'] = this.promotionPrice;
    data['netItemAmount'] = this.netItemAmount;
    data['salesOrderItemOid'] = this.salesOrderItemOid;
    data['seqNo'] = this.seqNo;
    data['specialDiscountAmount'] = this.specialDiscountAmount;
    data['vatItemAmt'] = this.vatItemAmt;
    data['qty'] = this.qty;
    return data;
  }
}

class ItemDiscount {
  num dscntAmt;
  String dscntCondTypId;
  num dscntPerUnit;
  num dscntVal;
  String remark;

  ItemDiscount({this.dscntAmt, this.dscntCondTypId, this.dscntPerUnit, this.dscntVal, this.remark});

  ItemDiscount.fromJson(Map<String, dynamic> json) {
    dscntAmt = json['dscntAmt'];
    dscntCondTypId = json['dscntCondTypId'];
    dscntPerUnit = json['dscntPerUnit'];
    dscntVal = json['dscntVal'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dscntAmt'] = this.dscntAmt;
    data['dscntCondTypId'] = this.dscntCondTypId;
    data['dscntPerUnit'] = this.dscntPerUnit;
    data['dscntVal'] = this.dscntVal;
    data['remark'] = this.remark;
    return data;
  }
}
