import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_hire_purchase_promotion_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_hire_purchase_promotion_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/sales_item.dart';

class HirePurchaseDto {
  MstBank mstBank;
  Map<String, List<HirePurchasePromotion>> promotionMap;

  HirePurchaseDto({
    this.mstBank,
    this.promotionMap,
  });
}

class HirePurchasePromotion {
  DateTime periodEnd;
  DateTime periodStart;

  String mailId;

  GroupList group;

  PromotionList promotion;

  num minAmtPerTicket;
  num minAmtPerArt;
  num unpaidAmt;
  num netAmt;
  num netAmtFinalPrice;
  num discountAmt;
  List<SalesItem> lstArticle;

  HirePurchasePromotion({
    this.periodEnd,
    this.periodStart,
    this.mailId,
    this.group,
    this.promotion,
    this.minAmtPerTicket,
    this.minAmtPerArt,
    this.unpaidAmt,
    this.netAmt,
    this.netAmtFinalPrice,
    this.discountAmt,
    this.lstArticle,
  });
}

class HirePurchaseArticle {
  String articleId;
  String articleDesc;
  num unitPrice;
  num qty;
  num totalAmount;

  num minAmtPerArt;

  HirePurchaseArticle({
    this.articleId,
    this.articleDesc,
    this.unitPrice,
    this.qty,
    this.totalAmount,
  });
}
