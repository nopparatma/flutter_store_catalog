import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/basket/basket_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/update_sales_cart_customer_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/update_sales_cart_customer_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/get_checklist_Information_question_rs.dart' as CheckListQuestionRs;
import 'package:flutter_store_catalog/core/models/ecat/get_article_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/save_sales_cart_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/save_sales_cart_rs.dart';
import 'package:flutter_store_catalog/core/models/view/basket_item.dart';
import 'package:flutter_store_catalog/core/services/dotnet/transaction_service.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:meta/meta.dart';
import 'package:flutter_store_catalog/core/models/dotnet/transaction_salescart_checklist_rq.dart' as TransactionSalesCartRq;
import 'package:flutter_store_catalog/core/models/dotnet/transaction_salescart_checklist_rs.dart' as TransactionSalesCartRs;

part 'save_sales_cart_event.dart';

part 'save_sales_cart_state.dart';

class SaveSalesCartBloc extends Bloc<SaveSalesCartEvent, SaveSalesCartState> {
  final BasketBloc basketBloc;
  final CategoryService _categoryService = getIt<CategoryService>();
  final TransactionService transactionService = getIt<TransactionService>();
  final SaleOrderService _saleOrderService = getIt<SaleOrderService>();
  final ApplicationBloc applicationBloc;

  SaveSalesCartBloc(this.basketBloc, this.applicationBloc);

  @override
  SaveSalesCartState get initialState => InitialSaveSalesCartState();

  @override
  Stream<SaveSalesCartState> mapEventToState(SaveSalesCartEvent event) async* {
    if (event is SaveSalesCartWithCustomerEvent) {
      yield* mapEventSaveSalesCartWithCustomerToState(event);
    } else if (event is SaveSalesCartWithPhoneNoEvent) {
      yield* mapEventSaveSalesCartWithPhoneNoToState(event);
    } else if (event is SalesCartUpdateCustomerEvent) {
      yield* mapSalesCartUpdateCustomerEventToState(event);
    }
  }

