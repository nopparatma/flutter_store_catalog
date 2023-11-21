import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/inquiry_transaction/inquiry_transaction_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/payment_option/payment_option_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/cancel_coll_so_sales_cart_payment_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/cancel_coll_so_sales_cart_payment_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_collect_sales_order_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_collect_sales_order_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_article_for_sales_cart_item_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sell_channel_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sell_channel_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/queue_sale.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/reserve_queue_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/reserve_queue_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sms_create_sales_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sms_create_sales_rs.dart';
import 'package:flutter_store_catalog/core/models/dotnet/inquiry_transaction_rq.dart';
import 'package:flutter_store_catalog/core/models/dotnet/inquiry_transaction_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/calculate_promotion_ca_rs.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/cashier_trn.dart';
import 'package:flutter_store_catalog/core/models/salesprmtn/sales_item.dart';
import 'package:flutter_store_catalog/core/models/view/hire_purchase_dto.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_dto.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:flutter_store_catalog/core/services/dotnet/qr_payment_service.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';
import 'package:flutter_store_catalog/core/utilities/math_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';

part 'create_sales_event.dart';

part 'create_sales_state.dart';

const int FREE_GOOD_SEQ_PREFIX = 1000;

class CreateSalesBloc extends Bloc<CreateSalesEvent, CreateSalesState> {
  final ApplicationBloc applicationBloc;
  final SalesCartBloc salesCartBloc;
  final InquiryTransactionBloc inquiryTransactionBloc;

  //final PaymentOptionBloc paymentOptionBloc;
  final SaleOrderService _saleOrderService = getIt<SaleOrderService>();
  final QRPaymentService _qrPaymentService = getIt<QRPaymentService>();

  CreateSalesBloc(this.applicationBloc, this.salesCartBloc, this.inquiryTransactionBloc); //, this.paymentOptionBloc);

  @override
  CreateSalesState get initialState => InitialCreateSalesState();

  @override
  Stream<CreateSalesState> mapEventToState(CreateSalesEvent event) async* {
    if (event is SmsCreateSalesEvent) {
      yield* mapSMSCreateSalesEventToState(event);
    } else if (event is QRCreateSalesEvent) {
      yield* mapQRCreateSalesEventToState(event);
    } else if (event is CreateCollectSalesEvent) {
      yield* mapCreateCollectSalesEventToState(event);
    } else if (event is ResetEvent) {
      yield InitialCreateSalesState();
    }
  }

