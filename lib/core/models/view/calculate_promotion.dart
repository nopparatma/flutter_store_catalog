import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/cashier_trn.dart';
import 'package:flutter_store_catalog/core/models/view/hire_purchase_dto.dart';

class CalproViewModel {
  //Instant field
  List<SalesCartItem> lstLackFreeGoodsItem;
  List<MapPromotion> mapPromotions;
  List<GetArticleForSalesCartItemRq> listGetArticleForSalesCartItemRq;
  List<SalesCartItem> salesCartItemForFreeGood;

  //CalproCA rq input
  SalesCart salesCart;
  SelectLackFreeGoods selectLackFreeGoods;
  SelectExceptPromotion selectExceptPromotion;
  SelectManyOptionPromotion selectManyOptionPromotion;
  SelectExceptTender selectExceptTender;

  //Adapter display
  List<DiscountArticleItem> lstDiscountArticleItem;

  //Hirepurchase
  List<SalesCartItem> lstTmpSalesCartItem;
  List<MstBank> lstBankHirePurchase;
  // List<HirePurchasePromotion> lstHirePurchasePromotion;
  // List<HirePurchasePromotion> lstHirePurchaseProSelect;
  //
  // List<HirePurchasePromotion> lstHirePurchaseARTFilter;
  // List<HirePurchasePromotion> lstHirePurchaseMCHFilter;
  // List<HirePurchasePromotion> lstHirePurchaseAITFilter;
  // List<HirePurchasePromotion> lstShowHirePurchase;
  // List<HirePurchasePromotion> lstTmpSelectHirePurchase;

  //CheckPromotion
  bool isCheckPromotion;

  //Pay Amount
  CashierTrn cashierTrnPay;
}

class MapPromotion {
  String promotionId;
  String mainArtId;
  String premiumArtId;
  num salesOrderOid;
  String deliverySite;
  String shippingPointId;
  num salesOrderItemOid;
  num salesOrderGroupOid;

  @override
  String toString() {
    return 'MapPromotion{promotionId: $promotionId, mainArtId: $mainArtId, premiumArtId: $premiumArtId, salesOrderOid: $salesOrderOid, deliverySite: $deliverySite, shippingPointId: $shippingPointId, salesOrderItemOid: $salesOrderItemOid, salesOrderGroupOid: $salesOrderGroupOid}';
  }
}

class DiscountArticleItem {
  DiscountConditionType discountConditionType;
  num discountAmt;
  bool isPromotion = false;
  num discountPercent;
  String articleNo;

  @override
  String toString() {
    return 'DiscountArticleItem{discountConditionType: $discountConditionType, discountAmt: $discountAmt, isPromotion: $isPromotion, discountPercent: $discountPercent, articleNo: $articleNo}';
  }
}

class HirePurchaseBo {
  String articleNo;
  String articleDesc;
  String discountConditionTypeId;
  num priceDiscount;
  num percentDiscount;
  String tenderId;
  String cardType;
  String status;
  String mailId;
  String optionId;
  String tenderCode;
  String mail_desc;
  String periodStart;
  String periodEnd;
  String tenderName;
  String remark;
  String promotionId;
  num monthTerm;
  String isManualApprove;
  String manualApproveUserId;
  String createUserId;
  String createUserName;
  DateTime createDateTime;
  String promotionDesc;
  String promotionHierachyLevel;
  num minAmtPerArticle;
  num minAmtPerTicket;
  num prodHierOid;
  bool isVendorAbsorb;
  String mc;
  String mch1;
  String mch2;
  String mch3;
  String groupId;
  num seqNo;
  String hierarchyType;
  String hierarchyDescription;

  HirePurchaseBo({this.articleNo, this.articleDesc, this.discountConditionTypeId, this.priceDiscount, this.percentDiscount, this.tenderId, this.cardType, this.status, this.mailId, this.optionId, this.tenderCode, this.mail_desc, this.periodStart, this.periodEnd, this.tenderName, this.remark, this.promotionId, this.monthTerm, this.isManualApprove, this.manualApproveUserId, this.createUserId, this.createUserName, this.createDateTime, this.promotionDesc, this.promotionHierachyLevel, this.minAmtPerArticle, this.minAmtPerTicket, this.prodHierOid, this.isVendorAbsorb, this.mc, this.mch1, this.mch2, this.mch3, this.groupId, this.seqNo, this.hierarchyType, this.hierarchyDescription});

  @override
  String toString() {
    return 'HirePurchaseBo{articleNo: $articleNo, articleDesc: $articleDesc, discountConditionTypeId: $discountConditionTypeId, priceDiscount: $priceDiscount, percentDiscount: $percentDiscount, tenderId: $tenderId, cardType: $cardType, status: $status, mailId: $mailId, optionId: $optionId, tenderCode: $tenderCode, mail_desc: $mail_desc, periodStart: $periodStart, periodEnd: $periodEnd, tenderName: $tenderName, remark: $remark, promotionId: $promotionId, monthTerm: $monthTerm, isManualApprove: $isManualApprove, manualApproveUserId: $manualApproveUserId, createUserId: $createUserId, createUserName: $createUserName, createDateTime: $createDateTime, promotionDesc: $promotionDesc, promotionHierachyLevel: $promotionHierachyLevel, minAmtPerArticle: $minAmtPerArticle, minAmtPerTicket: $minAmtPerTicket, prodHierOid: $prodHierOid, isVendorAbsorb: $isVendorAbsorb, mc: $mc, mch1: $mch1, mch2: $mch2, mch3: $mch3, groupId: $groupId, seqNo: $seqNo, hierarchyType: $hierarchyType, hierarchyDescription: $hierarchyDescription}';
  }
}