  Stream<SaveSalesCartState> mapEventSaveSalesCartWithCustomerToState(SaveSalesCartWithCustomerEvent event) async* {
    try {
      yield SaveSalesCartLoadingState();

      List<BasketItem> listItemBasket = basketBloc.state.calculatedItems;
      if (listItemBasket == null || listItemBasket.isEmpty) {
        yield SaveSalesCartErrorState(AppException('warning.sales.cart.empty'.tr(), errorType: ErrorType.WARNING));
        return;
      }

      AppSession appSession = applicationBloc.state.appSession;

      //Save SalesCartCheckList
      await saveSalesCartCheckList(listItemBasket);

      SaveSalesCartRq saveSalesCartRq = SaveSalesCartRq();
      saveSalesCartRq.salesCartBo = event.salesCart ??
          SalesCart(
            lastUpdateUser: appSession.userProfile.empId,
            store: Store(storeId: appSession.userProfile.storeId),
            telephoneNo: event.customer.phoneNumber1,
            transactionDate: appSession.transactionDateTime,
            trnDate: appSession.transactionDateTime,
            createUser: appSession.userProfile.empId,
            salesChannel: SellChannel.SALES_CHANNEL,
            customer: Customer(customerOid: event.customer.customerOid),
          );
      saveSalesCartRq.salesCartBo.salesCartItems = listItemBasket
          .map(
            (e) => new SalesCartItem(
              articleNo: e.article.articleId,
              unit: e.article.unitList[0].unit,
              qty: e.qty,
              qtyRemain: e.qty,
              installCheckListId: e.checkListData != null && e.checkListData.sgTrnItemOid != null ? e.checkListData.sgTrnItemOid : null,
              refMainItemIndex: e.keyOfMainItem != null ? listItemBasket.indexOf(listItemBasket.firstWhere((t) => t.key == e.keyOfMainItem)) : null,
              isPremium: e.isFreeItem,
              isPremiumService: e.isFreeService,
              isMainInstall: e.isInstallService,
              isSpecialOrder: e.isSpecialOrder,
              isSpecialDts: e.isSpecialDts,
              isInstallSameDay: e.checkListData != null,
            ),
          )
          .toList();

      for (SalesCartItem salesCartItems in saveSalesCartRq.salesCartBo.salesCartItems) {
        GetArticleForSalesCartItemRq getArticleForSalesCartItemRq = GetArticleForSalesCartItemRq();
        getArticleForSalesCartItemRq.searchData = salesCartItems.articleNo;
        getArticleForSalesCartItemRq.storeId = appSession.userProfile.storeId;

        GetArticleForSalesCartItemRs getArticleForSalesCartItemRs = await _saleOrderService.getArticleForSalesCartItem(appSession, getArticleForSalesCartItemRq);
        SearchArticle searchArticle = getArticleForSalesCartItemRs.searchArticle;

        salesCartItems.articleNo = searchArticle.articleId;
        salesCartItems.isLotReq = searchArticle.isLotReq;
        salesCartItems.isPriceReq = searchArticle.isPriceRequired;
        salesCartItems.isQtyReq = searchArticle.isLotReq;
        salesCartItems.itemDescription = searchArticle.articleDescription;
        salesCartItems.itemUpc = searchArticle.itemUpc;
        salesCartItems.mchId = searchArticle.mchId;
        salesCartItems.netItemAmt = searchArticle.getUnitPrice() * salesCartItems.qty;
        salesCartItems.unit = searchArticle.sellUnit;
        salesCartItems.unitPrice = searchArticle.getUnitPrice();
      }

      SaveSalesCartRs saveSalesCartRs = await _saleOrderService.saveSalesCart(appSession, saveSalesCartRq);

      yield SaveSalesWithCustomerSuccessState(saveSalesCartRs.salesCartOid, saveSalesCartRs.isScatException);
    } catch (error, stackTrace) {
      yield SaveSalesCartErrorState(AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<SaveSalesCartState> mapEventSaveSalesCartWithPhoneNoToState(SaveSalesCartWithPhoneNoEvent event) async* {
    try {
      yield SaveSalesCartLoadingState();

      List<BasketItem> listItemBasket = basketBloc.state.calculatedItems;
      if (listItemBasket == null || listItemBasket.isEmpty) {
        yield SaveSalesCartErrorState(AppException('warning.sales.cart.empty'.tr(), errorType: ErrorType.WARNING));
        return;
      }
      if (StringUtil.isNullOrEmpty(event.phoneNo)) {
        yield SaveSalesCartErrorState(AppException('warning.please_specify_phone_number'.tr(), errorType: ErrorType.WARNING));
        return;
      }
      if (event.phoneNo.length != 10) {
        yield SaveSalesCartErrorState(AppException('warning.invalid_phone_number'.tr(), errorType: ErrorType.WARNING));
        return;
      }
      AppSession appSession = applicationBloc.state.appSession;

      //Save SalesCartCheckList
      await saveSalesCartCheckList(listItemBasket);

      SaveSalesCartRq saveSalesCartRq = SaveSalesCartRq();
      saveSalesCartRq.salesCartBo = event.salesCart ??
          SalesCart(
            lastUpdateUser: appSession.userProfile.empId,
            store: Store(storeId: appSession.userProfile.storeId),
            telephoneNo: event.phoneNo,
            transactionDate: appSession.transactionDateTime,
            trnDate: appSession.transactionDateTime,
            createUser: appSession.userProfile.empId,
            salesChannel: SellChannel.SALES_CHANNEL,
          );
      saveSalesCartRq.salesCartBo.salesCartItems = listItemBasket
          .map(
            (e) => new SalesCartItem(
              articleNo: e.article.articleId,
              unit: e.article.unitList[0].unit,
              qty: e.qty,
              qtyRemain: e.qty,
              installCheckListId: e.checkListData != null && e.checkListData.sgTrnItemOid != null ? e.checkListData.sgTrnItemOid : null,
              refMainItemIndex: e.keyOfMainItem != null ? listItemBasket.indexOf(listItemBasket.firstWhere((t) => t.key == e.keyOfMainItem)) : null,
              isPremium: e.isFreeItem,
              isPremiumService: e.isFreeService,
              isMainInstall: e.isInstallService,
              isInstallSameDay: e.checkListData != null,
            ),
          )
          .toList();

      for (SalesCartItem salesCartItems in saveSalesCartRq.salesCartBo.salesCartItems) {
        GetArticleForSalesCartItemRq getArticleForSalesCartItemRq = GetArticleForSalesCartItemRq();
        getArticleForSalesCartItemRq.searchData = salesCartItems.articleNo;
        getArticleForSalesCartItemRq.storeId = appSession.userProfile.storeId;

        GetArticleForSalesCartItemRs getArticleForSalesCartItemRs = await _saleOrderService.getArticleForSalesCartItem(appSession, getArticleForSalesCartItemRq);
        SearchArticle searchArticle = getArticleForSalesCartItemRs.searchArticle;

        salesCartItems.articleNo = searchArticle.articleId;
        salesCartItems.isLotReq = searchArticle.isLotReq;
        salesCartItems.isPriceReq = searchArticle.isPriceRequired;
        salesCartItems.isQtyReq = searchArticle.isLotReq;
        salesCartItems.itemDescription = searchArticle.articleDescription;
        salesCartItems.itemUpc = searchArticle.itemUpc;
        salesCartItems.mchId = searchArticle.mchId;
        salesCartItems.netItemAmt = searchArticle.getUnitPrice() * salesCartItems.qty;
        salesCartItems.unit = searchArticle.sellUnit;
        salesCartItems.unitPrice = searchArticle.getUnitPrice();
      }

      SaveSalesCartRs saveSalesCartRs = await _saleOrderService.saveSalesCart(appSession, saveSalesCartRq);

      yield SaveSalesWithPhoneSuccessState(saveSalesCartRs.salesCartOid, event.phoneNo);
    } catch (error, stackTrace) {
      yield SaveSalesCartErrorState(AppException(error, stackTrace: stackTrace));
    }
  }

  Future<void> saveSalesCartCheckList(List<BasketItem> listItemBasket) async {
    List<BasketItem> lstBasketItemHaveCheckList = listItemBasket.where((element) => element.checkListData != null).toList();

    if (lstBasketItemHaveCheckList != null) {
      List<TransactionSalesCartRq.CheckListCart> lstSalesCartsCheckList = [];
      for (BasketItem item in lstBasketItemHaveCheckList) {
        if (lstSalesCartsCheckList != null && lstSalesCartsCheckList.any((element) => StringUtil.trimLeftZero(element.artcNo) == StringUtil.trimLeftZero(item.article.articleId))) continue;

        List<TransactionSalesCartRq.PatternCartList> lstPatternCart = [];
        if (StringUtil.isNotEmpty(item.checkListData.patternTypeSelected)) {
          CheckListQuestionRs.PatternList patternType = item.checkListData.checkListInfo.patternTypeList.firstWhere((element) => element.insPatternID == item.checkListData.patternTypeSelected, orElse: () => null);
          if (patternType != null) {
            if (patternType.artServiceList == null || patternType.artServiceList.isEmpty) {
              lstPatternCart.add(
                TransactionSalesCartRq.PatternCartList(
                  insPatternId: item.checkListData.patternTypeSelected,
                  insPatternFormat: 'T',
                  insPatternArtcId: null,
                ),
              );
            } else {
              for (CheckListQuestionRs.ArtServiceList artService in patternType.artServiceList) {
                lstPatternCart.add(
                  TransactionSalesCartRq.PatternCartList(
                    insPatternId: item.checkListData.patternTypeSelected,
                    insPatternFormat: 'T',
                    insPatternArtcId: artService.searchArticle.articleId,
                  ),
                );
              }
            }
          }
        }

        if (StringUtil.isNotEmpty(item.checkListData.patternAreaSelected)) {
          CheckListQuestionRs.PatternList patternArea = item.checkListData.checkListInfo.patternAreaList.firstWhere((element) => element.insPatternID == item.checkListData.patternAreaSelected, orElse: () => null);
          if (patternArea != null) {
            if (patternArea.artServiceList == null || patternArea.artServiceList.isEmpty) {
              lstPatternCart.add(
                TransactionSalesCartRq.PatternCartList(
                  insPatternId: item.checkListData.patternAreaSelected,
                  insPatternFormat: 'A',
                  insPatternArtcId: null,
                ),
              );
            } else {
              for (CheckListQuestionRs.ArtServiceList artService in patternArea.artServiceList) {
                lstPatternCart.add(
                  TransactionSalesCartRq.PatternCartList(
                    insPatternId: item.checkListData.patternAreaSelected,
                    insPatternFormat: 'A',
                    insPatternArtcId: artService.searchArticle.articleId,
                  ),
                );
              }
            }
          }
        }

        lstSalesCartsCheckList.add(
          TransactionSalesCartRq.CheckListCart(
            action: null,
            sgTrnItemOid: null,
            artcNo: item.article.articleId,
            insMappingId: item.checkListData.checkListInfo.insMapping,
            insResidenceId: item.checkListData.residenceSelected,
            patternList: lstPatternCart,
          ),
        );
      }

      TransactionSalesCartRq.TransactionSalesCartChecklistRq transactionSalesCartChecklistRq = TransactionSalesCartRq.TransactionSalesCartChecklistRq();
      transactionSalesCartChecklistRq.checkListCart = lstSalesCartsCheckList;

      TransactionSalesCartRs.TransactionSalesCartChecklistRs transactionSalesCartChecklistRs = await transactionService.transactionSalesCartChecklist(transactionSalesCartChecklistRq);

      for (BasketItem item in lstBasketItemHaveCheckList) {
        TransactionSalesCartRs.CheckListCart checkListCart = transactionSalesCartChecklistRs.checkListCart.firstWhere((element) => StringUtil.trimLeftZero(element.artcNo) == StringUtil.trimLeftZero(item.article.articleId), orElse: () => null);
        if (checkListCart != null) {
          item.checkListData.sgTrnItemOid = checkListCart.sgTrnItemOid;
        }
      }
    }
  }

  Stream<SaveSalesCartState> mapSalesCartUpdateCustomerEventToState(SalesCartUpdateCustomerEvent event) async* {
    try {
      yield SaveSalesCartLoadingState();

      AppSession appSession = applicationBloc.state.appSession;

      UpdateSalesCartCustomerRq rq = new UpdateSalesCartCustomerRq();
      rq.salesCartOid = event.salesCartOid;
      rq.customerOid = event.customer.customerOid;

      rq.lastUpdUser = appSession.userProfile.empNo;

      UpdateSalesCartCustomerRs rs = await _saleOrderService.updateSalesCartCustomer(appSession, rq);

      // GetSalesCartByOidRq getSalesCartByOidRq = GetSalesCartByOidRq();
      // getSalesCartByOidRq.salesCartOid = event.salesCartOid;
      // GetSalesCartByOidRs getSalesCartByOidRs = await _saleOrderService.getSalesCartByOid(appSession, getSalesCartByOidRq);
      //
      // SalesCartDto salesCartDto = SalesCartDto();
      // salesCartDto.salesCart = SalesCart()..salesCartOid = event.salesCartOid;

      yield SalesCartUpdateCustomerSuccessState(event.salesCartOid);
    } catch (error, stackTrace) {
      yield SaveSalesCartErrorState(AppException(error, stackTrace: stackTrace));
    }
  }
}
