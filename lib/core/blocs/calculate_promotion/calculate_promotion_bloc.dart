import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/basket/basket_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_member_card_group_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_promotion_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_promotion_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_stock_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/cashier_trn.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_hire_purchase_promotion_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_hire_purchase_promotion_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/sales_item.dart';
import 'package:flutter_store_catalog/core/models/user_profile.dart';
import 'package:flutter_store_catalog/core/models/view/calculate_promotion.dart';
import 'package:flutter_store_catalog/core/models/view/hire_purchase_dto.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_dto.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/promotion_bkoffc_service.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/stock_service.dart';
import 'package:flutter_store_catalog/core/services/salesprmtn/hire_purchase_service.dart';
import 'package:flutter_store_catalog/core/services/salesprmtn/promotion_service.dart';
import 'package:flutter_store_catalog/core/utilities/math_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';
import 'package:meta/meta.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';

part 'calculate_promotion_event.dart';

part 'calculate_promotion_state.dart';

const HOMECARD_REWARD_NO = '50';
const HEADER_STORE_DISCOUNT = '8001';
const int FREE_GOOD_SEQ_PREFIX = 1000;

class CalculatePromotionBloc extends Bloc<CalculatePromotionEvent, CalculatePromotionState> {
  final SalesCartBloc salesCartBloc;
  final ApplicationBloc applicationBloc;
  final BasketBloc basketBloc;
  final PromotionService _promotionService = getIt<PromotionService>();
  final HirePurchaseService _hirePurchaseService = getIt<HirePurchaseService>();

  CalculatePromotionBloc(this.applicationBloc, this.salesCartBloc, this.basketBloc); //, this.paymentOptionBloc, this.salesCartCheckPriceBloc);

  @override
  CalculatePromotionState get initialState => InitialCalculatePromotionState();

  @override
  Stream<CalculatePromotionState> mapEventToState(CalculatePromotionEvent event) async* {
    if (event is StartCalculatePromotionEvent) {
      yield* mapStartCalculatePromotionEventToState(event);
    } else if (event is SelectCalculatePromotionEvent) {
      yield* mapSelectCalculatePromotionEventToState(event);
    } else if (event is StartCheckPriceEvent) {
      yield* mapStartCheckPriceEventToState(event);
    }
  }

