import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rq.dart';

class SalesItem {
  String articleDesc;
  String articleId;
  String homeServiceType;
  bool isFreeGoods;
  bool isHomeServiceFreeGoods;
  List<ItemDiscountManual> itemDiscountManuals;
  List<ItemDiscount> itemDiscounts;
  String mainUpc;
  num memberDiscountAmt;
  num netItemAmt;
  num normalPrice;
  num price;
  num promotionPrice;
  num qty;
  num refSeqNo;
  SalesCouponHirePurchase salesCouponHirePurchase;
  num seqNo;
  num specialDiscountAmt;
  String unit;
  num vatItemAmt;

  SalesItem({
    this.articleDesc,
    this.articleId,
    this.homeServiceType,
    this.isFreeGoods = false,
    this.isHomeServiceFreeGoods = false,
    this.itemDiscountManuals,
    this.itemDiscounts,
    this.mainUpc,
    this.memberDiscountAmt,
    this.netItemAmt,
    this.normalPrice,
    this.price,
    this.promotionPrice,
    this.qty,
    this.refSeqNo,
    this.salesCouponHirePurchase,
    this.seqNo,
    this.specialDiscountAmt,
    this.unit,
    this.vatItemAmt,
  });

  SalesItem.fromJson(Map<String, dynamic> json) {
    articleDesc = json['articleDesc'];
    articleId = json['articleId'];
    homeServiceType = json['homeServiceType'];
    isFreeGoods = json['isFreeGoods'];
    isHomeServiceFreeGoods = json['isHomeServiceFreeGoods'];
    if (json['itemDiscountManuals'] != null) {
      itemDiscountManuals = new List<ItemDiscountManual>();
      json['itemDiscountManuals'].forEach((v) {
        itemDiscountManuals.add(new ItemDiscountManual.fromJson(v));
      });
    }
    if (json['itemDiscounts'] != null) {
      itemDiscounts = new List<ItemDiscount>();
      json['itemDiscounts'].forEach((v) {
        itemDiscounts.add(new ItemDiscount.fromJson(v));
      });
    }
    mainUpc = json['mainUpc'];
    memberDiscountAmt = json['memberDiscountAmt'];
    netItemAmt = json['netItemAmt'];
    normalPrice = json['normalPrice'];
    price = json['price'];
    promotionPrice = json['promotionPrice'];
    qty = json['qty'];
    refSeqNo = json['refSeqNo'];
    salesCouponHirePurchase = json['salesCouponHirePurchase'] != null ? new SalesCouponHirePurchase.fromJson(json['salesCouponHirePurchase']) : null;
    seqNo = json['seqNo'];
    specialDiscountAmt = json['specialDiscountAmt'];
    unit = json['unit'];
    vatItemAmt = json['vatItemAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleDesc'] = this.articleDesc;
    data['articleId'] = this.articleId;
    data['homeServiceType'] = this.homeServiceType;
    data['isFreeGoods'] = this.isFreeGoods;
    data['isHomeServiceFreeGoods'] = this.isHomeServiceFreeGoods;
    if (this.itemDiscountManuals != null) {
      data['itemDiscountManuals'] = this.itemDiscountManuals.map((v) => v.toJson()).toList();
    }
    if (this.itemDiscounts != null) {
      data['itemDiscounts'] = this.itemDiscounts.map((v) => v.toJson()).toList();
    }
    data['mainUpc'] = this.mainUpc;
    data['memberDiscountAmt'] = this.memberDiscountAmt;
    data['netItemAmt'] = this.netItemAmt;
    data['normalPrice'] = this.normalPrice;
    data['price'] = this.price;
    data['promotionPrice'] = this.promotionPrice;
    data['qty'] = this.qty;
    data['refSeqNo'] = this.refSeqNo;
    if (this.salesCouponHirePurchase != null) {
      data['salesCouponHirePurchase'] = this.salesCouponHirePurchase.toJson();
    }
    data['seqNo'] = this.seqNo;
    data['specialDiscountAmt'] = this.specialDiscountAmt;
    data['unit'] = this.unit;
    data['vatItemAmt'] = this.vatItemAmt;
    return data;
  }
}
