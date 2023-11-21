import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/calculate_promotion/calculate_promotion_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_mst_bank_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/cashier_trn.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_hire_purchase_promotion_rq.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/get_hire_purchase_promotion_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/sales_item.dart';
import 'package:flutter_store_catalog/core/models/view/hire_purchase_dto.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_dto.dart';
import 'package:flutter_store_catalog/core/services/salesprmtn/promotion_service.dart';
import 'package:flutter_store_catalog/core/services/salesprmtn/hire_purchase_service.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';
import 'package:flutter_store_catalog/core/utilities/math_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:meta/meta.dart';
import 'package:easy_localization/easy_localization.dart';

part 'hire_purchase_event.dart';

part 'hire_purchase_state.dart';

class HirePurchaseBloc extends Bloc<HirePurchaseEvent, HirePurchaseState> {
  final ApplicationBloc applicationBloc;
  final SalesCartBloc salesCartBloc;
  final CalculatePromotionBloc calcBloc;
  final PromotionService _promotionService = getIt<PromotionService>();
  final HirePurchaseService _hirePurchaseService = getIt<HirePurchaseService>();

  HirePurchaseBloc(this.applicationBloc, this.salesCartBloc, this.calcBloc);

  @override
  HirePurchaseState get initialState => InitialHirePurchaseState();

  @override
  Stream<HirePurchaseState> mapEventToState(HirePurchaseEvent event) async* {
    if (event is InitHirePurchaseEvent) {
      yield InitialHirePurchaseState();
    } else if (event is ResetHirePurchaseEvent) {
      yield ResetHirePurchaseState();
    } else if (event is SelectBankHirePurchaseEvent) {
      yield* mapSelectBankHirePurchaseEvent(event);
    } else if (event is BackPageHirePurchaseEvent) {
      yield* mapBackPageHirePurchaseEvent(event);
    } else if (event is NextPageHirePurchaseEvent) {
      yield* mapNextPageHirePurchaseEvent(event);
    } else if (event is SelectPromotionEvent) {
      yield* mapSelectPromotionEvent(event);
    } else if (event is ConfirmPromotionEvent) {
      yield* mapConfirmPromotionEvent(event);
    }
  }

