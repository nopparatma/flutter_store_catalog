part of 'calculate_promotion_bloc.dart';

@immutable
abstract class CalculatePromotionState {
  Future<CalculatePromotionCARs> calculatePromotion(AppSession appSession, PromotionService promotionService, CalculatePromotionCARq calcRq, SalesCartDto salesCartDto, {isCalForOnline = false}) async {
    const int MAX_LOOP = 10;
    int cntLoop = 0;
    List<LackFreeGoods> tmpLackFreeGoods = [];

    int seqNo = calcRq.salesItems.last.seqNo;

    CalculatePromotionCARs calcRs;
    num sumFreeGoodsAmt = 0;
    while (true) {
      calcRs = await promotionService.calculatePromotionCA(appSession, calcRq);

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

        String promotionId = calcRs.lackFreeGoods.promotionId;
        tmpLackFreeGoods.add(calcRs.lackFreeGoods);

        lackFreeGoodsOption.lackFreeGoodsItems.forEach((e) {
          // auto add free goods
          calcRq.salesItems.add(SalesItem(
            seqNo: ++seqNo,
            articleId: e.promotionArtcId,
            unit: e.unit,
            qty: e.qty,
          ));
        });

        // For Adjust CashTrn after get Free Goods
        List<CashierTrn> tmpCashTrn = <CashierTrn>[]..addAll(calcRq.cashierTrns);
        calcRq.cashierTrns.clear();
        calcRs = await promotionService.calculatePromotionCA(appSession, calcRq);

        calcRq.salesItems = calcRs.salesItems;
        num freeGoodAmt = calcRs.salesItems.firstWhere((e) => e.seqNo == seqNo).netItemAmt;
        sumFreeGoodsAmt = MathUtil.add(sumFreeGoodsAmt, freeGoodAmt);
        tmpCashTrn.firstWhere((e) => e.seqNo == 1).trnAmt = MathUtil.add(tmpCashTrn.firstWhere((e) => e.seqNo == 1).trnAmt, sumFreeGoodsAmt);
        calcRq.cashierTrns = tmpCashTrn;

        if (isCalForOnline) {
          await checkFreeGoodsTender(appSession, calcRq, calcRs, salesCartDto, lackFreeGoodsOption.lackFreeGoodsItems, promotionId);
          if (salesCartDto.exceptLackFreeGoods.isNotNull) {
            return null;
          }
        }
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

    //Clear Discount Because Free Goods
    calcRs.totalAllDiscountAmt = MathUtil.add(calcRs.totalAllDiscountAmt, sumFreeGoodsAmt);
    calcRs.totalTrnAmt = MathUtil.subtract(calcRs.totalTrnAmt, sumFreeGoodsAmt);

    //Map SalesCartOid
    // calcRs.salesItems.forEach((e) {
    //   SalesItem salesItem = calcRq.salesItems.firstWhere((item) => item.seqNo == e.seqNo, orElse: () => null);
    //   e.refSeqNo = salesItem?.refSeqNo;
    // });

    //Sort Suggest Tender
    if (calcRs.suggestTenders.isNotNE) {
      List<SuggestTender> tenderHPCD = calcRs.suggestTenders.where((e) => e.tenderId == TenderIdOfCardNetwork.HPCD).toList();
      List<SuggestTender> tenderExceptHPCD = calcRs.suggestTenders.where((e) => e.tenderId != TenderIdOfCardNetwork.HPCD).toList();
      tenderExceptHPCD.sort((a, b) {
        return a.trnAmt.compareTo(b.trnAmt);
      });

      calcRs.suggestTenders = <SuggestTender>[];
      if (tenderHPCD.isNotNE) calcRs.suggestTenders.addAll(tenderHPCD);
      if (tenderExceptHPCD.isNotNE) calcRs.suggestTenders.addAll(tenderExceptHPCD);
    }

    return calcRs;
  }

  Future<List<HirePurchaseDto>> calculateHirePurchase(ApplicationBloc applicationBloc, HirePurchaseService hirePurchaseService, List<SalesItem> populateSalesItem, {bool isCheckPrice = false}) async {
    AppSession appSession = applicationBloc.state.appSession;

    GetHirePurchasePromotionRs getHirePurchasePromotionRs;
    List<HirePurchaseDto> hirePurchaseList = <HirePurchaseDto>[];

    GetHirePurchasePromotionRq getHirePurchasePromotionRq = GetHirePurchasePromotionRq();

    if(isCheckPrice) getHirePurchasePromotionRq.hierarchyType = HirePurchaseLevel.ART;

    List<ArticleList> articleLists = <ArticleList>[];

    for (num i = 0; i < populateSalesItem.length; i++) {
      SalesItem item = populateSalesItem[i];

      if (item.isFreeGoods || item.isHomeServiceFreeGoods) continue;

      ArticleList articleList = ArticleList();
      articleList.seqNo = (i + 1);
      articleList.articleId = item.articleId;
      articleList.totalAmount = item.netItemAmt;
      articleList.qty = item.qty;
      articleList.pricePerUnit = item.price;
      articleLists.add(articleList);
    }

    getHirePurchasePromotionRq.articleList = articleLists;
    getHirePurchasePromotionRq.storeId = appSession.userProfile.storeId;
    getHirePurchasePromotionRq.tranDate = appSession.transactionDateTime;

    getHirePurchasePromotionRs = await hirePurchaseService.getHirePurchasePromotion(appSession, getHirePurchasePromotionRq);

    if (getHirePurchasePromotionRs.mailList.isNotNE) {
      getHirePurchasePromotionRs.mailList.forEach((mail) {
        for (GroupList group in mail.groupList) {
          MstBank mstBank = applicationBloc.state.getMstBankRs.mstBanks.firstWhere(
              (bank) =>
                  bank.creditCardBos?.any(
                    (a) => a.creditCardId == group.creditCardType,
                  ) ??
                  false,
              orElse: () => null);

          if (mstBank == null) continue;

          group.promotionList.forEach((promotion) {
            HirePurchasePromotion hirePurchase = HirePurchasePromotion();
            hirePurchase.promotion = promotion;
            hirePurchase.periodStart = mail.periodStart;
            hirePurchase.periodEnd = mail.periodEnd;
            hirePurchase.mailId = mail.mailId;
            hirePurchase.group = group;
            hirePurchase.minAmtPerTicket = group.minAmtPerTicket;
            hirePurchase.lstArticle = group.articleList.map((e) => populateSalesItem.firstWhere((item) => item.articleId == e.articleId)).toList();

            if (hirePurchaseList.any((e) => e.mstBank == mstBank)) {
              HirePurchaseDto hirePurcDto = hirePurchaseList.firstWhere((e) => e.mstBank == mstBank);

              hirePurcDto.promotionMap.update(group.hierarchyType, (value) {
                value.add(hirePurchase);
                return value;
              }, ifAbsent: () => [hirePurchase]);
            } else {
              Map<String, List<HirePurchasePromotion>> promotionMap = Map<String, List<HirePurchasePromotion>>();
              promotionMap.putIfAbsent(group.hierarchyType, () => [hirePurchase]);
              HirePurchaseDto hirePurcDto = HirePurchaseDto();
              hirePurcDto.mstBank = mstBank;
              hirePurcDto.promotionMap = promotionMap;
              hirePurchaseList.add(hirePurcDto);
            }
          });
        }
      });
    }

    sortShowHirePurchase(hirePurchaseList);
    return hirePurchaseList;
  }

  List<SalesItem> populateCouponDiscount(ApplicationBloc applicationBloc, CalculatePromotionCARs calculatePromotionCARs, {num maxDummyCashTrnSeq = 0}) {
    List<SalesItem> salesItems = List<SalesItem>.from(calculatePromotionCARs.salesItems);

    String articleDeliveryFee = applicationBloc.state.sysCfgMap[SystemConfig.ART_DELIVERY_FEE];
    List<String> articleDeliveryFeeList = articleDeliveryFee.split(',');

    List<CashierTrn> cashierTrns = List<CashierTrn>.from(calculatePromotionCARs.cashierTrns ?? []);
    List<PromotionSales> promotionSalesBos = calculatePromotionCARs.promotionRedemption?.promotionSales;

    //Merge Item
    Map<String, SalesItem> mergeItem = Map<String, SalesItem>();
    salesItems.forEach((item) {
      if (!item.mainUpc.isNullEmptyOrWhitespace && !(item.isFreeGoods || item.isHomeServiceFreeGoods)) {
        mergeItem.update(item.mainUpc, (value) {
          value.qty = MathUtil.add(value.qty, item.qty);
          value.netItemAmt = MathUtil.add(value.netItemAmt, item.netItemAmt);
          if (item.itemDiscounts.isNotNE) value.itemDiscounts?.addAll(item.itemDiscounts);
          if (item.itemDiscountManuals.isNotNE) value.itemDiscountManuals?.addAll(item.itemDiscountManuals);

          return value;
        }, ifAbsent: () => item);
      }
    });

    salesItems = mergeItem.values.toList();

    cashierTrns = cashierTrns.where((e) => e.seqNo > maxDummyCashTrnSeq).toList();
    cashierTrns.sort((a, b) => a.trnAmt.compareTo(b.trnAmt));
    for (final cashierData in cashierTrns) {
      num discountTenderAmount = 0;
      List<String> artcPromotionList = <String>[];

      if (promotionSalesBos != null && promotionSalesBos.isNotNE && StringUtil.isNotEmpty(cashierData.promotionId)) {
        for (PromotionSales item in promotionSalesBos) {
          if (item.promotionId == cashierData.promotionId) {
            discountTenderAmount = cashierData.trnAmt;
            if (item.promotionSalesItems != null && item.promotionSalesItems.isNotNE) {
              for (PromotionSalesItems itemSalesBo in item.promotionSalesItems) {
                artcPromotionList.add(itemSalesBo.articleId);
              }
            }
          }
        }
      } else {
        discountTenderAmount = cashierData.trnAmt;
      }

      num netSalesAmount = 0;
      int lastItemPromotionIndex = 0;

      for (int i = 0; i < salesItems.length; i++) {
        SalesItem item = salesItems[i];

        if (StringUtil.isNullOrEmpty(item.articleId) || articleDeliveryFeeList.contains(item.articleId)) {
          continue;
        }

        if (artcPromotionList != null && artcPromotionList.isNotNE) {
          if (artcPromotionList.contains(item.articleId)) {
            netSalesAmount = MathUtil.add(netSalesAmount, item.netItemAmt);
            lastItemPromotionIndex = i;
          }
        } else {
          netSalesAmount = MathUtil.add(netSalesAmount, item.netItemAmt);
          lastItemPromotionIndex = i;
        }
      }

      num discountAmountTran = discountTenderAmount;
      List<SalesItem> lstCloneSalesItem = List<SalesItem>.from(salesItems);

      for (int i = 0; i < lstCloneSalesItem.length; i++) {
        SalesItem tmpHirePurcItem = lstCloneSalesItem[i];
        SalesItem hirePurcItem = salesItems[i];

        if (StringUtil.isNullOrEmpty(tmpHirePurcItem.articleId)) {
          continue;
        }

        if (i == lastItemPromotionIndex) {
          hirePurcItem.netItemAmt = MathUtil.subtract(hirePurcItem.netItemAmt, discountAmountTran);
          hirePurcItem.price = num.parse(MathUtil.divide(hirePurcItem.netItemAmt, hirePurcItem.qty).toStringAsFixed(2));
          break;
        } else if (artcPromotionList != null && artcPromotionList.isNotNE) {
          if (artcPromotionList.contains(tmpHirePurcItem.articleId)) {
            num averagePercentItem = num.parse(MathUtil.multiple(discountTenderAmount, MathUtil.divide(tmpHirePurcItem.netItemAmt, netSalesAmount)).toStringAsFixed(2));
            num discount = averagePercentItem;

            hirePurcItem.netItemAmt = MathUtil.subtract(hirePurcItem.netItemAmt, discount);
            hirePurcItem.price = num.parse(MathUtil.divide(hirePurcItem.netItemAmt, hirePurcItem.qty).toStringAsFixed(2));
            discountAmountTran -= discount;
          }
        } else {
          num averagePercentItem = num.parse(MathUtil.multiple(discountTenderAmount, MathUtil.divide(tmpHirePurcItem.netItemAmt, netSalesAmount)).toStringAsFixed(2));
          num discount = averagePercentItem;

          hirePurcItem.netItemAmt = MathUtil.subtract(hirePurcItem.netItemAmt, discount);
          hirePurcItem.price = num.parse(MathUtil.subtract(hirePurcItem.netItemAmt, hirePurcItem.qty).toStringAsFixed(2));
          discountAmountTran = MathUtil.subtract(discountAmountTran, discount);
        }
      }
    }

    return salesItems;
  }

  void sortShowHirePurchase(List<HirePurchaseDto> hirePurchaseList) {
    hirePurchaseList.forEach((e) {
      e.promotionMap.values.forEach((promotionList) {
        promotionList.sort((a, b) {
          int c = a.group.creditCardType.compareTo(b.group.creditCardType);
          if (c == 0) {
            c = (b.promotion.percentDiscount ?? 0).compareTo(a.promotion.percentDiscount ?? 0);

            if (c == 0) {
              c = (b.promotion.month ?? 0).compareTo(a.promotion.month ?? 0);
            }
          }
          return c;
        });
      });
    });
  }

  Future<void> checkFreeGoodsTender(AppSession appSession, CalculatePromotionCARq calculatePromotionCARq, CalculatePromotionCARs calculatePromotionCARs, SalesCartDto salesCartDto, List<LackFreeGoodsItems> lackFreeGoodsItems, String promotionId) async {
    final SaleOrderService _saleOrderService = getIt<SaleOrderService>();
    final PromotionBkoffcService _bkOffcpromotionService = PromotionBkoffcService();
    final StockService _stockService = getIt<StockService>();

    SalesCart salesCart = salesCartDto.salesCart;

    for (LackFreeGoodsItems freeGoodItem in lackFreeGoodsItems) {
      SalesCartItem salesCartItem = SalesCartItem(
        articleNo: freeGoodItem.promotionArtcId,
        itemDescription: freeGoodItem.promotionArtcDesc,
        qty: freeGoodItem.qty,
        qtyRemain: 0,
        unit: freeGoodItem.unit,
        salesCartItemOid: 0,
      );

      GetArticleForSalesCartItemRq getArticleForSalesCartItemRq = GetArticleForSalesCartItemRq(
        searchData: freeGoodItem.promotionArtcId,
        storeId: appSession.userProfile.storeId,
        unit: freeGoodItem.unit,
      );
      GetArticleForSalesCartItemRs getArticleForSalesCartItemRs = await _saleOrderService.getArticleForSalesCartItem(appSession, getArticleForSalesCartItemRq);

      SearchArticle searchArticle = getArticleForSalesCartItemRs.searchArticle;

      salesCartItem.articleNo = searchArticle.articleId;
      salesCartItem.isLotReq = searchArticle.isLotReq;
      salesCartItem.isPriceReq = searchArticle.isPriceRequired;
      salesCartItem.isQtyReq = searchArticle.isLotReq;
      salesCartItem.itemUpc = searchArticle.itemUpc;
      salesCartItem.mchId = searchArticle.mchId;
      salesCartItem.netItemAmt = 0;
      salesCartItem.unitPrice = searchArticle.getUnitPrice();
      salesCartItem.isInstallSameDay = getArticleForSalesCartItemRs.searchArticle.isFreeInstallService;
      salesCartItem.isMainPrd = getArticleForSalesCartItemRs.searchArticle.isFreeInstallService;
      salesCartItem.isPremium = true;

      GetPromotionRq getPromotionRq = GetPromotionRq(promotionId: promotionId);
      GetPromotionRs getPromotionRs = await _bkOffcpromotionService.getPromotion(appSession, getPromotionRq);

      String deliveryMng = '';
      num salesOrderItemOid;

      if (getPromotionRs.promotions.article != null) {
        if (salesCart.salesOrders != null) {
          outerLoop:
          for (SalesOrder salesOrder in salesCart.salesOrders) {
            for (SalesOrderGroup salesOrderGroup in salesOrder.salesOrderGroups) {
              for (SalesOrderItem salesOrderItem in salesOrderGroup.salesOrderItems) {
                if (getPromotionRs.promotions.article.articleId.padLeft(18, '0') == salesOrderItem.articleNo.padLeft(18, '0')) {
                  deliveryMng = salesOrderItem.deliverySite;
                  salesOrderItemOid = salesOrderItem.salesOrderItemOid;
                  break outerLoop;
                }
              }
            }
          }
        }
      } else if (getPromotionRs.promotions.hierarchyConditions != null) {
        if (salesCart.salesOrders != null) {
          outerLoop:
          for (HierarchyConditions hierarchy in getPromotionRs.promotions.hierarchyConditions) {
            if (hierarchy.productHierarchy.level == 9) {
              deliveryMng = '';
              break;
            }
            for (SalesOrder salesOrder in salesCart.salesOrders) {
              for (SalesOrderGroup salesOrderGroup in salesOrder.salesOrderGroups) {
                for (SalesOrderItem salesOrderItem in salesOrderGroup.salesOrderItems) {
                  if (hierarchy.productHierarchy.level == 1) {
                    if (hierarchy.productHierarchyId == salesOrderItem.mainUPC) {
                      deliveryMng = salesOrderItem.deliverySite;
                      salesOrderItemOid = salesOrderItem.salesOrderItemOid;
                      break outerLoop;
                    }
                  } else if (hierarchy.productHierarchy.level == 2) {
                    if (hierarchy.productHierarchyId.padLeft(18, '0') == salesOrderItem.articleNo.padLeft(18, '0')) {
                      deliveryMng = salesOrderItem.deliverySite;
                      salesOrderItemOid = salesOrderItem.salesOrderItemOid;
                      break outerLoop;
                    }
                  } else {
                    if (salesOrderItem.mc9 != null && salesOrderItem.mc9.startsWith(hierarchy.productHierarchyId)) {
                      deliveryMng = salesOrderItem.deliverySite;
                      salesOrderItemOid = salesOrderItem.salesOrderItemOid;
                      break outerLoop;
                    }
                  }
                }
              }
            }
          }
        }
      }

      if (StringUtil.isNullOrEmpty(deliveryMng)) {
        outerLoop:
        for (SalesOrder salesOrder in salesCart.salesOrders) {
          for (SalesOrderGroup salesOrderGroup in salesOrder.salesOrderGroups) {
            for (SalesOrderItem salesOrderItem in salesOrderGroup.salesOrderItems) {
              deliveryMng = salesOrderItem.deliverySite;
              salesOrderItemOid = salesOrderItem.salesOrderItemOid;
              break outerLoop;
            }
          }
        }
      }

      if (StringUtil.isNullOrEmpty(deliveryMng)) {
        throw AppException('จ่ายไม่ได้เพราะได้ของแถม Tender แต่ไม่สามารถจองคิวของแถมได้');
      }

      GetStockRq getStockRq = GetStockRq();
      getStockRq.storeId = deliveryMng;
      getStockRq.sapArticles = <SapArticles>[];
      if (salesCartItem.isSalesSet == null || !salesCartItem.isSalesSet) {
        getStockRq.sapArticles.add(
          SapArticles(
            articleNo: salesCartItem.articleNo,
            articleName: salesCartItem.itemDescription,
            unit: salesCartItem.unit,
          ),
        );
      }
      getStockRq.isAllSite = false;
      if (salesCartItem.articleSets != null) {
        salesCartItem.articleSets.forEach((artcSet) {
          getStockRq.sapArticles.add(SapArticles()
            ..articleNo = artcSet.articleNo
            ..articleName = artcSet.itemDescription
            ..unit = artcSet.unit);
        });
      }

      GetStockRs getStockRs = await _stockService.getStock(appSession, getStockRq);

      num stockQty = 0;
      List<String> listDc = ShippingPointConstants.DS_CODE_LIST.split(',');
      bool isDc = listDc.contains(getStockRq.storeId);

      if (isDc) {
        List<StockStores> stockDCList = getStockRs.stock.dcStockStores;
        if (stockDCList != null && stockDCList.isNotEmpty) {
          stockDCList.forEach((stockDc) {
            if (stockDc.stockStoreArticleBos != null && stockDc.stockStoreArticleBos.isNotEmpty) {
              stockQty = MathUtil.add(stockQty, stockDc.stockStoreArticleBos[0].availableQty ?? 0);
            }
          });
        }
      } else {
        StockStores stock = getStockRs.stock.storeStockStore;
        if (stock.stockStoreArticleBos != null && stock.stockStoreArticleBos.isNotEmpty) {
          stockQty = MathUtil.add(stockQty, stock.stockStoreArticleBos[0].availableQty ?? 0);
        }
      }

      if (stockQty <= 0) {
        salesCartDto.exceptLackFreeGoods = SelectLackFreeGoods();
        salesCartDto.exceptLackFreeGoods.selectLackFreeGoodsItems = <SelectLackFreeGoodsItem>[]..add(
            SelectLackFreeGoodsItem(choice: true, promotionId: promotionId),
          );
        return;
      }

      salesCartDto.lackFreeGoodsSalesCartItemMap.update(salesOrderItemOid, (value) {
        value.add(salesCartItem);
        return value;
      }, ifAbsent: () => [salesCartItem]);
    }
  }
}

class InitialCalculatePromotionState extends CalculatePromotionState {
  @override
  String toString() {
    return 'InitialCalculatePromotionState{}';
  }
}

class CalculatedState extends CalculatePromotionState {
  final CalculatePromotionCARs calcRs;
  final List<SalesCartItem> items;
  final List<SalesItem> calculatedItems;
  final List<SuggestTender> suggestTender;
  final num netTrnAmt;
  final num deliveryFeeAmt;
  final num totalDiscountAmt;
  final num unpaidAmt;