  Stream<CalculatePromotionState> mapStartCalculatePromotionEventToState(StartCalculatePromotionEvent event) async* {
    try {
      yield LoadingCalculatePromotionState();

      SalesCartDto salesCartDto = salesCartBloc.state.salesCartDto;
      salesCartDto.exceptLackFreeGoods = null;
      CalculatePromotionCARq calcRq = CalculatePromotionCARq();

      calcRq.storeId = applicationBloc.state.appSession?.userProfile?.storeId;
      calcRq.appId = event.appId;
      calcRq.isSkipWarning = true;
      if (StringUtil.isNotEmpty(salesCartDto.salesCart.customer?.memberCardTypeId ?? null)) {
        calcRq.memberCard = calcRq.memberCard ?? MemberCard();
        calcRq.memberCard.rewardMemberCardTypeId = salesCartDto.salesCart.customer?.memberCardTypeId;
      }

      calcRq.salesItems = [];
      for (int i = 0; i < salesCartDto.salesCart.salesOrders.length; i++) {
        SalesOrder salesOrder = salesCartDto.salesCart.salesOrders[i];
        for (int j = 0; j < salesOrder.salesOrderItems.length; j++) {
          SalesOrderItem salesOrderItem = salesOrder.salesOrderItems[j];
          SalesItem salesItem = SalesItem();
          salesItem.seqNo = salesOrderItem.salesOrderItemOid;
          salesItem.articleId = salesOrderItem.articleNo;
          salesItem.qty = salesOrderItem.quantity;
          salesItem.unit = salesOrderItem.unit;
          salesItem.mainUpc = salesOrderItem.mainUPC;
          salesItem.price = salesOrderItem.unitPrice;
          calcRq.salesItems.add(salesItem);
        }
      }

      if (event.discountCard.isNotNull) {
        calcRq.memberCard = calcRq.memberCard ?? MemberCard();
        calcRq.memberCard.discountMemberCardTypeId = event.discountCard.mbrCardTypeBo.memberCardTypeId;
      }

      if (basketBloc.state.calculatePromotionCARq.isNotNull) {
        calcRq.selectExceptPromotion = basketBloc.state.calculatePromotionCARq.selectExceptPromotion;
        calcRq.selectExceptTender = basketBloc.state.calculatePromotionCARq.selectExceptTender;
        calcRq.selectManyOptionPromotion = basketBloc.state.calculatePromotionCARq.selectManyOptionPromotion;
      }

      CalculatePromotionCARs calcRs = await initialState.calculatePromotion(applicationBloc.state.appSession, _promotionService,calcRq, salesCartDto, isCalForOnline: event.appId == CalPromotionCAAppId.SCAT_ONLINE);

      salesCartDto.selectedDiscountCard = event.discountCard;
      num totalDiscountAmt = calcRs.totalAllDiscountAmt;
      // totalDiscountAmt += calcRs.cashierTrns?.fold(0, (previousValue, element) => MathUtil.add(previousValue, ((element.trnAmt * -1) ?? 0))) ?? 0;


      if (CalPromotionCAAppId.SCAT_POS == event.appId) {
        salesCartDto.populateSalesItem = initialState.populateCouponDiscount(applicationBloc, calcRs);
        salesCartDto.hirePurchaseList = await initialState.calculateHirePurchase(applicationBloc, _hirePurchaseService,salesCartDto.populateSalesItem);
      }
      
      if (event.discountCard.isNotNull && event.discountCard.mstMbrCardGroupBo.mbrCardGroupId == TenderIdOfCardNetwork.DISCOUNT_HPVS) {
        calcRs.suggestTenders?.removeWhere((element) => element.tenderId != TenderIdOfCardNetwork.HPCD);

        if(salesCartDto.hirePurchaseList.isNotNE) {
          salesCartDto.hirePurchaseList = salesCartDto.hirePurchaseList.where((element) => element.mstBank.creditCardBos.any((card) => card.creditCardId == TenderIdOfCardNetwork.HPCD)).toList();
        }
      }

      salesCartDto.creditTenderList = calcRs.suggestTenders.where((e) => e.crCardGrp == CrCardGroup.CREDIT).toList();
      salesCartDto.qrTenderList = calcRs.suggestTenders.where((e) => e.crCardGrp == CrCardGroup.QR).toList();
      salesCartDto.otherTenderList = calcRs.suggestTenders.where((e) => e.crCardGrp == CrCardGroup.OTHER).toList();


      yield CalculatedState(
        calcRs: calcRs,
        items: salesCartDto.salesCart.salesCartItems,
        calculatedItems: calcRs.salesItems,
        suggestTender: calcRs.suggestTenders,
        netTrnAmt: MathUtil.add(calcRs.totalTrnAmt, calcRs.totalAllDiscountAmt),
        totalDiscountAmt: totalDiscountAmt,
        deliveryFeeAmt: 0,
        unpaidAmt: calcRs.unpaidAmt,
      );
    } catch (error, stackTrace) {
      yield ErrorCalculatePromotionState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<CalculatePromotionState> mapSelectCalculatePromotionEventToState(SelectCalculatePromotionEvent event) async* {
    try {
      yield LoadingCalculatePromotionState();

      SalesCartDto salesCartDto = salesCartBloc.state.salesCartDto;
      CalculatePromotionCARq calcRq = CalculatePromotionCARq();

      AppSession appSession = applicationBloc.state.appSession;

      calcRq.isSkipWarning = true;
      calcRq.storeId = appSession?.userProfile?.storeId;
      if (StringUtil.isNotEmpty(salesCartDto.salesCart.customer?.memberCardTypeId ?? null)) {
        calcRq.memberCard = calcRq.memberCard ?? MemberCard();
        calcRq.memberCard.rewardMemberCardTypeId = salesCartDto.salesCart.customer?.memberCardTypeId;
      }
      calcRq.cashierTrns = [
        CashierTrn()
          ..seqNo = 1
          ..trnAmt = event.totalAmount
          ..tenderId = event.suggestTender.tenderId
          ..refInfo = event.suggestTender.crCardNoDummy
      ];

      calcRq.salesItems = [];
      for (int i = 0; i < salesCartDto.salesCart.salesOrders.length; i++) {
        SalesOrder salesOrder = salesCartDto.salesCart.salesOrders[i];
        for (int j = 0; j < salesOrder.salesOrderItems.length; j++) {
          SalesOrderItem salesOrderItem = salesOrder.salesOrderItems[j];
          SalesItem salesItem = SalesItem();
          salesItem.seqNo = salesOrderItem.salesOrderItemOid;
          salesItem.articleId = salesOrderItem.articleNo;
          salesItem.qty = salesOrderItem.quantity;
          salesItem.unit = salesOrderItem.unit;
          salesItem.mainUpc = salesOrderItem.mainUPC;
          salesItem.price = salesOrderItem.unitPrice;
          calcRq.salesItems.add(salesItem);
        }
      }

      if (salesCartDto.selectedDiscountCard.isNotNull) {
        calcRq.memberCard = calcRq.memberCard ?? MemberCard();
        calcRq.memberCard.discountMemberCardTypeId = salesCartDto.selectedDiscountCard.mbrCardTypeBo.memberCardTypeId;
      }

      // calcRq.isSkipWarning = event.appId == CalPromotionCAAppId.SCAT_POS;
      if(salesCartDto.exceptLackFreeGoods.isNotNull) {
        calcRq.selectLackFreeGoods = salesCartDto.exceptLackFreeGoods;
      }

      salesCartDto.lackFreeGoodsSalesCartItemMap = Map<num,List<SalesCartItem>>();

      if (basketBloc.state.calculatePromotionCARq.isNotNull) {
        calcRq.selectExceptPromotion = basketBloc.state.calculatePromotionCARq.selectExceptPromotion;
        calcRq.selectExceptTender = basketBloc.state.calculatePromotionCARq.selectExceptTender;
        calcRq.selectManyOptionPromotion = basketBloc.state.calculatePromotionCARq.selectManyOptionPromotion;
      }

      CalculatePromotionCARs calcRs = await initialState.calculatePromotion(applicationBloc.state.appSession, _promotionService,calcRq, salesCartDto, isCalForOnline: event.appId == CalPromotionCAAppId.SCAT_ONLINE);
      if(calcRs == null && salesCartDto.exceptLackFreeGoods.isNotNull){
        yield ErrorFreeGoodsNotHaveStockState();
        return;
      }


      num totalDiscountAmt = calcRs.totalAllDiscountAmt;
      // totalDiscountAmt += calcRs.cashierTrns?.where((e) => e.seqNo != 1)?.fold(0, (previousValue, element) => MathUtil.add(previousValue, ((element.trnAmt * -1) ?? 0))) ?? 0;

      num netTrnAmt = MathUtil.add(calcRs.totalTrnAmt, totalDiscountAmt);

      yield SelectedTenderState(
        calcRs: calcRs,
        suggestTender: calcRs.suggestTenders,
        netTrnAmt: netTrnAmt,
        totalDiscountAmt: totalDiscountAmt,
        deliveryFeeAmt: 0,
        unpaidAmt: calcRs.unpaidAmt,
      );
    } catch (error, stackTrace) {
      yield ErrorCalculatePromotionState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<CalculatePromotionState> mapStartCheckPriceEventToState(StartCheckPriceEvent event) async* {
    try {
      yield LoadingCalculatePromotionState();

      if(event.salesItems[0].qty == 0){
        throw 'text.please_specify_product_qty'.tr();
      }

      CalculatePromotionCARq calcRq = CalculatePromotionCARq();
      calcRq.storeId = applicationBloc.state.appSession?.userProfile?.storeId;
      calcRq.appId = event.appId;
      calcRq.salesItems = event.salesItems;

      calcRq.isSkipWarning = true;

      CalculatePromotionCARs calcRs = await initialState.calculatePromotion(applicationBloc.state.appSession, _promotionService,calcRq, salesCartBloc.state.salesCartDto, isCalForOnline: event.appId == CalPromotionCAAppId.SCAT_ONLINE);

      List<SuggestTender> tenderList = calcRs.suggestTenders.where((e) => e.crCardGrp != CrCardGroup.OTHER).toList();
      List<SuggestTender> otherTenderList = calcRs.suggestTenders.where((e) => e.crCardGrp == CrCardGroup.OTHER).toList();

      List<SalesItem> populateSalesItem = initialState.populateCouponDiscount(applicationBloc, calcRs);
      List<HirePurchaseDto> hirePurchaseDtoList = await initialState.calculateHirePurchase(applicationBloc, _hirePurchaseService, populateSalesItem, isCheckPrice: true);
      Map<MstBank, List<HirePurchasePromotion>> hirePurchaseMap = {for (var hirePurchaseDto in hirePurchaseDtoList) hirePurchaseDto.mstBank: hirePurchaseDto.promotionMap[HirePurchaseLevel.ART] ?? []};

      yield CheckPriceState(
        totalAmount: calcRs.totalTrnAmt,
        tenderList: tenderList,
        otherTenderList: otherTenderList,
        hirePurchaseMap: hirePurchaseMap,
      );
    } catch (error, stackTrace) {
      yield ErrorCalculatePromotionState(AppException(error, stackTrace: stackTrace));
    }
  }
}
