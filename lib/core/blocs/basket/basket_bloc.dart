import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_logger.dart';
import 'package:flutter_store_catalog/core/blocs/app_timer/app_timer_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_special_condition_article_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_special_condition_article_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_store_info_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_store_info_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rs.dart' as checklist;
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/sales_item.dart';
import 'package:flutter_store_catalog/core/models/user_profile.dart';
import 'package:flutter_store_catalog/core/models/view/basket_item.dart';
import 'package:flutter_store_catalog/core/models/view/checklist_data.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:flutter_store_catalog/core/services/salesprmtn/promotion_service.dart';
import 'package:flutter_store_catalog/core/utilities/math_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../app_exception.dart';

part 'basket_event.dart';

part 'basket_state.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  final ApplicationBloc applicationBloc;
  final AppTimerBloc appTimerBloc;
  final SalesCartBloc salesCartBloc;
  final PromotionService _promotionService = getIt<PromotionService>();
  final SaleOrderService _saleOrderService = getIt<SaleOrderService>();

  BasketBloc(this.applicationBloc, this.appTimerBloc, this.salesCartBloc);

  @override
  BasketState get initialState => BasketState(items: [], calculatedItems: []);

  @override
  Stream<BasketState> mapEventToState(BasketEvent event) async* {
    if (event is BasketAddItemEvent) {
      yield* mapEventAddItemToState(event);
    } else if (event is BasketRemoveItemEvent) {
      yield* mapEventRemoveItemToState(event);
    } else if (event is BasketUpdateItemEvent) {
      yield* mapEventUpdateItemToState(event);
    } else if (event is BasketUpdateItemCheckListEvent) {
      yield* mapEventUpdateItemCheckListToState(event);
    } else if (event is ResetBasketEvent) {
      yield initialState;
    }
  }

  Stream<BasketState> mapEventAddItemToState(BasketAddItemEvent event) async* {
    try {
      yield LoadingBasketState.clone(state);

      AppSession appSession = applicationBloc.state.appSession;

      List<BasketItem> items = []..addAll(state.items);
      bool isEmptyItems = items.isEmpty;
      BasketItem item = items.firstWhere((element) => StringUtil.trimLeftZero(element.article.articleId) == StringUtil.trimLeftZero(event.item.article.articleId), orElse: () => null);

      //Check Special Condition
      GetSpecialConditionArticleRq getSpecialConditionArticleRq = GetSpecialConditionArticleRq();
      getSpecialConditionArticleRq.storeId = appSession.userProfile.storeId;
      getSpecialConditionArticleRq.articleList = [event.item.getArticleId()];
      GetSpecialConditionArticleRs getSpecialConditionArticleRs = await _saleOrderService.getSpecialConditionArticle(appSession, getSpecialConditionArticleRq);
      if (getSpecialConditionArticleRs.specialConditionItemBos?.isNotEmpty ?? false) {
        event.item.isSpecialOrder = getSpecialConditionArticleRs.specialConditionItemBos[0].isSpecialOrder;
        event.item.isSpecialDts = getSpecialConditionArticleRs.specialConditionItemBos[0].isSpecialDts;
      }

      if (item != null) {
        item.qty += event.item.qty;
      } else {
        item = event.item;
        item.key = Uuid().v1();
        items.add(event.item);
      }

      if (event.item.checkListData != null) {
        item.checkListData = event.item.checkListData;
      }

      if (item.checkListData != null) {
        items.removeWhere((element) => element.keyOfMainItem == item.key);

        List<BasketItem> installServiceItems = [];
        checklist.PatternList patternType = item.checkListData.checkListInfo.patternTypeList.firstWhere((element) => element.insPatternID == item.checkListData.patternTypeSelected, orElse: () => null);
        if (patternType != null) {
          for (checklist.ArtServiceList artService in patternType.artServiceList) {
            installServiceItems.add(BasketItem.installService(artService.searchArticle, item.qty, item.key, false));
          }
        }

        checklist.PatternList patternArea = item.checkListData.checkListInfo.patternAreaList.firstWhere((element) => element.insPatternID == item.checkListData.patternAreaSelected, orElse: () => null);
        if (patternArea != null) {
          for (checklist.ArtServiceList artService in patternArea.artServiceList) {
            installServiceItems.add(BasketItem.installService(artService.searchArticle, 1, item.key, true));
          }
        }

        if (installServiceItems.isNotEmpty) {
          int index = items.indexOf(item);
          items.insertAll(index + 1, installServiceItems);
        }
      }

      if (isEmptyItems) {
        // set transactionDateTime for first item

        GetStoreInfoRq getStoreInfoRq = GetStoreInfoRq();
        getStoreInfoRq.storeId = appSession.userProfile.storeId;
        GetStoreInfoRs getStoreInfoRs = await _saleOrderService.getStoreInfo(appSession, getStoreInfoRq);

        appSession.transactionDateTime = getStoreInfoRs.transactionDate;
      }

      BasketState toState = await calculatePromotion(items);
      toState.isPopWidget = event.isPopWidget;

      if (toState.items != null && toState.items.length > 0) {
        // Start Timer for Clear cart
        appTimerBloc.add(AppTimerStarted());
      }

      yield toState;
    } catch (error, stackTrace) {
      AppLogger().e(error);
      yield ErrorBasketState.clone(state, 'text.cant_add_to_basket'.tr());
    }
  }

  Stream<BasketState> mapEventRemoveItemToState(BasketRemoveItemEvent event) async* {
    try {
      yield LoadingBasketState.clone(state);

      List<BasketItem> items = []..addAll(state.items);

      items.removeWhere((element) => element.key == event.item.key);
      items.removeWhere((element) => element.keyOfMainItem == event.item.key);

      if (items.isEmpty) {
        // Clear Timer
        appTimerBloc.add(AppTimerReset());

        salesCartBloc.add(SalesCartResetEvent());

        yield initialState;
        return;
      }

      BasketState toState = await calculatePromotion(items);

      yield toState;
    } catch (error, stackTrace) {
      AppLogger().e(error);
      yield ErrorBasketState.clone(state, 'text.cant_add_to_basket'.tr());
    }
  }

  Stream<BasketState> mapEventUpdateItemToState(BasketUpdateItemEvent event) async* {
    try {
      yield LoadingBasketState.clone(state);

      List<BasketItem> items = []..addAll(state.items);
      BasketItem item = items.firstWhere((element) => element.key == event.item.key, orElse: () => null);

      if (item != null) {
        num editQty = event.newQty - event.item.qty;
        item.qty += editQty;
        if (item.qty <= 0) item.qty = 1;
        for (var childItem in items.where((element) => element.keyOfMainItem == event.item.key).toList()) {
          if (!childItem.isServiceArea) {
            childItem.qty = item.qty;
          }
        }
      }

      BasketState toState = await calculatePromotion(items);

      yield toState;
    } catch (error, stackTrace) {
      AppLogger().e(error);
      yield ErrorBasketState.clone(state, 'text.cant_add_to_basket'.tr());
    }
  }

  Stream<BasketState> mapEventUpdateItemCheckListToState(BasketUpdateItemCheckListEvent event) async* {
    try {
      yield LoadingBasketState.clone(state);

      List<BasketItem> items = []..addAll(state.items);
      BasketItem item = items.firstWhere((element) => element.key == event.item.key, orElse: () => null);

      if (item != null) {
        if (event.item.checkListData != null) {
          item.checkListData = event.item.checkListData;
        }

        if (item.checkListData != null) {
          item.checkListData = event.checkListData;

          items.removeWhere((element) => element.keyOfMainItem == item.key);

          List<BasketItem> installServiceItems = [];
          checklist.PatternList patternType = item.checkListData.checkListInfo.patternTypeList.firstWhere((element) => element.insPatternID == item.checkListData.patternTypeSelected, orElse: () => null);
          if (patternType != null) {
            for (checklist.ArtServiceList artService in patternType.artServiceList) {
              installServiceItems.add(BasketItem.installService(artService.searchArticle, item.qty, item.key, false));
            }
          }

          checklist.PatternList patternArea = item.checkListData.checkListInfo.patternAreaList.firstWhere((element) => element.insPatternID == item.checkListData.patternAreaSelected, orElse: () => null);
          if (patternArea != null) {
            for (checklist.ArtServiceList artService in patternArea.artServiceList) {
              installServiceItems.add(BasketItem.installService(artService.searchArticle, 1, item.key, true));
            }
          }

          if (installServiceItems.isNotEmpty) {
            int index = items.indexOf(item);
            items.insertAll(index + 1, installServiceItems);
          }
        }
      }

      BasketState toState = await calculatePromotion(items);

      yield toState;
    } catch (error, stackTrace) {
      AppLogger().e(error);
      yield ErrorBasketState.clone(state, 'text.cant_add_to_basket'.tr());
    }
  }

  Future<BasketState> calculatePromotion(List<BasketItem> items) async {
    AppSession appSession = applicationBloc.state.appSession;

    CalculatePromotionCARq calcRq = CalculatePromotionCARq();
    calcRq.storeId = appSession.userProfile.storeId;

    int seqNo = 0;
    calcRq.salesItems = items
        .map((e) => SalesItem(
              seqNo: ++seqNo,
              articleId: e.getArticleId().padLeft(18, '0'),
              unit: e.getUnit(),
              qty: e.qty,
            ))
        .toList();

    const int MAX_LOOP = 10;
    int cntLoop = 0;
    List<LackFreeGoods> tmpLackFreeGoods = [];

    CalculatePromotionCARs calcRs;
    while (true) {
      calcRs = await _promotionService.calculatePromotionCA(appSession, calcRq);

      if (calcRs.rsStatus != 'W') {
        break;
      }

      if (cntLoop >= MAX_LOOP) {
        // prevent infinity loop
        throw AppException('Over loop calc promotion');
      }

      if (calcRs.rsMsgCode == 'W001') {
        LackFreeGoodsOptions lackFreeGoodsOption = calcRs.lackFreeGoods.lackFreeGoodsOptions.first;
        if (tmpLackFreeGoods.any((e1) => e1.promotionId == calcRs.lackFreeGoods.promotionId && e1.lackFreeGoodsOptions.any((e2) => e2.optionOid == lackFreeGoodsOption.optionOid))) {
          // check duplicate pro
          throw AppException('Duplicate LackFreeGoods Pro');
        }

        tmpLackFreeGoods.add(calcRs.lackFreeGoods);

        lackFreeGoodsOption.lackFreeGoodsItems.forEach((e) {

          SalesItem salesItem = calcRq.salesItems.firstWhere((element) => StringUtil.trimLeftZero(element.articleId) == StringUtil.trimLeftZero(e.promotionArtcId) && element.unit == e.unit, orElse: () => null);

          if (salesItem != null) {
            salesItem.qty += e.qty;
          } else {
            // auto add free goods
            calcRq.salesItems.add(SalesItem(
              seqNo: ++seqNo,
              articleId: e.promotionArtcId,
              unit: e.unit,
              qty: e.qty,
            ));
          }

        });
      } else if (calcRs.rsMsgCode == 'W002') {
        calcRq.selectExceptPromotion ??= SelectExceptPromotion();
        calcRq.selectExceptPromotion.selectExceptPromotionItems ??= [];
        calcRq.selectExceptPromotion.selectExceptPromotionItems.add(SelectExceptPromotionItem(
          choice: true,
          promotionId: calcRs.exceptPromotion.promotions.first.promotionId,
        ));
      } else if (calcRs.rsMsgCode == 'W003') {
        calcRq.selectManyOptionPromotion ??= SelectManyOptionPromotion();
        calcRq.selectManyOptionPromotion.selectManyOptionPromotionItems ??= [];
        calcRq.selectManyOptionPromotion.selectManyOptionPromotionItems.add(SelectManyOptionPromotionItem(
          choice: true,
          promotionId: calcRs.manyOptionPromotion.promotionId,
          tierOid: calcRs.manyOptionPromotion.tier.tierOid,
          optionOid: calcRs.manyOptionPromotion.tier.options.first.optionOid,
        ));
      } else if (calcRs.rsMsgCode == 'W004') {
        calcRq.selectExceptTender ??= SelectExceptTender();
        calcRq.selectExceptTender.selectExceptTenderItems ??= [];
        calcRq.selectExceptTender.selectExceptTenderItems.add(SelectExceptTenderItem(
          choice: true,
          promotionId: calcRs.exceptTender.promotionId,
        ));
      } else {
        throw AppException('Invalid calc pro warning case - ${calcRs.rsMsgCode}');
      }

      cntLoop++;
    }

    List<BasketItem> calculatedItems = [];
    List<SalesItem> tmpSalesItems = []..addAll(calcRs.salesItems);

    for (int i = 0; i < items.length; i++) {
      BasketItem item = items[i];
      int seqNo = i + 1;
      List<SalesItem> normalItems = tmpSalesItems.where((s) => isOldItem(s, seqNo) && !s.isFreeGoods).toList();
      num normalQty = normalItems.fold(0, (previousValue, element) => MathUtil.add(previousValue, ((element.qty) ?? 0))) ?? 0;
      List<SalesItem> freeGoodsItems = tmpSalesItems.where((s) => isOldItem(s, seqNo) && s.isFreeGoods).toList();
      num freeGoodsQty = freeGoodsItems.fold(0, (previousValue, element) => MathUtil.add(previousValue, ((element.qty) ?? 0))) ?? 0;

      // print('======================');
      // print('i $i');
      // print('normalItems $normalItems');
      // print('normalQty $normalQty');
      // print('freeGoodsItems $freeGoodsItems');
      // print('freeGoodsQty $freeGoodsQty');

      if (normalQty > 0) {
        calculatedItems.add(BasketItem.calcOldItem(normalItems.first, item, item.key, null, normalQty));
      }
      if (freeGoodsQty > 0) {
        calculatedItems.add(BasketItem.calcOldItem(freeGoodsItems.first, item, item.key, item.key, freeGoodsQty));
      }

      // find child item from promotion id
      tmpSalesItems.removeWhere((s) => isOldItem(s, seqNo)); // remove from tmp
      List<SalesItem> childItems = tmpSalesItems.where((s) => !isOldItem(s, seqNo) && isParentItem(calcRs, item, s) && s.isFreeGoods).toList();
      if (childItems.isNotEmpty) {
        childItems.forEach((childItem) {
          if (StringUtil.isNotEmpty(childItem.articleId)) {
            calculatedItems.add(BasketItem.calcNewItem(childItem, item.key));
          }
        });
        tmpSalesItems.removeWhere((s) => childItems.contains(s)); // remove from tmp
      }
    }

    if (tmpSalesItems.isNotEmpty) {
      tmpSalesItems.forEach((salesItem) {
        if (StringUtil.isNotEmpty(salesItem.articleId)) {
          calculatedItems.add(BasketItem.calcNewItem(salesItem, null));
        }
      });
    }

    return BasketState(
      calculatePromotionCARq: calcRq,
      items: items,
      calculatedItems: calculatedItems,
      netTrnAmt: calcRs.totalTrnAmt,
      totalDiscountAmt: calcRs.totalAllDiscountAmt,
      deliveryFeeAmt: 0,
      unpaidAmt: calcRs.unpaidAmt,
    );
  }

  bool isOldItem(SalesItem salesItem, int seqNo) {
    return salesItem.seqNo == seqNo || salesItem.refSeqNo == seqNo;
  }

  bool isParentItem(CalculatePromotionCARs calcRs, BasketItem item, SalesItem salesItem) {
    return calcRs.promotionRedemption?.promotionSales?.any((ps) => isMatchPromotion(salesItem, ps.promotionId) && ps.promotionSalesItems.any((psi) => StringUtil.trimLeftZero(psi.articleId) == item.getArticleId())) ?? false;
  }

  bool isMatchPromotion(SalesItem salesItem, String promotionId) {
    return salesItem.itemDiscounts?.any((itemDiscount) => itemDiscount.remark == promotionId) ?? false;
  }
}