  Stream<HirePurchaseState> mapSelectBankHirePurchaseEvent(SelectBankHirePurchaseEvent event) async* {
    try {
      yield LoadingHirePurchaseState();

      String hirePurchaseState = HirePurchaseLevel.AIT;
      List<HirePurchasePromotion> promotionList;
      Map<String, List<HirePurchasePromotion>> groupPromotionMap = Map<String, List<HirePurchasePromotion>>();

      if (event.hirePurchaseDto.promotionMap[HirePurchaseLevel.ART].isNotNE) {
        hirePurchaseState = HirePurchaseLevel.ART;
      } else if (event.hirePurchaseDto.promotionMap[HirePurchaseLevel.ART].isNotNE) {
        hirePurchaseState = HirePurchaseLevel.MCH;
      }

      promotionList = event.hirePurchaseDto.promotionMap[hirePurchaseState];

      promotionList = checkVendorAbsorbProcess(promotionList);

      promotionList.forEach((e) {
        List<String> artcIdList = e.lstArticle.map((item) => item.articleId).toList();
        artcIdList.sort((a, b) => a.compareTo(b));

        if (hirePurchaseState == HirePurchaseLevel.ART) {
          artcIdList.forEach((art) {
            groupPromotionMap.update(art, (value) {
              value.add(e);
              return value;
            }, ifAbsent: () => [e]);
          });
        } else {
          String artcIds = artcIdList.join(',');
          groupPromotionMap.update(artcIds, (value) {
            value.add(e);
            return value;
          }, ifAbsent: () => [e]);
        }
      });

      yield ShowPromotionHirePurchaseState(hirePurchaseState: hirePurchaseState, groupPromotionMap: groupPromotionMap, canBack: false, canNext: hirePurchaseState != HirePurchaseLevel.AIT);
    } catch (error, stackTrace) {
      yield ErrorHirePurchaseState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<HirePurchaseState> mapBackPageHirePurchaseEvent(BackPageHirePurchaseEvent event) async* {
    try {
      yield LoadingHirePurchaseState();

      String hirePurchaseState = event.currentState;
      List<HirePurchasePromotion> promotionList;
      Map<String, List<HirePurchasePromotion>> groupPromotionMap = Map<String, List<HirePurchasePromotion>>();

      //Clear Current State Selected
      event.selectPromotion.removeWhere((key, value) => value.group.hierarchyType == hirePurchaseState);

      SalesCartDto salesCartDto = salesCartBloc.state.salesCartDto;
      List<String> selectedArticle = event.selectPromotion.keys.where((key) {
        String backState = HirePurchaseLevel.MCH;
        if (event.currentState == HirePurchaseLevel.MCH) {
          backState = HirePurchaseLevel.ART;
        }

        return event.selectPromotion[key].group.hierarchyType != backState;
      }).toList();
      List<SalesItem> remainArticle = salesCartDto.populateSalesItem.where((e) => !selectedArticle.contains(e.articleId)  && !e.isHomeServiceFreeGoods && !e.isFreeGoods).toList();
      List<HirePurchaseDto> hirePurchaseDtoList = await calcBloc.state.calculateHirePurchase(applicationBloc, _hirePurchaseService, remainArticle);
      HirePurchaseDto hirePurchaseDto = hirePurchaseDtoList.firstWhere((e) => e.mstBank.bankId == event.selectBank.bankId, orElse: () => null);

      if (hirePurchaseState == HirePurchaseLevel.AIT && hirePurchaseDto.promotionMap[HirePurchaseLevel.MCH].isNotNE) {
        hirePurchaseState = HirePurchaseLevel.MCH;
      } else if (hirePurchaseDto.promotionMap[HirePurchaseLevel.ART].isNotNE) {
        hirePurchaseState = HirePurchaseLevel.ART;
      }

      promotionList = hirePurchaseDto?.promotionMap[hirePurchaseState];
      promotionList = checkVendorAbsorbProcess(promotionList);

      promotionList.forEach((e) {
        List<String> artcIdList = e.lstArticle.map((item) => item.articleId).toList();
        artcIdList.sort((a, b) => a.compareTo(b));

        if (hirePurchaseState == HirePurchaseLevel.ART) {
          artcIdList.forEach((art) {
            groupPromotionMap.update(art, (value) {
              value.add(e);
              return value;
            }, ifAbsent: () => [e]);
          });
        } else {
          String artcIds = artcIdList.join(',');
          groupPromotionMap.update(artcIds, (value) {
            value.add(e);
            return value;
          }, ifAbsent: () => [e]);
        }
      });

      List<String> allSelectArticle = event.selectPromotion.keys?.toList() ?? [];
      List<SalesItem> realRemainArticle = salesCartDto.populateSalesItem.where((e) => !allSelectArticle.contains(e.articleId)  && !e.isHomeServiceFreeGoods && !e.isFreeGoods).toList();
      List<String> realRemainArticleIds = realRemainArticle.isNotNE ? realRemainArticle.map((e) => e.articleId).toList() : [];

      List<String> selectedArticleART = allSelectArticle.where((key) => event.selectPromotion[key].group.hierarchyType == HirePurchaseLevel.ART).toList();
      bool havePromotionART = hirePurchaseDto?.promotionMap[HirePurchaseLevel.ART]?.any((e) => e.lstArticle.any((artc) => realRemainArticleIds.contains(artc.articleId))) ?? false;

      List<String> selectedArticleMCH = allSelectArticle.where((key) => event.selectPromotion[key].group.hierarchyType == HirePurchaseLevel.MCH).toList();
      bool havePromotionMCH = hirePurchaseDto?.promotionMap[HirePurchaseLevel.MCH]?.any((e) => e.lstArticle.any((artc) => realRemainArticleIds.contains(artc.articleId))) ?? false;

      List<String> selectedArticleAIT = allSelectArticle.where((key) => event.selectPromotion[key].group.hierarchyType == HirePurchaseLevel.AIT).toList();
      bool havePromotionAIT = hirePurchaseDto?.promotionMap[HirePurchaseLevel.AIT]?.any((e) => e.lstArticle.any((artc) => realRemainArticleIds.contains(artc.articleId))) ?? false;

      bool canBack = hirePurchaseState != HirePurchaseLevel.ART && (selectedArticleART.isNotNE || havePromotionART);
      bool canNext = false;
      if(hirePurchaseState == HirePurchaseLevel.MCH){
        canNext = selectedArticleAIT.isNotNE || havePromotionAIT;
      } else if (hirePurchaseState == HirePurchaseLevel.ART){
        canNext = selectedArticleAIT.isNotNE || havePromotionAIT || selectedArticleMCH.isNotNE || havePromotionMCH;
      }

      yield ShowPromotionHirePurchaseState(
        hirePurchaseState: hirePurchaseState,
        groupPromotionMap: groupPromotionMap,
        canNext: canNext,
        canBack: canBack,
      );
    } catch (error, stackTrace) {
      yield ErrorHirePurchaseState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<HirePurchaseState> mapNextPageHirePurchaseEvent(NextPageHirePurchaseEvent event) async* {
    try {
      yield LoadingHirePurchaseState();

      String hirePurchaseState = event.currentState;
      List<HirePurchasePromotion> promotionList;
      Map<String, List<HirePurchasePromotion>> groupPromotionMap = Map<String, List<HirePurchasePromotion>>();

      SalesCartDto salesCartDto = salesCartBloc.state.salesCartDto;
      List<String> selectedArticle = event.selectPromotion.keys.where((key) {
        String nextState = HirePurchaseLevel.MCH;
        if (event.currentState == HirePurchaseLevel.MCH) {
          nextState = HirePurchaseLevel.AIT;
        }

        return event.selectPromotion[key].group.hierarchyType != nextState;
      }).toList();

      List<SalesItem> remainArticle = salesCartDto.populateSalesItem.where((e) => !selectedArticle.contains(e.articleId)  && !e.isHomeServiceFreeGoods && !e.isFreeGoods).toList();

      List<HirePurchaseDto> hirePurchaseDtoList = await calcBloc.state.calculateHirePurchase(applicationBloc, _hirePurchaseService, remainArticle);
      HirePurchaseDto hirePurchaseDto = hirePurchaseDtoList.firstWhere((e) => e.mstBank.bankId == event.selectBank.bankId, orElse: () => null);

      if (hirePurchaseState == HirePurchaseLevel.ART && hirePurchaseDto.promotionMap[HirePurchaseLevel.MCH].isNotNE) {
        hirePurchaseState = HirePurchaseLevel.MCH;
      } else if (hirePurchaseDto.promotionMap[HirePurchaseLevel.AIT].isNotNE) {
        hirePurchaseState = HirePurchaseLevel.AIT;
      }

      promotionList = hirePurchaseDto?.promotionMap[hirePurchaseState];
      promotionList = checkVendorAbsorbProcess(promotionList);

      promotionList.forEach((e) {
        List<String> artcIdList = e.lstArticle.map((item) => item.articleId).toList();
        artcIdList.sort((a, b) => a.compareTo(b));
        String artcIds = artcIdList.join(',');

        groupPromotionMap.update(artcIds, (value) {
          value.add(e);
          return value;
        }, ifAbsent: () => [e]);
      });

      List<String> allSelectArticle = event.selectPromotion.keys?.toList() ?? [];
      List<SalesItem> realRemainArticle = salesCartDto.populateSalesItem.where((e) => !allSelectArticle.contains(e.articleId)  && !e.isHomeServiceFreeGoods && !e.isFreeGoods).toList();
      List<String> realRemainArticleIds = realRemainArticle.isNotNE ? realRemainArticle.map((e) => e.articleId).toList() : [];

      List<String> selectedArticleART = allSelectArticle.where((key) => event.selectPromotion[key].group.hierarchyType == HirePurchaseLevel.ART).toList();
      bool havePromotionART = hirePurchaseDto?.promotionMap[HirePurchaseLevel.ART]?.any((e) => e.lstArticle.any((artc) => realRemainArticleIds.contains(artc.articleId))) ?? false;

      List<String> selectedArticleMCH = allSelectArticle.where((key) => event.selectPromotion[key].group.hierarchyType == HirePurchaseLevel.MCH).toList();
      bool havePromotionMCH = hirePurchaseDto?.promotionMap[HirePurchaseLevel.MCH]?.any((e) => e.lstArticle.any((artc) => realRemainArticleIds.contains(artc.articleId))) ?? false;

      List<String> selectedArticleAIT = allSelectArticle.where((key) => event.selectPromotion[key].group.hierarchyType == HirePurchaseLevel.AIT).toList();
      bool havePromotionAIT = hirePurchaseDto?.promotionMap[HirePurchaseLevel.AIT]?.any((e) => e.lstArticle.any((artc) => realRemainArticleIds.contains(artc.articleId))) ?? false;

      bool canNext = hirePurchaseState != HirePurchaseLevel.AIT && (selectedArticleAIT.isNotNE || havePromotionAIT);
      bool canBack = false;
      if(hirePurchaseState == HirePurchaseLevel.MCH){
        canBack = selectedArticleART.isNotNE || havePromotionART;
      } else if (hirePurchaseState == HirePurchaseLevel.AIT){
        canBack = selectedArticleART.isNotNE || havePromotionART || selectedArticleMCH.isNotNE || havePromotionMCH;
      }
      yield ShowPromotionHirePurchaseState(
        hirePurchaseState: hirePurchaseState,
        groupPromotionMap: groupPromotionMap,
        canNext: canNext,
        canBack: canBack,
      );
    } catch (error, stackTrace) {
      yield ErrorHirePurchaseState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<HirePurchaseState> mapSelectPromotionEvent(SelectPromotionEvent event) async* {
    try {
      yield LoadingHirePurchaseState();

      String hirePurchaseState = event.hirePurchaseState;

      SalesCartDto salesCartDto = salesCartBloc.state.salesCartDto;
      List<String> selectedArticle = event.selectPromotion.keys.toList();
      List<SalesItem> remainArticle = salesCartDto.populateSalesItem.where((e) => !selectedArticle.contains(e.articleId) && !e.isHomeServiceFreeGoods && !e.isFreeGoods).toList();

      bool canNext = false;
      if (remainArticle.isNotNE) {
        List<HirePurchaseDto> hirePurchaseDtoList = await calcBloc.state.calculateHirePurchase(applicationBloc, _hirePurchaseService, remainArticle);
        HirePurchaseDto hirePurchaseDto = hirePurchaseDtoList.firstWhere((e) => e.mstBank.bankId == event.selectBank.bankId, orElse: () => null);

        if(hirePurchaseDto.isNotNE) {
          if (hirePurchaseState == HirePurchaseLevel.ART) {
            canNext = canNext || hirePurchaseDto.promotionMap[HirePurchaseLevel.MCH].isNotNE;
          } else if (hirePurchaseState == HirePurchaseLevel.MCH) {
            canNext = hirePurchaseDto.promotionMap[HirePurchaseLevel.AIT].isNotNE;
          }
        }

      } else {
        List<String> selectedArticleART = event.selectPromotion.keys.where((key) => event.selectPromotion[key].group.hierarchyType == HirePurchaseLevel.ART).toList();
        List<String> selectedArticleMCH = event.selectPromotion.keys.where((key) => event.selectPromotion[key].group.hierarchyType == HirePurchaseLevel.MCH).toList();
        List<String> selectedArticleAIT = event.selectPromotion.keys.where((key) => event.selectPromotion[key].group.hierarchyType == HirePurchaseLevel.AIT).toList();

        if(hirePurchaseState == HirePurchaseLevel.MCH){
          canNext = selectedArticleAIT.isNotNE;
        } else if (hirePurchaseState == HirePurchaseLevel.ART){
          canNext = selectedArticleAIT.isNotNE || selectedArticleMCH.isNotNE;
        }
      }

      yield ShowPromotionHirePurchaseState(
        hirePurchaseState: event.hirePurchaseState,
        groupPromotionMap: event.groupPromotionMap,
        canNext: canNext,
      );
    } catch (error, stackTrace) {
      yield ErrorHirePurchaseState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<HirePurchaseState> mapConfirmPromotionEvent(ConfirmPromotionEvent event) async* {
    try {
      yield LoadingHirePurchaseState();

      SalesCartDto salesCartDto = salesCartBloc.state.salesCartDto;
      CalculatePromotionCARq calcRq = CalculatePromotionCARq();

      AppSession appSession = applicationBloc.state.appSession;

      calcRq.isSkipWarning = true;
      calcRq.storeId = appSession?.userProfile?.storeId;
      if (StringUtil.isNotEmpty(salesCartDto.salesCart.customer?.memberCardTypeId ?? null)) {
        calcRq.memberCard = calcRq.memberCard ?? MemberCard();
        calcRq.memberCard.rewardMemberCardTypeId = salesCartDto.salesCart.customer?.memberCardTypeId;
      }

      List<HirePurchasePromotion> promotionList = event.selectPromotion.values.toSet().toList();

      CalculatePromotionCARs calcRs;
      List<String> promotionUnderMinAmt = <String>[];

      int cashTrnSeqNo = 0;

      if (promotionList.isNotNE) {
        promotionList.forEach((promotion) {
          List<String> artcList = event.selectPromotion.keys.where((key) => event.selectPromotion[key] == promotion).toList();
          List<SalesCartItem> salesCartItem = salesCartDto.salesCart.salesCartItems.where((item) => artcList.contains(item.articleNo)).toList();
          num unpaidAmt = salesCartItem.fold(0, (previousValue, element) => MathUtil.add(previousValue, element.netItemAmt));

          calcRq.cashierTrns = <CashierTrn>[];
          calcRq.cashierTrns.add(CashierTrn(
            seqNo: ++cashTrnSeqNo,
            refInfo: event.calculatePromotionCARs.suggestTenders
                    ?.firstWhere(
                      (e) => e.crCardId == promotion.group.creditCardType,
                      orElse: () => null,
                    )
                    ?.crCardNoDummy ??
                'xxxxxxxxxxxxxxxx',
            tenderId: promotion.group.tenderId,
            trnAmt: unpaidAmt,
            promotionId: promotion.promotion.promotionId,
          ));
        });

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

        calcRs = await calcBloc.state.calculatePromotion(appSession, _promotionService, calcRq, salesCartDto);

        List<SalesItem> populateSalesItem = calcBloc.state.populateCouponDiscount(applicationBloc, calcRs, maxDummyCashTrnSeq: cashTrnSeqNo);

        promotionList.forEach((promotion) {
          List<String> artcIds = event.selectPromotion.keys.where((e) => event.selectPromotion[e].promotion.promotionId == promotion.promotion.promotionId).toList();
          num totalAmt = 0;
          artcIds.forEach((element) {
            SalesItem salesItem = populateSalesItem.firstWhere((item) => item.articleId == element, orElse: () => null);
            if(salesItem.isNotNull){
              totalAmt = MathUtil.add(totalAmt, salesItem.netItemAmt);
            }
          });

          if(promotion.minAmtPerTicket.compareTo(totalAmt) == 1){
            promotionUnderMinAmt.add(promotion.promotion.promotionId);
          }
        });

        salesCartDto.populateSalesItemForPay = populateSalesItem;
      }

      if(promotionUnderMinAmt.isNotNE){
        promotionUnderMinAmt.forEach((element) {
          event.selectPromotion.removeWhere((key, value) => value.promotion.promotionId == element);
        });
      }

      salesCartDto.selectPromotionMap = event.selectPromotion;

      //Clear Dummy Cashier Trn
      if(calcRs.isNotNull) {
        calcRs.cashierTrns = calcRs.cashierTrns?.where((e) => e.seqNo > cashTrnSeqNo)?.toList();
      }

      yield ConfirmedPromotionState(calcRs, promotionUnderMinAmt);
    } catch (error, stackTrace) {
      yield ErrorHirePurchaseState(AppException(error, stackTrace: stackTrace));
    }
  }

  List<HirePurchasePromotion> checkVendorAbsorbProcess(List<HirePurchasePromotion> lstHirePurchase) {
    List<HirePurchasePromotion> lstVerdorHirePurchase = <HirePurchasePromotion>[];
    List<HirePurchasePromotion> lstTmpHirePurchase = <HirePurchasePromotion>[];
    lstVerdorHirePurchase = lstHirePurchase.where((e) => e.group.vendorAbsorb == 'Y').toList();

    for (HirePurchasePromotion hirePurchase in lstHirePurchase) {
      List<String> itemIncludes = hirePurchase.group.itemIncludeList.map((e) => e.hierarchyId).toList();
      if (hirePurchase.group.vendorAbsorb == 'Y' ||
          !lstVerdorHirePurchase.any(
            (e) =>
                e.group.hierarchyType == hirePurchase.group.hierarchyType &&
                e.group.creditCardType == hirePurchase.group.creditCardType &&
                e.group.tenderNo == hirePurchase.group.tenderNo &&
                e.group.tenderId == hirePurchase.group.tenderId &&
                e.promotion.month == hirePurchase.promotion.month &&
                e.promotion.percentDiscount == hirePurchase.promotion.percentDiscount &&
                !e.group.itemIncludeList.any(
                  (element) => !itemIncludes.contains(
                    element.hierarchyId,
                  ),
                ),
          )) {
        lstTmpHirePurchase.add(hirePurchase);
      }
    }
    return lstTmpHirePurchase;
  }
}