  Stream<CreateSalesState> mapSMSCreateSalesEventToState(SmsCreateSalesEvent event) async* {
    try {
      yield LoadingCreateSalesState();

      AppSession appSession = applicationBloc.state.appSession;

      SalesCartDto salesCartDto;
      if (salesCartBloc.state.salesCartDto != null) {
        salesCartDto = salesCartBloc.state.salesCartDto;
      }
      Map<String, dynamic> salesCartClone = salesCartDto.salesCart.toJson();
      SalesCart salesCart = SalesCart.fromJson(salesCartClone);

      // Set PaymentType
      salesCart.paymentType = 'ONLINE';

      bindSimPayTender(event.calculatePromotionCARs, salesCartDto, salesCart);

      if (salesCartDto.lackFreeGoodsSalesCartItemMap.isNotNE) {
        await reserveQueueFreeGoods(appSession, salesCartDto);
        salesCart = salesCartDto.salesCart;
      }

      salesCartDto.salesCart = await createCollectSalesOrder(appSession, salesCart);

      SmsCreateSalesRs smsCreateSalesRs = await smsCreateSales(appSession, event.qrPaymentType, event.billToCustNo, event.phoneNo, event.email, salesCartDto.salesCart, event.calculatePromotionCARs);

      yield SuccessSmsCreateSalesState();
    } catch (error, stackTrace) {
      yield ErrorCreateSalesState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<CreateSalesState> mapQRCreateSalesEventToState(QRCreateSalesEvent event) async* {
    try {
      yield LoadingCreateSalesState();

      AppSession appSession = applicationBloc.state.appSession;

      SalesCartDto salesCartDto;
      if (salesCartBloc.state.salesCartDto != null) {
        salesCartDto = salesCartBloc.state.salesCartDto;
      }
      Map<String, dynamic> salesCartClone = salesCartDto.salesCart.toJson();
      SalesCart salesCart = SalesCart.fromJson(salesCartClone);

      // Set PaymentType
      salesCart.paymentType = 'ONLINE';

      bindSimPayTender(event.calculatePromotionCARs, salesCartDto, salesCart);

      if (salesCartDto.lackFreeGoodsSalesCartItemMap.isNotNE) {
        await reserveQueueFreeGoods(appSession, salesCartDto);
        salesCart = salesCartDto.salesCart;
      }

      salesCartDto.salesCart = await createCollectSalesOrder(appSession, salesCart);

      SmsCreateSalesRs smsCreateSalesRs = await smsCreateSales(appSession, event.qrPaymentType, event.billToCustNo, null, event.email, salesCartDto.salesCart, event.calculatePromotionCARs);

      yield SuccessQRCreateSalesState(smsCreateSalesRs.qrCodeImage);

      inquiryTransactionBloc.add(ResetInquiryTransactionEvent());

      InquiryTransactionRq inquiryTransactionRq = InquiryTransactionRq();
      inquiryTransactionRq.appChannel = QRPayment.APP_CHANNEL;
      inquiryTransactionRq.referenceId = smsCreateSalesRs.referenceId;
      inquiryTransactionRq.qrCodeId = smsCreateSalesRs.qrCodeId;
      inquiryTransactionRq.amount = event.calculatePromotionCARs.cashierTrns.firstWhere((e) => e.seqNo == 1)?.trnAmt ?? event.calculatePromotionCARs.netTrnAmt;
      inquiryTransactionRq.inquiryUserId = appSession.userProfile.empNo;

      InquiryTransactionRs inquiryTransactionRs = InquiryTransactionRs();

      bool isSuccess = false;

      while (true) {
        await new Future.delayed(const Duration(seconds: 1));

        if (inquiryTransactionBloc.state is CancelInquiryTransactionState) {
          yield TimeoutQRCreateSalesState();
          return;
        }

        try {
          inquiryTransactionRs = await _qrPaymentService.inquiryTransaction(inquiryTransactionRq);
          if (QRCodeStatus.BBL_APPROVE == inquiryTransactionRs?.qrCodeStatus) {
            isSuccess = true;
          }
        } catch (error) {
          isSuccess = false;
        }

        if (isSuccess) {
          yield SuccessQRPaymentState(
            posId: inquiryTransactionRs.posId,
            ticketNo: inquiryTransactionRs.ticketNo,
            totalPrice: inquiryTransactionRq.amount.toString(),
          );
          return;
        }

      }
    } catch (error, stackTrace) {
      yield ErrorCreateSalesState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<CreateSalesState> mapCreateCollectSalesEventToState(CreateCollectSalesEvent event) async* {
    try {
      yield LoadingCreateSalesState();

      AppSession appSession = applicationBloc.state.appSession;

      SalesCartDto salesCartDto;
      if (salesCartBloc.state.salesCartDto != null) {
        salesCartDto = salesCartBloc.state.salesCartDto;
      }
      Map<String, dynamic> salesCartClone = salesCartDto.salesCart.toJson();
      SalesCart salesCart = SalesCart.fromJson(salesCartClone);

      // Set PaymentType
      salesCart.paymentType = 'POS';

      bindSimPayTender(event.calculatePromotionCARs, salesCartDto, salesCart, isHirePurchase: event.isHirePurchase);
      salesCartDto.salesCart = await createCollectSalesOrder(appSession, salesCart);

      yield SuccessCreateCollectSalesState();
    } catch (error, stackTrace) {
      yield ErrorCreateSalesState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  String getTenderId(String cardNetWorkCode) {
    switch (cardNetWorkCode) {
      case CardNetwork.QRPP:
        return TenderIdOfCardNetwork.QRPP;
      case CardNetwork.VISA:
        return TenderIdOfCardNetwork.VISA;
      case CardNetwork.MC:
        return TenderIdOfCardNetwork.MC;
      case CardNetwork.UPAC:
        return TenderIdOfCardNetwork.UPAC;
      default:
        return '';
    }
  }

  void bindSimPayTender(CalculatePromotionCARs calculatePromotionCARs, SalesCartDto salesCartDto, SalesCart salesCart, {bool isHirePurchase = false}) {
    String hirePurchaseDiscountTypeId = applicationBloc.state.sysCfgMap[SystemConfig.HIRE_PURCHASE_DISCOUNT_CONDITION_TYPE];

    salesCart.simulatePaymentBo = SimulatePaymentBo()
      ..simPayTenderBos = <SimPayTenderBo>[]
      ..simPayDiscountBos = <SimPayDiscountBo>[]
      ..simPayPromoitonBos = <SimPayPromoitonBo>[]
      ..simPayPremiumBos = <SimPayPremiumBo>[]
      ..simPayHirepurchaseBo = <SimPayHirepurchaseBo>[];

    if (calculatePromotionCARs.salesItems != null) {
      int maxSalesOrderItemOid = 0;
      salesCart.salesOrders.forEach((element) {
        element.salesOrderItems.forEach((element) {
          if (element.salesOrderItemOid > maxSalesOrderItemOid) {
            maxSalesOrderItemOid = element.salesOrderItemOid;
          }
        });
      });

      for (final salesItemBo in calculatePromotionCARs.salesItems) {
        SalesOrderItem salesOrderItemBo;
        for (int i = 0; i < salesCart.salesOrders.length; i++) {
          for (int j = 0; j < salesCart.salesOrders[i].salesOrderItems.length; j++) {
            if (salesCart.salesOrders[i].salesOrderItems[j].salesOrderItemOid == salesItemBo.refSeqNo) {
              salesOrderItemBo = salesCart.salesOrders[i].salesOrderItems[j];
            }
          }
        }

        if (salesItemBo.itemDiscounts != null) {
          for (final salesItemDiscount in salesItemBo.itemDiscounts) {
            if (salesItemDiscount.remark != null) {
              if (salesOrderItemBo != null) {
                SimPayPromoitonBo simPayPromotion = SimPayPromoitonBo();
                simPayPromotion.promotionId = salesItemDiscount.remark;
                simPayPromotion.discountAmount = salesItemDiscount.discountAmt;
                simPayPromotion.salesOrderItemOid = salesOrderItemBo.salesOrderItemOid;
                simPayPromotion.unit = salesOrderItemBo.unit;
                simPayPromotion.qty = salesOrderItemBo.quantity;

                DiscountConditionType discountConditionType = DiscountConditionType();
                discountConditionType.isPercentDiscount = false;
                discountConditionType.discountConditionTypeId = salesItemDiscount.discountTypeId;
                discountConditionType.description = salesItemDiscount.discountTypeDesc;
                simPayPromotion.articleNo = salesOrderItemBo.articleNo;

                simPayPromotion.discountConditionType = discountConditionType;

                salesCart.simulatePaymentBo.simPayPromoitonBos.add(simPayPromotion);
              } else {
                if (salesItemBo.isFreeGoods) {
                  SimPayPremiumBo simPayPremiumBo = SimPayPremiumBo();
                  simPayPremiumBo.articleId = salesItemBo.articleId;
                  simPayPremiumBo.articleName = salesItemBo.articleDesc;
                  simPayPremiumBo.unit = salesItemBo.unit;
                  simPayPremiumBo.premiumQty = salesItemBo.qty;
                  simPayPremiumBo.promotionId = salesItemDiscount.remark;

                  salesCart.simulatePaymentBo.simPayPremiumBos.add(simPayPremiumBo);
                } else {
                  SimPayPromoitonBo simPayPromotion = SimPayPromoitonBo();
                  simPayPromotion.promotionId = salesItemDiscount.remark;
                  simPayPromotion.discountAmount = salesItemDiscount.discountAmt;
                  num salesOrderItemOid = 0;
                  simPayPromotion.salesOrderItemOid = salesOrderItemOid;
                  DiscountConditionType discountConditionType = DiscountConditionType();
                  discountConditionType.isPercentDiscount = false;
                  discountConditionType.discountConditionTypeId = salesItemDiscount.discountTypeId;
                  discountConditionType.description = salesItemDiscount.discountTypeDesc;

                  simPayPromotion.discountConditionType = discountConditionType;

                  salesCart.simulatePaymentBo.simPayPromoitonBos.add(simPayPromotion);
                }
              }
            }

            if (salesItemDiscount.remark == null) {
              SimPayPromoitonBo simPayPromotion = SimPayPromoitonBo();
              simPayPromotion.articleNo = salesItemBo.articleId;
              simPayPromotion.promotionId = salesItemDiscount.remark;
              simPayPromotion.discountConditionType = DiscountConditionType();
              simPayPromotion.discountConditionType.discountConditionTypeId = salesItemDiscount.discountTypeId;
              simPayPromotion.discountAmount = salesItemDiscount.discountAmt;

              if (salesOrderItemBo != null && salesOrderItemBo.salesOrderItemOid != null && salesOrderItemBo.salesOrderItemOid > 0) {
                simPayPromotion.salesOrderItemOid = salesOrderItemBo.salesOrderItemOid;
              }

              DiscountConditionType discountConditionType = DiscountConditionType();
              discountConditionType.discountConditionTypeId = salesItemDiscount.discountTypeId;
              discountConditionType.description = salesItemDiscount.discountTypeDesc;

              salesCart.simulatePaymentBo.simPayPromoitonBos.add(simPayPromotion);
            }
          }
        }
      }
    }

    if (isHirePurchase && salesCartDto.selectPromotionMap.isNotNE) {
      List<HirePurchasePromotion> promotionList = salesCartDto.selectPromotionMap.values.toSet().toList();

      promotionList.forEach((promotion) {
        List<String> artcList = salesCartDto.selectPromotionMap.keys.where((key) => salesCartDto.selectPromotionMap[key] == promotion).toList();
        List<SalesItem> salesItem = salesCartDto.populateSalesItemForPay.where((item) => artcList.contains(item.articleId)).toList();
        num unpaidAmt = salesItem.fold(0, (previousValue, element) => MathUtil.add(previousValue, element.netItemAmt));

        salesItem.forEach((item) {
          if (promotion.promotion.percentDiscount.isNotNull && promotion.promotion.percentDiscount != 0) {
            SimPayPromoitonBo simPayPromotion = SimPayPromoitonBo();
            simPayPromotion.articleNo = item.articleId;
            simPayPromotion.qty = item.qty;
            simPayPromotion.unit = item.unit;
            simPayPromotion.promotionId = promotion.promotion.promotionId;
            simPayPromotion.discountConditionType = new DiscountConditionType();
            simPayPromotion.discountConditionType.discountConditionTypeId = hirePurchaseDiscountTypeId;
            simPayPromotion.discountAmount = MathUtil.multiple(num.parse(MathUtil.multiple(item.netItemAmt, MathUtil.divide(promotion.promotion.percentDiscount, 100)).toStringAsFixed(2)), -1);

            num salesOrderItemOid = salesCartDto.salesCart.salesOrders
                .firstWhere((so) => so.salesOrderItems.any(
                      (soItem) => soItem.salesOrderItemOid == item.refSeqNo,
                    ))
                ?.salesOrderItems
                ?.firstWhere(
                  (soItem) => soItem.salesOrderItemOid == item.refSeqNo,
                )
                ?.salesOrderItemOid;

            simPayPromotion.salesOrderItemOid = salesOrderItemOid;

            salesCart.simulatePaymentBo.simPayPromoitonBos.add(simPayPromotion);

            unpaidAmt = MathUtil.add(unpaidAmt, simPayPromotion.discountAmount);
          }

          salesCart.simulatePaymentBo.simPayHirepurchaseBo.add(SimPayHirepurchaseBo()
            ..creditCardType = promotion.group.creditCardType
            ..tenderNo = promotion.group.tenderNo
            ..optionId = promotion.promotion.optionId
            ..month = promotion.promotion.month
            ..percentDiscount = promotion.promotion.percentDiscount
            ..createDateTime = DateTime.now()
            ..createUser = applicationBloc.state.appSession.userProfile.empNo
            ..mailId = promotion.mailId
            ..tenderId = promotion.group.tenderId
            ..groupId = promotion.group.groupId
            ..articleDesc = item.articleDesc
            ..promotionHierarchyLevel = promotion.group.itemIncludeList.first.hierarchyLevel);
        });

        SimPayTenderBo tender = SimPayTenderBo();
        tender.tenderId = promotion.group.tenderId;
        tender.salesCartOid = salesCart.salesCartOid;
        tender.cardDummy = promotion.promotion.promotionId;
        tender.isPromotion = false;
        tender.isHirepurchase = true;
        tender.tenderName = promotion.group.tenderName;
        tender.tenderValue = unpaidAmt;
        salesCart.simulatePaymentBo.simPayTenderBos.add(tender);
      });

      List<String> artcHaveProList = salesCartDto.selectPromotionMap.keys.toList();
      List<SalesItem> populateSalesItemNotHavePro = salesCartDto.populateSalesItem.where((item) => !artcHaveProList.contains(item.articleId)).toList();

      if (populateSalesItemNotHavePro.isNotNE) {
        num unpaidAmt = populateSalesItemNotHavePro.fold(0, (previousValue, element) => MathUtil.add(previousValue, element.netItemAmt));
        SimPayTenderBo tender = SimPayTenderBo();
        tender.tenderId = TenderIdCash.CASH;
        tender.salesCartOid = salesCart.salesCartOid;
        tender.isPromotion = false;
        tender.tenderValue = unpaidAmt;

        salesCart.simulatePaymentBo.simPayTenderBos.add(tender);
      }
    }

    if (calculatePromotionCARs.cashierTrns.isNotNE) {
      for (CashierTrn cashierTransactionBo in calculatePromotionCARs.cashierTrns) {
        SimPayTenderBo tender = SimPayTenderBo();
        tender.salesCartOid = salesCart.salesCartOid;
        tender.tenderNo = cashierTransactionBo.tenderNo;
        tender.tenderId = cashierTransactionBo.tenderId;
        tender.tenderValue = cashierTransactionBo.trnAmt;
        tender.isPromotion = cashierTransactionBo.promotionId.isNotNE;
        tender.promotionId = cashierTransactionBo.promotionId;

        salesCart.simulatePaymentBo.simPayTenderBos.add(tender);
      }
    }

    if (salesCartDto.selectedTender.isNull && salesCartDto.selectPromotionMap.isNullOrEmpty) {
      SimPayTenderBo tender = SimPayTenderBo();
      tender.tenderId = TenderIdCash.CASH;
      tender.salesCartOid = salesCart.salesCartOid;
      tender.isPromotion = false;
      tender.tenderValue = salesCartDto.unpaid;

      salesCart.simulatePaymentBo.simPayTenderBos.add(tender);
    }
  }

  Future<SalesCart> createCollectSalesOrder(AppSession appSession, SalesCart salesCart) async {
    if (salesCart.collectSalesOrder?.collectSalesOrderOid?.isNotNE ?? false) {
      CancelCollSOSalesCartPaymentRq cancelCollSOSalesCartPaymentRq = CancelCollSOSalesCartPaymentRq();
      cancelCollSOSalesCartPaymentRq.collectSalesOrderOid = salesCart.collectSalesOrder?.collectSalesOrderOid;
      cancelCollSOSalesCartPaymentRq.lastUpdateUser = appSession.userProfile.empId;
      cancelCollSOSalesCartPaymentRq.salesCartOid = salesCart?.salesCartOid;

      CancelCollSOSalesCartPaymentRs cancelCollSOSalesCartPaymentRs = await _saleOrderService.cancelCollSOSalesCartPayment(appSession, cancelCollSOSalesCartPaymentRq);
    }

    CreateCollectSalesOrderRq createCollectSalesOrderRq = CreateCollectSalesOrderRq();
    salesCart.totalTranAmt = salesCart.getTotalPrice();
    salesCart.totalDscntAmt = salesCart.getTotalDiscount();
    salesCart.netTranAmt = salesCart.getNetTranAmount();

    //เคส ไมมี salesChannel มา
    if (salesCart.salesOrders.any((element) => element.sapOrderCode.isNullEmptyOrWhitespace || element.distributionChannel.isNullEmptyOrWhitespace || element.salesChannel.isNullEmptyOrWhitespace)) {
      GetSellChannelRq getSellChannelRq = GetSellChannelRq();
      getSellChannelRq.storeId = appSession?.userProfile?.storeId;
      getSellChannelRq.salesChannel = SellChannel.SALES_CHANNEL;

      GetSellChannelRs getSellChannelRs = await _saleOrderService.getSellChannel(appSession, getSellChannelRq);

      if (getSellChannelRs.sellChannelLists.isNullOrEmpty) {
        throw AppException('error.not_found_sell_channel'.tr());
      }

      salesCart.salesOrders?.forEach((element) {
        element.sapOrderCode = getSellChannelRs.sellChannelLists.first.sapOrderCode;
        element.distributionChannel = getSellChannelRs.sellChannelLists.first.distributionChannel;
        element.salesChannel = getSellChannelRs.sellChannelLists.first.salesChannel;
      });
    }

    createCollectSalesOrderRq.salesCart = salesCart;

    createCollectSalesOrderRq.createUserId = appSession.userProfile.empId;
    createCollectSalesOrderRq.createUserName = appSession.userProfile.empName;

    CreateCollectSalesOrderRs createCollectSalesOrderRs = await _saleOrderService.createCollectSalesOrder(appSession, createCollectSalesOrderRq);

    GetSalesCartByOidRq getSalesCartByOidRq = GetSalesCartByOidRq();
    getSalesCartByOidRq.salesCartOid = salesCart.salesCartOid;

    GetSalesCartByOidRs getSalesCartByOidRs = await _saleOrderService.getSalesCartByOid(appSession, getSalesCartByOidRq);

    return getSalesCartByOidRs.salesCart;
  }

  Future<SmsCreateSalesRs> smsCreateSales(AppSession appSession, String qrPaymentType, String billToCustNo, String phoneNo, String email, SalesCart salesCart, CalculatePromotionCARs calculatePromotionCARs) async {
    SmsCreateSalesRq smsCreateSalesRq = SmsCreateSalesRq();
    smsCreateSalesRq.paymentMethod = qrPaymentType;
    smsCreateSalesRq.billToCustNo = billToCustNo;
    smsCreateSalesRq.collectSalesOrderNo = salesCart?.collectSalesOrder?.collSalesOrderNo;
    smsCreateSalesRq.phoneNo = phoneNo;
    smsCreateSalesRq.email = email;

    smsCreateSalesRq.createUserId = appSession.userProfile.empId;
    smsCreateSalesRq.createUserName = appSession.userProfile.empName;
    smsCreateSalesRq.rewardCardNo = salesCart?.customer?.cardNumber;

    smsCreateSalesRq.salesChannel = salesCart?.salesOrders?.first?.salesChannel;
    smsCreateSalesRq.sapOrderCode = salesCart?.salesOrders?.first?.sapOrderCode;

    smsCreateSalesRq.lstCashTrn = <CashTrn>[];
    calculatePromotionCARs.cashierTrns?.take(calculatePromotionCARs.cashierTrns.length - 1)?.forEach((element) {
      CashTrn cashTrn = CashTrn()
        ..tenderId = element.tenderId
        ..trnAmt = element.trnAmt
        ..refInfo = element.refInfo
        ..promotionId = element.promotionId;
      smsCreateSalesRq.lstCashTrn.add(cashTrn);
    });

    CashierTrn cashierTrnPay = calculatePromotionCARs.cashierTrns.last;
    CashTrn cashTrn = CashTrn()
      ..tenderId = cashierTrnPay.tenderId
      ..trnAmt = cashierTrnPay.trnAmt
      ..refInfo = '000000xxxxxx0000'
      ..promotionId = cashierTrnPay.promotionId;
    smsCreateSalesRq.lstCashTrn.add(cashTrn);

    if (calculatePromotionCARs.promotionRedemption != null) {
      List<PromotionSale> lstPromotionSales = <PromotionSale>[];
      if (calculatePromotionCARs.promotionRedemption.promotionSales != null && calculatePromotionCARs.promotionRedemption.promotionSales.isNotEmpty) {
        calculatePromotionCARs.promotionRedemption.promotionSales.forEach((element) {
          PromotionSale promotionSale = PromotionSale();
          promotionSale.prmtnId = element.promotionId;
          promotionSale.netAmt = element.netAmt;
          promotionSale.prmtnNm = element.promotionName;
          promotionSale.netTrnAmt = element.netTrnAmt;
          promotionSale.salesType = 'C';

          promotionSale.lstPromotionSalesItem = <PromotionSalesItem>[];
          if (element.promotionSalesItems != null && element.promotionSalesItems.isNotEmpty) {
            element.promotionSalesItems.forEach((element) {
              PromotionSalesItem promotionSalesItem = PromotionSalesItem();
              promotionSalesItem.articleDescription = element.articleDesc;
              promotionSalesItem.articleId = element.articleId;
              promotionSalesItem.eligibleQuantity = element.eligibleQty;
              promotionSalesItem.mainUPC = element.mainUPC;
              promotionSalesItem.mch3 = element.mch3;
              promotionSalesItem.netAmount = StringUtil.toCurrencyFormat(element.netAmt);
              promotionSalesItem.unit = element.unit;
              promotionSale.lstPromotionSalesItem.add(promotionSalesItem);
            });
          }

          lstPromotionSales.add(promotionSale);
        });
      }

      List<PromotionDscntRedemption> lstPromotionDscntRedemptions = <PromotionDscntRedemption>[];
      if (calculatePromotionCARs.promotionRedemption.promotionDiscountRedemptions != null && calculatePromotionCARs.promotionRedemption.promotionDiscountRedemptions.isNotEmpty) {
        calculatePromotionCARs.promotionRedemption.promotionDiscountRedemptions.forEach((element) {
          PromotionDscntRedemption promotionDscntRedemption = PromotionDscntRedemption();
          promotionDscntRedemption.prmtnId = element.promotionId;
          promotionDscntRedemption.dscntCondtyp = element.discountType;
          promotionDscntRedemption.dscntAmt = element.discountAmt;
          promotionDscntRedemption.vendorId = element.vendorId;
          promotionDscntRedemption.vendorNm = element.vendorName;
          promotionDscntRedemption.couponQty = element.couponQty ?? 0;
          lstPromotionDscntRedemptions.add(promotionDscntRedemption);
        });
      }

      if (lstPromotionSales.isNotEmpty || lstPromotionDscntRedemptions.isNotEmpty) {
        PromotionRdptn promotionRdptn = PromotionRdptn();
        promotionRdptn.prmtnTyp = 'D';
        promotionRdptn.status = 'P';
        promotionRdptn.lstPromotionSale = <PromotionSale>[]..addAll(lstPromotionSales);
        promotionRdptn.lstPromotionDscntRedemption = <PromotionDscntRedemption>[]..addAll(lstPromotionDscntRedemptions);
        smsCreateSalesRq.promotionRdptn = promotionRdptn;
      }
    }

    smsCreateSalesRq.posId = applicationBloc.state.sysCfgMap[SystemConfig.TABLET_POS_NO];
    smsCreateSalesRq.storeId = appSession.userProfile.storeId;
    smsCreateSalesRq.tranDate = appSession.transactionDateTime;

    List<SalesOrderItem> allSalesOrderItem = salesCart.salesOrders.fold([], (previousValue, element) => previousValue..addAll(element.salesOrderItems));

    int seq = 1;
    for (SalesItem salesItemBo in calculatePromotionCARs.salesItems) {
      SalesOrderItem salesOrderItemBo;
      for (SalesOrderItem salesOrderItem in allSalesOrderItem) {
        if (salesOrderItem.salesOrderItemOid == salesItemBo.refSeqNo) {
          salesOrderItemBo = salesOrderItem;
        }
      }

      if (salesOrderItemBo == null) continue;

      smsCreateSalesRq.lstSalesTrnItem ??= <SalesTrnItem>[];
      smsCreateSalesRq.lstSalesTrnItem.add(
        SalesTrnItem(
            seqNo: seq++,
            salesOrderItemOid: salesOrderItemBo?.salesOrderItemOid,
            isFreeGood: salesItemBo.isFreeGoods,
            price: salesItemBo.price,
            normalPrice: salesItemBo.normalPrice,
            promotionPrice: salesItemBo.promotionPrice,
            netItemAmount: salesItemBo.netItemAmt,
            memberDiscountAmount: salesItemBo.memberDiscountAmt,
            specialDiscountAmount: salesItemBo.specialDiscountAmt,
            vatItemAmt: salesItemBo.vatItemAmt,
            qty: salesItemBo.qty,
            itemDiscounts: salesItemBo.itemDiscounts
                ?.map<ItemDiscount>((e) => ItemDiscount(
                      dscntAmt: e.discountAmt,
                      dscntPerUnit: e.discountAmtPerUnit,
                      dscntVal: e.discountValue,
                      dscntCondTypId: e.discountTypeId,
                      remark: e.remark,
                    ))
                ?.toList()),
      );
    }
    smsCreateSalesRq.totVatTrnAmt = calculatePromotionCARs.totalVatAmt;
    smsCreateSalesRq.vatTrnAmt = calculatePromotionCARs.vatTrnAmt;
    smsCreateSalesRq.netTrnAmount = calculatePromotionCARs.netTrnAmt;
    smsCreateSalesRq.totalTrnAmt = calculatePromotionCARs.totalTrnAmt;
    smsCreateSalesRq.totalDiscountAmt = calculatePromotionCARs.totalDiscountAmt;

    return await _saleOrderService.smsCreateSales(appSession, smsCreateSalesRq);
  }

  Future<void> reserveQueueFreeGoods(AppSession appSession, SalesCartDto salesCartDto) async {
    ReserveQueueRq reserveQueueRq = ReserveQueueRq();
    reserveQueueRq.channelCode = SystemName.SCAT;

    List<String> listDc = ShippingPointConstants.DS_CODE_LIST.split(',');

    Map<num, List<SalesCartItem>> freeGoodsMap = salesCartDto.lackFreeGoodsSalesCartItemMap;

    for (num soItemOid in freeGoodsMap.keys) {
      SalesOrder soData = salesCartDto.salesCart.salesOrders.firstWhere((so) => so.salesOrderItems.any((soItem) => soItem.salesOrderItemOid.compareTo(freeGoodsMap.keys.first) == 0));
      SalesOrderGroup soGroupData = soData.salesOrderGroups.firstWhere((soGroup) => soGroup.salesOrderItems.any((soItem) => soItem.salesOrderItemOid.compareTo(freeGoodsMap.keys.first) == 0));

      SalesOrderItem mainSalesOrderItem = soGroupData.salesOrderItems.firstWhere((item) => item.salesOrderItemOid == soItemOid);

      if (soData.soldToCustomer != null) {
        reserveQueueRq.soldToSapId = soData.soldToCustomer.sapId;
      }
      String soMode = '';
      if (soGroupData != null) {
        String shippingPointId = soGroupData.shippingPointId;
        reserveQueueRq.shippointManage = shippingPointId;

        if (Shippoint.CUSTOMER == shippingPointId) {
          soMode = SOMode.CUST_RECEIVE;
        } else if (listDc.contains(shippingPointId)) {
          soMode = SOMode.DELIVERY;
        } else {
          soMode = SOMode.STORE_DELIVERY;
        }
        reserveQueueRq.soMode = soMode;
      }

      if (soGroupData != null && soGroupData.shipToCustomer != null) {
        Customer custShipTo = soGroupData.shipToCustomer;

        reserveQueueRq.shipToSapId = custShipTo.sapId;
        reserveQueueRq.districtName = custShipTo.district;
        reserveQueueRq.subDistrictName = custShipTo.subDistrict;
        reserveQueueRq.provinceName = custShipTo.province;
        reserveQueueRq.postcode = custShipTo.zipCode;
      } else {
        reserveQueueRq.districtName = soData.district;
        reserveQueueRq.subDistrictName = soData.subDistrict;
        reserveQueueRq.provinceName = soData.province;
        reserveQueueRq.postcode = soData.zipCode;
      }

      if (soMode == SOMode.CUST_RECEIVE && soData.soldToCustomer != null) {
        reserveQueueRq.districtName = soData.soldToCustomer.district;
        reserveQueueRq.subDistrictName = soData.soldToCustomer.subDistrict;
        reserveQueueRq.provinceName = soData.soldToCustomer.province;
        reserveQueueRq.postcode = soData.soldToCustomer.zipCode;
      }

      reserveQueueRq.storeId = soData.storeId;
      reserveQueueRq.updateBy = appSession.userProfile.empId;
      reserveQueueRq.updateByEmpName = appSession.userProfile.empName;
      if (soMode == SOMode.DELIVERY) {
        reserveQueueRq.reserveManual = 'N';
      } else {
        reserveQueueRq.reserveManual = 'Y';
      }

      List<QueueSale> queueSales = List();
      QueueSale queueSale = new QueueSale();
      queueSale.deliveryDate = soGroupData.deliveryDate;
      queueSale.timeType = soGroupData.timeType;
      queueSale.timeNo = soGroupData.timeNo;
      queueSale.remark = soGroupData.remark;
      queueSale.confirmTypeId = soGroupData.confirmTypeId;
      queueSale.deliveryQueueNo = soGroupData.deliveryQueueNo;

      queueSale.queueSalesItems = List();

      int lastLineItem = 0;
      String deliverySite = "";
      String shippngPointId = "";
      for (final soItem in soGroupData.salesOrderItems) {
        lastLineItem = soItem.seqNo;

        QueueSalesItem queueSalesItem = QueueSalesItem();
        queueSalesItem.lineItem = soItem.seqNo.toString();
        queueSalesItem.articleNo = soItem.articleNo;
        queueSalesItem.quantity = soItem.quantity;
        queueSalesItem.unit = soItem.unit;
        queueSalesItem.unitPrice = soItem.unitPrice;
        queueSalesItem.netItemAmount = soItem.netItemAmount;
        queueSalesItem.isMainInstall = soItem.isMainInstall ?? false;
        queueSalesItem.isMainProduct = soItem.isMainProduct;
        queueSalesItem.isPremium = soItem.isPremium ?? false;
        queueSalesItem.shippingPointId = soItem.shippingPointId;
        queueSalesItem.deliverySite = soItem.deliverySite;

        deliverySite = soItem.deliverySite;
        shippngPointId = soItem.shippingPointId;

        if (soItem.salesOrderSetItemBos != null && soItem.salesOrderSetItemBos.isNotEmpty) {
          queueSalesItem.isSalesSet = true;
          queueSalesItem.articleSets = List();
          for (final soSetItem in soItem.salesOrderSetItemBos) {
            ArticleSet articleSet = ArticleSet();
            articleSet.articleNo = soSetItem.articleId;
            articleSet.itemDescription = soSetItem.description;
            articleSet.qty = soSetItem.quantity;
            articleSet.unit = soSetItem.unit;
            queueSalesItem.articleSets.add(articleSet);
          }
        } else {
          queueSalesItem.isSalesSet = false;
        }

        queueSale.queueSalesItems.add(queueSalesItem);
      }

      List<SalesCartItem> salesCartItemList = freeGoodsMap[soItemOid];
      salesCartItemList.forEach((scItem) {
        QueueSalesItem queueSalesItem = QueueSalesItem();
        queueSalesItem.lineItem = (lastLineItem + 100).toString();
        queueSalesItem.articleNo = scItem.articleNo;
        queueSalesItem.quantity = scItem.qty;
        queueSalesItem.unit = scItem.unit;
        queueSalesItem.unitPrice = scItem.unitPrice;
        queueSalesItem.netItemAmount = scItem.netItemAmt == null ? MathUtil.multiple(scItem.unitPrice ?? 0, scItem.qty) : scItem.netItemAmt;
        queueSalesItem.isMainInstall = scItem.isMainInstall ?? false;
        queueSalesItem.installPLineItem = scItem.isMainInstall != null && scItem.isMainInstall ? mainSalesOrderItem.seqNo?.toString() : null;
        queueSalesItem.isMainProduct = scItem.isMainPrd ?? false;
        queueSalesItem.isPremium = true;
        queueSalesItem.premiumPLineItem = mainSalesOrderItem.seqNo?.toString();
        queueSalesItem.shippingPointId = shippngPointId;
        queueSalesItem.deliverySite = deliverySite;

        if (scItem.isSalesSet != null && scItem.isSalesSet) {
          queueSalesItem.isSalesSet = true;
          queueSalesItem.articleSets = scItem.articleSets;
        } else {
          queueSalesItem.isSalesSet = false;
        }

        queueSale.queueSalesItems.add(queueSalesItem);
      });

      queueSales.add(queueSale);

      reserveQueueRq.queueSales = queueSales;

      ReserveQueueRs reserveQueueRs = await _saleOrderService.reserveQueueForFreeGoods(appSession, reserveQueueRq);

      salesCartItemList.forEach((item) {
        item.salesOrderOid = soData.salesOrderOid;
        item.salesOrderGroupOid = soGroupData.salesOrderGroupId;
        item.salesOrderItemOid = mainSalesOrderItem.salesOrderItemOid;
        item.refSalesCartItemOid = mainSalesOrderItem.salesCartItemOid;
      });

      salesCartDto.salesCart.salesCartItems.addAll(salesCartItemList);
    }
  }
}
