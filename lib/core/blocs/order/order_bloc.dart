import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/basket/basket_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_delivery_fee_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_shipping_point_store_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/view/basket_item.dart';
import 'package:flutter_store_catalog/core/models/view/queue_data.dart';
import 'package:flutter_store_catalog/core/models/view/queue_data_item_dto.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_dto.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_item_dto.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_reserve.dart';
import 'package:flutter_store_catalog/core/utilities/math_util.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApplicationBloc applicationBloc;
  final SalesCartBloc salesCartBloc;
  final BasketBloc basketBloc;

  OrderBloc(this.applicationBloc, this.salesCartBloc, this.basketBloc);

  @override
  OrderState get initialState => InitialOrderState();

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is ShowCustomerInfoToEvent) {
      yield* mapShowCustomerInfoToEventToState(event);
    } else if (event is BackStepToCustomerPanel) {
      yield* mapBackStepToCustomerReceiveState(event);
    } else if (event is BackStepToInquiryPanel) {
      yield* mapBackStepToInquiryState(event);
    } else if (event is SelectShipToEvent) {
      yield* mapSelectShipToEventToState(event);
    } else if (event is InquiryQueueToEvent) {
      yield* mapInquiryQueueEventToState(event);
    } else if (event is ChangeQueueDateToEvent) {
      yield* mapChangeQueueDateEventToState(event);
    } else if (event is OrderReserveQueueEvent) {
      yield* mapOrderReserveQueueEventToState(event);
    } else if (event is AlreadyReservedQueueEvent) {
      yield* mapAlreadyReservedQueueEventToState(event);
    } else if (event is CalPromotionEvent) {
      yield* mapCalculatePromotionEventToState(event);
    }
  }

  Stream<OrderState> mapShowCustomerInfoToEventToState(ShowCustomerInfoToEvent event) async* {
    try {
      yield ShowCustomerInfoState();
    } catch (error, stackTrace) {
      yield ErrorOrderState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<OrderState> mapBackStepToCustomerReceiveState(BackStepToCustomerPanel event) async* {
    try {
      salesCartBloc.state.salesCartDto.shipToCustomer = null;
      yield ShowCustomerInfoState(backStepFlag: event.backStepFlag, customerReceiveValue: event.customerReceiveValue);
    } catch (error, stackTrace) {
      yield ErrorOrderState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<OrderState> mapBackStepToInquiryState(BackStepToInquiryPanel event) async* {
    try {
      yield InquiryQueueCompleteState(backStepFlag: event.backStepFlag, editDateItem: event.editDateItem);
    } catch (error, stackTrace) {
      yield ErrorOrderState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<OrderState> mapSelectShipToEventToState(SelectShipToEvent event) async* {
    try {
      List<SalesCartItemDto> salesCartItemDtos = <SalesCartItemDto>[];
      SalesCartDto salesCartDto = salesCartBloc.state.salesCartDto;

      List<SalesCartItem> salesCartItems = salesCartDto.salesCart.salesCartItems;

      salesCartItems.forEach((element) {
        SalesCartItemDto salesCartItemDto = new SalesCartItemDto();
        salesCartItemDto.salesCartItem = SalesCartItem.fromJson(element.toJson());
        salesCartItemDto.isSelected = true;
        // salesCartItemDto.qtyReserve = element.qtyRemain;
        salesCartItemDtos.add(salesCartItemDto);
      });

      String soMode = event.isCustomerReceive ? SOMode.CUST_RECEIVE : SOMode.DELIVERY;
      for (int i = 0; i < salesCartItemDtos.length; i++) {
        SalesCartItemDto salesCartItemDto = salesCartItemDtos[i];
        num lineItem = (i + 1) * 100;
        salesCartItemDto.salesCartItem.lineItem = lineItem.toString();
        if (event.isCustomerReceive && !salesCartItemDto.salesCartItem.isPremiumService) {
          salesCartItemDto.salesCartItem.shippingPointId = Shippoint.CUSTOMER;
          salesCartItemDto.salesCartItem.deliverySite = applicationBloc.state.appSession.userProfile.storeId;
        } else {
          salesCartItemDto.salesCartItem.shippingPointId = null;
          salesCartItemDto.salesCartItem.deliverySite = null;
        }
      }

      SalesCartReserve salesCartReserve = salesCartBloc.state.salesCartReserve;
      salesCartReserve.soMode = soMode;
      salesCartReserve.isReserveSingleTime = false;
      if (SOMode.CUST_RECEIVE == soMode && salesCartDto.salesCart.customer != null) {
        salesCartReserve.soldto = salesCartDto.salesCart.customer;
        salesCartReserve.shipto = salesCartDto.salesCart.customer;
      } else {
        salesCartReserve.soldto = salesCartDto.salesCart.customer;
        salesCartReserve.shipto = event.shipToCustomer;
      }

      salesCartDto.shipToCustomer = salesCartReserve.shipto;

      salesCartReserve.salesCartItemList = salesCartItemDtos;

      yield ShipToSelectedState(shipToCustomer: event.shipToCustomer, isCustomerReceive: event.isCustomerReceive, shippingPointStore: event.shippingPointStore);
    } catch (error, stackTrace) {
      yield ErrorOrderState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<OrderState> mapOrderReserveQueueEventToState(OrderReserveQueueEvent event) async* {
    try {
      yield QueueReservedState();
    } catch (error, stackTrace) {
      yield ErrorOrderState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  //For Mockup from SS
  Stream<OrderState> mapAlreadyReservedQueueEventToState(AlreadyReservedQueueEvent event) async* {
    try {
      String articleDeliveryFee = applicationBloc.state.sysCfgMap[SystemConfig.ART_DELIVERY_FEE];
      List<String> articleDeliveryFeeList = articleDeliveryFee.split(',');

      SalesCartDto salesCartDto = salesCartBloc.state.salesCartDto;
      SalesCartReserve salesCartReserve = salesCartBloc.state.salesCartReserve;

      salesCartDto.displayQueueItemList = <QueueDataItemDto>[];
      salesCartReserve.articleDeliveryFees = <ArticleDeliveryFee>[];

      salesCartDto.salesCart.salesOrders.forEach((so) {
        so.salesOrderGroups.forEach((soGrp) {
          soGrp.salesOrderItems.forEach((soItem) {
            if (articleDeliveryFeeList.contains(soItem.articleNo)) {
              ArticleDeliveryFee deliveryFeeItem = ArticleDeliveryFee();
              deliveryFeeItem.artNo = soItem.articleNo;
              deliveryFeeItem.totalPrice = soItem.unitPrice;
              deliveryFeeItem.itemUpc = soItem.itemUPC;
              deliveryFeeItem.artDesc = soItem.description;
              deliveryFeeItem.unit = soItem.unit;
              salesCartReserve.articleDeliveryFees.add(deliveryFeeItem);
            } else {
              QueueDataItemDto item = QueueDataItemDto(
                selectedDate: soGrp.deliveryDate,
                selectedTimeNo: soGrp.timeNo,
                selectedTimeType: soGrp.timeType,
                queueDateMap: Map<DateTime, QueueDateMap>(),
                jobNo: soGrp.jobNo,
                jobType: soGrp.jobType?.jobTypeId,
                shippointManage: soGrp.shippingPointId,
                salesCartItem: mapToSalesCartItem(salesCartDto.salesCart.salesOrders, soItem),
                contactName: soGrp.contactName,
                contactTel: soGrp.contactTel,
                spacialOrderText: soGrp.remark,
                basketItem: getBasketItem(soItem.articleNo, soItem.itemUPC, soItem.quantity),
              );
              salesCartDto.displayQueueItemList.add(item);
            }
          });
        });
      });

      salesCartDto.totalPrice = salesCartDto.salesCart.salesCartItems.fold(0, (previousValue, element) {
        return MathUtil.add(previousValue, articleDeliveryFeeList.contains(element.articleNo) ? 0 : MathUtil.multiple(element.unitPrice ?? 0, element.qty));
      });
      salesCartDto.totalDeliveryFee = salesCartReserve.articleDeliveryFees?.fold(0, (previousValue, element) => MathUtil.add(previousValue, (element.totalPrice ?? 0))) ?? 0;
      salesCartDto.unpaid = MathUtil.subtract(MathUtil.add(salesCartDto.totalPrice, salesCartDto.totalDeliveryFee), salesCartDto.totalDiscount);
      salesCartDto.netAmount = salesCartDto.unpaid;

      yield QueueReservedState();
    } catch (error, stackTrace) {
      yield ErrorOrderState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<OrderState> mapInquiryQueueEventToState(InquiryQueueToEvent event) async* {
    try {
      SalesCartDto salesCartDto = salesCartBloc.state.salesCartDto;
      SalesCartReserve salesCartReserve = salesCartBloc.state.salesCartReserve;

      salesCartDto.displayQueueItemList = <QueueDataItemDto>[];

      QueueData mainQueueData = salesCartReserve.isReserveSingleTime ? salesCartReserve.queueDataList.first : null;
      List<QueueData> queueDataList = salesCartReserve.isReserveSingleTime ? salesCartReserve.queueDataList.first.queueReserveSingleTimeGroup : salesCartReserve.queueDataList;

      queueDataList.forEach((qData) {
        if (qData.isFreeServiceQueue()) qData.isPending = true;
        qData.queueDataItems.forEach((qDataItem) {
          QueueDataItemDto item = QueueDataItemDto(
            selectedDate: salesCartReserve.isReserveSingleTime && !qData.isPending ? mainQueueData.selectedDate : qData.selectedDate,
            selectedTimeNo: salesCartReserve.isReserveSingleTime && !qData.isPending ? mainQueueData.selectedTimeNo : qData.selectedTimeNo,
            selectedTimeType: salesCartReserve.isReserveSingleTime && !qData.isPending ? mainQueueData.selectedTimeType : qData.selectedTimeType,
            startDate: salesCartReserve.isReserveSingleTime && !qData.isPending ? mainQueueData.startDate : qData.startDate,
            fastestDate: salesCartReserve.isReserveSingleTime && !qData.isPending ? mainQueueData.fastestDate : qData.fastestDate,
            fastestTime: salesCartReserve.isReserveSingleTime && !qData.isPending ? mainQueueData.fastestTimeNo : qData.fastestTimeNo,
            queueDateMap: salesCartReserve.isReserveSingleTime && !qData.isPending ? mainQueueData.queueDateMap : Map<DateTime, QueueDateMap>.from(qData.queueDateMap),
            readyDateInStock: qData.dateIntoStock,
            jobNo: qData.jobNo,
            jobType: qData.jobType,
            patType: qData.patType,
            prdNo: qData.prdNo,
            queueStyle: qData.queueStyle,
            shippointManage: qData.shippointManage,
            selectedWorker: qData.selectedWorker,
            salesCartItem: qDataItem.salesCartItem,
            basketItem: getBasketItem(qDataItem.salesCartItem.articleNo, qDataItem.salesCartItem.itemUpc, qDataItem.salesCartItem.qty),
            isPending: qData.isPending,
          );
          salesCartDto.displayQueueItemList.add(item);
        });
      });

      /// Service mainInstall ไปผูกกับตัวแม่
      List<QueueDataItemDto> lstMainInstallService = salesCartDto.displayQueueItemList.where((element) => element.salesCartItem.isMainInstall).toList();
      for (QueueDataItemDto mainInstallService in lstMainInstallService) {
        int refOid = mainInstallService.salesCartItem.refSalesCartItemOid;
        QueueDataItemDto refQueueDataItem = salesCartDto.displayQueueItemList.firstWhere((element) => element.salesCartItem.salesCartItemOid == refOid, orElse: () => null);
        if (refQueueDataItem != null) {
          refQueueDataItem.queueItemInstallServices.add(mainInstallService);
          salesCartDto.displayQueueItemList.remove(mainInstallService);
        }
      }

      /// Service mainInstall Merge ปฏิทินอีกครั้ง
      for (QueueDataItemDto queueDataItemDto in salesCartDto.displayQueueItemList) {
        if (queueDataItemDto.isPending || queueDataItemDto.queueItemInstallServices == null || queueDataItemDto.queueItemInstallServices.isNullOrEmpty) continue;
        queueDataItemDto.queueDateMap = mergeQueueDateMap(queueDataItemDto.queueDateMap, queueDataItemDto.queueItemInstallServices.map((e) => e.queueDateMap).toList());
        QueueDateMap queueDateMap = queueDataItemDto.queueDateMap.values.firstWhere(
          (element) => element.status == DateStatus.Available,
          orElse: () => null,
        );
        queueDataItemDto
          ..selectedDate = queueDateMap?.date
          ..selectedTimeNo = queueDateMap?.queueTime?.first?.timeNo;
        if (queueDataItemDto.selectedTimeNo != null) {
          queueDataItemDto.selectedTimeType = TimeNo.NO_DURATION == queueDataItemDto.selectedTimeNo ? TimeType.NO_DURATION : TimeType.SPECIFY_DURATION;
        }
        if (queueDateMap?.date != null && (queueDataItemDto.fastestDate == null || queueDataItemDto.fastestDate.compareTo(queueDateMap?.date) > 0)) {
          queueDataItemDto.fastestDate = queueDateMap?.date;
          queueDataItemDto.fastestTime = queueDataItemDto.selectedTimeNo;
        }
      }

      salesCartDto.totalDiscount = basketBloc.state.totalDiscountAmt;

      salesCartDto.totalPrice = salesCartDto.salesCart.salesCartItems.fold(0, (previousValue, element) => MathUtil.add(previousValue, MathUtil.multiple(element.unitPrice, element.qty)));
      salesCartDto.totalDeliveryFee = salesCartReserve.articleDeliveryFees?.fold(0, (previousValue, element) => MathUtil.add(previousValue, (element.totalPrice ?? 0))) ?? 0;
      salesCartDto.unpaid = MathUtil.add(MathUtil.add(salesCartDto.totalPrice, salesCartDto.totalDeliveryFee), salesCartDto.totalDiscount);
      salesCartDto.netAmount = salesCartDto.unpaid;

      yield InquiryQueueCompleteState();
    } catch (error, stackTrace) {
      yield ErrorOrderState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<OrderState> mapChangeQueueDateEventToState(ChangeQueueDateToEvent event) async* {
    try {
      yield InquiryQueueCompleteState();
    } catch (error, stackTrace) {
      yield ErrorOrderState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  Stream<OrderState> mapCalculatePromotionEventToState(CalPromotionEvent event) async* {
    try {
      yield CalculatePromotionCompleteState();
    } catch (error, stackTrace) {
      yield ErrorOrderState(error: AppException(error, stackTrace: stackTrace));
    }
  }

  SalesCartItem mapToSalesCartItem(List<SalesOrder> salesOrderList, SalesOrderItem salesOrderItem) {
    SalesCartItem salesCartItem = SalesCartItem();
    salesCartItem.articleNo = salesOrderItem.articleNo;
    salesCartItem.lineItem = salesOrderItem.seqNo?.toString();
    salesCartItem.itemDescription = salesOrderItem.description;
    salesCartItem.qty = salesOrderItem.quantity;
    salesCartItem.unit = salesOrderItem.unit;
    salesCartItem.unitPrice = salesOrderItem.unitPrice;
    salesCartItem.netItemAmt = salesOrderItem.netItemAmount;
    salesCartItem.salesCartItemOid = salesOrderItem.salesCartItemOid;
    salesCartItem.isInstallSameDay = salesOrderItem.isMainProduct;
    salesCartItem.itemUpc = salesOrderItem.itemUPC;
    salesCartItem.isSalesSet = salesOrderItem.isSalesSet;
    salesCartItem.isQtyReq = salesOrderItem.isQtyRequired;
    salesCartItem.batch = salesOrderItem.batch;
    salesCartItem.incentiveId = salesOrderItem.userIncentiveId;
    salesCartItem.incentiveName = salesOrderItem.userIncentiveName;
    salesCartItem.isSpecialDts = salesOrderItem.isSpecialDTS;
    salesCartItem.isSpecialOrder = salesOrderItem.isSpecialOrder;
    salesCartItem.remark = salesOrderItem.remark;
    salesCartItem.shippingPointId = salesOrderItem.shippingPointId;
    salesCartItem.shippingPointId = salesOrderItem.deliverySite;

    if (salesOrderItem.refSeqNo != null) {
      SalesOrderItem pDataItem = salesOrderList
          .firstWhere(
            (element) => element.salesOrderGroups.any((a) => a.salesOrderItems.any((b) => b.seqNo == salesOrderItem.refSeqNo)),
            orElse: () => null,
          )
          ?.salesOrderItems
          ?.firstWhere(
            (e) => e.seqNo == salesOrderItem.refSeqNo,
            orElse: () => null,
          );
      if (pDataItem != null) salesCartItem.refSalesCartItemOid = pDataItem.salesCartItemOid;
    }
    salesCartItem.isPremium = salesOrderItem.isPremium ?? false;
    salesCartItem.isMainInstall = salesOrderItem.isMainInstall ?? false;
    salesCartItem.isDeliveryFee = salesOrderItem.isDeliveryFee ?? false;

    return salesCartItem;
  }

  BasketItem getBasketItem(String artcId, String mainUpc, num qty) {
    List<BasketItem> basketItems = basketBloc.state.calculatedItems;
    return basketItems.firstWhere((e) => e.article.articleId == artcId && e.article.unitList?.first?.mainUPC == mainUpc && e.qty == qty, orElse: () => null);
  }

  Map<DateTime, QueueDateMap> mergeQueueDateMap(Map<DateTime, QueueDateMap> mainQueueDate, List<Map<DateTime, QueueDateMap>> queueDateList) {
    mainQueueDate.entries.forEach((ety) {
      if (ety.value.status != DateStatus.Available) return;
      if (queueDateList.any((e) => e.entries.any((element) => element.key == ety.key && element.value.status != DateStatus.Available))) {
        ety.value.status = DateStatus.Unavailable;
        return;
      }
      ety.value.queueTime.forEach((queueTime) {
        if (queueTime.capaQty == 0) return;
        queueTime.capaQty = queueDateList.map((e) => e[ety.key].queueTime).toList().any((element) => element.any((element) => element.timeNo == queueTime.timeNo && element.capaQty == 0)) ? 0 : queueTime.capaQty;
      });
      ety.value.queueTime.removeWhere((element) => element.capaQty == 0);
      if (ety.value.queueTime.isEmpty) ety.value.status = DateStatus.Unavailable;
    });
    return mainQueueDate;
  }
}