  CalculatedState({
    this.calcRs,
    this.items,
    this.calculatedItems,
    this.suggestTender,
    this.netTrnAmt = 0,
    this.deliveryFeeAmt = 0,
    this.totalDiscountAmt = 0,
    this.unpaidAmt = 0,
  });
}

class SelectedTenderState extends CalculatePromotionState {
  final CalculatePromotionCARs calcRs;
  final List<SuggestTender> suggestTender;
  final num netTrnAmt;
  final num deliveryFeeAmt;
  final num totalDiscountAmt;
  final num unpaidAmt;

  SelectedTenderState({this.calcRs, this.suggestTender, this.netTrnAmt = 0, this.deliveryFeeAmt = 0, this.totalDiscountAmt = 0, this.unpaidAmt = 0});

  @override
  String toString() {
    return 'SelectedTenderState{suggestTender: $suggestTender, netTrnAmt: $netTrnAmt, deliveryFeeAmt: $deliveryFeeAmt, totalDiscountAmt: $totalDiscountAmt, $unpaidAmt: unpaidAmt}';
  }
}

class CheckPriceState extends CalculatePromotionState {
  final num totalAmount;
  final List<SuggestTender> tenderList;
  final List<SuggestTender> otherTenderList;
  final Map<MstBank, List<HirePurchasePromotion>> hirePurchaseMap;

  CheckPriceState({this.totalAmount, this.tenderList, this.otherTenderList, this.hirePurchaseMap});

  @override
  String toString() {
    return 'CheckPriceState{totalAmount: $totalAmount, tenderList: $tenderList, otherTenderList: $otherTenderList, hirePurchaseDtoList: $hirePurchaseMap}';
  }
}

class CalculateHirePurchaseState extends CalculatePromotionState {
  final GetHirePurchasePromotionRs getHirePurchasePromotionRs;

  CalculateHirePurchaseState({this.getHirePurchasePromotionRs});
}

class LoadingCalculatePromotionState extends CalculatePromotionState {
  @override
  String toString() {
    return 'LoadingCalculatePromotionState{}';
  }
}

class ErrorFreeGoodsNotHaveStockState extends CalculatePromotionState {
  ErrorFreeGoodsNotHaveStockState();

  @override
  String toString() {
    return 'ErrorFreeGoodsNotHaveStockState';
  }
}

class ErrorCalculatePromotionState extends CalculatePromotionState {
  final error;

  ErrorCalculatePromotionState(this.error);

  @override
  String toString() {
    return 'ErrorCalculatePromotionState{error: $error}';
  }
}
