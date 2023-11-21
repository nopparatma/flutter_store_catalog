import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/app/app_config.dart';
import 'package:flutter_store_catalog/core/app_logger.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/create_sales_order_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_available_queue_times_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_available_queue_times_rs.dart' as GetQueueRs;
import 'package:flutter_store_catalog/core/models/bkoffc/get_delivery_fee_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_delivery_fee_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sales_cart_by_oid_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sell_channel_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_sell_channel_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_special_condition_item_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_special_condition_item_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_top_worker_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_top_worker_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/inquiry_stock_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/inquiry_stock_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/special_condition_item.dart';
import 'package:flutter_store_catalog/core/models/view/queue_data.dart';
import 'package:flutter_store_catalog/core/models/view/queue_data_item_dto.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_dto.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_reserve.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/sales_order_service.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';
import 'package:flutter_store_catalog/core/utilities/math_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';
import 'package:flutter_store_catalog/core/app_exception.dart';
import 'package:meta/meta.dart';

part 'delivery_inquiry_reserve_event.dart';

part 'delivery_inquiry_reserve_state.dart';

class DeliveryInquiryReserveBloc extends Bloc<DeliveryInquiryReserveEvent, DeliveryInquiryReserveState> {
  final ApplicationBloc applicationBloc;
  final SalesCartBloc salesCartBloc;
  final SaleOrderService _saleOrderService = getIt<SaleOrderService>();

  DeliveryInquiryReserveBloc(this.applicationBloc, this.salesCartBloc);

  @override
  DeliveryInquiryReserveState get initialState => InitialDeliveryInquiryReserveState();

  @override
  Stream<DeliveryInquiryReserveState> mapEventToState(DeliveryInquiryReserveEvent event) async* {
    if (event is InquiryQueueEvent) {
      yield* mapEventInquiryQueueToState(event);
    } else if (event is InquiryQueueSelectDateEvent) {
      yield* mapEventInquiryQueueSelectDateToState(event);
    } else if (event is ReserveQueueEvent) {
      yield* mapEventReserveQueueToState(event);
    } else if (event is CalculateDeliveryFeeEvent){
      yield* mapEventCalculateDeliveryFeeToState(event);
    }
  }

  Stream<DeliveryInquiryReserveState> mapEventInquiryQueueToState(InquiryQueueEvent event) async* /**/ {
    try {
      yield DeliveryInquiryReserveLoadingState();

      AppSession appSession = applicationBloc.state.appSession;

      SalesCartReserve salesCartReserve = event.salesCartReserve;
      DateTime startDate = SOMode.INSTALL == salesCartReserve.soMode ? salesCartReserve.startDate : DateTimeUtil.toDate(DateTime.now()); // appSession.transactionDateTime;
      String shippoint = event.shippoint ?? salesCartReserve.shippoint ?? appSession.userProfile.storeId;
      bool isReserveSingleTime = salesCartReserve.isReserveSingleTime;
      bool isSameDay = salesCartReserve?.isSameDay;

      salesCartReserve.getItemNonFreeServiceList().forEach((e) {
        e.salesCartItem.isSameDay = isSameDay;
      });
      List<SalesCartItem> inquirySalesCartItems = salesCartReserve.salesCartItemList.map((e) => e.salesCartItem)?.toList();

      Customer customer = salesCartReserve.shipto != null
          ? salesCartReserve.shipto
          : salesCartReserve.soldto != null
              ? salesCartReserve.soldto
              : salesCartReserve.customerTemp;
      salesCartReserve
        ..shippoint = shippoint
        ..isReserveSingleTime = isReserveSingleTime;

      GetAvailableQueueTimesRq availableQueueTimesRq = GetAvailableQueueTimesRq(
        soMode: salesCartReserve.soMode,
        deliveryDate: isSameDay ? DateTimeUtil.toDate(DateTime.now()) : startDate.add(Duration(days: 7)),
        deliverySite: appSession.userProfile.storeId,
        storeId: appSession.userProfile.storeId,
        soldToNo: salesCartReserve.soldto?.sapId,
        shipToNo: salesCartReserve.shipto?.sapId,
        provinceName: customer.province,
        districtName: customer.district,
        subDistrictName: customer.subDistrict,
        timeType: TimeType.NO_DURATION,
        timeNo: TimeNo.NO_DURATION,
        salesCartItems: inquirySalesCartItems.map((e) => SalesCartItem.fromJson(e.toJson())).toList(),
        integrateDate: isReserveSingleTime ? 'Y' : 'N',
        isGroupQueue: false,
        systemName: SystemName.SCAT,
      );

      switch (salesCartReserve.soMode) {
        case SOMode.DELIVERY:
          for (SalesCartItem salesCartItem in availableQueueTimesRq.salesCartItems) {
            salesCartItem.shippingPointId = null;
            salesCartItem.deliverySite = null;
          }
          break;
        case SOMode.CUST_RECEIVE:
          {
            for (SalesCartItem salesCartItem in availableQueueTimesRq.salesCartItems) {
              salesCartItem.shippingPointId = Shippoint.CUSTOMER;
              salesCartItem.deliverySite = shippoint;
            }
          }
          break;
        case SOMode.INSTALL:
          {
            availableQueueTimesRq.servNo = 'I';
            for (SalesCartItem salesCartItem in availableQueueTimesRq.salesCartItems) {
              salesCartItem.shippingPointId = shippoint;
              salesCartItem.deliverySite = shippoint;
            }
          }
          break;
      }
      for (var salesCartItem in availableQueueTimesRq.salesCartItems) {
        if (SOMode.CUST_RECEIVE != salesCartReserve.soMode && (JobType.I == availableQueueTimesRq.servNo || salesCartItem.isInstallSameDay)) {
          salesCartItem.isMainPrd = true;
        }
      }

      /// {{Call API InquiryQueue}}
      GetQueueRs.GetAvailableQueueTimesRs getAvailableQueueTimesRs;

      try {
        getAvailableQueueTimesRs = await _saleOrderService.getAvailableQueueTimes(appSession, availableQueueTimesRq);

        // ระดับ Item
        if (getAvailableQueueTimesRs?.queueDatas?.any((e) => isServiceAreaNotFound(e.reserveMessage)) ?? false) {
          yield ServiceAreaNotFoundState();
          return;
        }

        if ((getAvailableQueueTimesRs?.queueDatas?.any((e) => StringUtil.isNotEmpty(e.reserveMessage)) ?? false) && !isHaveMessageAndCanReserveQueue(getAvailableQueueTimesRs, salesCartReserve.soMode)) {
          yield InquiryQueueErrorState('text.error_cannot_inquiry_delivery_date'.tr());
          return;
        }
      } catch (error, stackTrace) {
        //print(' ERROR ServiceAreaNotFound : ${error.error}');
        if (isServiceAreaNotFound('${error.error}')) {
          yield ServiceAreaNotFoundState();
          return;
        }
        AppLogger().e(error);
        // throw error;
        yield InquiryQueueErrorState('text.error_cannot_inquiry_delivery_date'.tr());
        return;
      }

      int inquiryRqItemCount = availableQueueTimesRq.salesCartItems.length;
      int inquiryRsItemCount = getAvailableQueueTimesRs.queueDatas.fold(0, (previousValue, element) => previousValue + element.queueDataItems.length);
      bool cannotReserveSameDay = getAvailableQueueTimesRs.queueDatas.any((e) => !e.isSameDay) || inquiryRqItemCount != inquiryRsItemCount;
      bool isAllCanReserve = true;

      if (isSameDay && cannotReserveSameDay) {
        salesCartReserve.getItemNonFreeServiceList().forEach((e) {
          e.salesCartItem.isSameDay = isSameDay;
        });
        yield InquiryQueueSuccessState(
          canReserveSameDay: false,
          isAllCanReserve: isAllCanReserve,
        );
        return;
      }

      /// {{Process AvailableQueueTime}}
      List<QueueData> queueDataList = getAvailableQueueTimesRs.queueDatas.map((e) => mapToQueueData(startDate, InquiryReserve.INQUIRY_DAY, inquirySalesCartItems, e)).toList();

      ///แยกคิวของแถมบริการ
      queueDataList = splitQueueFreeService(queueDataList);

      bool isHaveFreeServiceQueue = queueDataList.any((element) => element.isFreeServiceQueue());

      if (SOMode.CUST_RECEIVE != salesCartReserve.soMode && !isSameDay && queueDataList.any((e) => !e.queueDateMap.values.any((date) => date.status == DateStatus.Available))) {
        queueDataList = await processInquiryAgain(appSession, inquirySalesCartItems, availableQueueTimesRq, queueDataList, startDate, InquiryReserve.INQUIRY_DAY * 2);
      }

      isAllCanReserve = SOMode.CUST_RECEIVE == salesCartReserve.soMode || !queueDataList.any((e) => !e.queueDateMap.values.any((date) => date.status == DateStatus.Available));

      if (SOMode.CUST_RECEIVE == salesCartReserve.soMode) {
        for (QueueData queue in queueDataList) {
          for (QueueDataItem item in queue.queueDataItems) {
            item.salesCartItem.shippingPointId = Shippoint.CUSTOMER;
            item.salesCartItem.deliverySite = shippoint;
          }
        }
      }

      if (SOMode.CUST_RECEIVE != salesCartReserve.soMode) {
        for (QueueData queue in queueDataList) {
          queue.articleInstDiffTeam = [];
          for (QueueDataItem item in queue.queueDataItems) {
            if (JobType.D == queue.jobType && item.salesCartItem.isInstallSameDay ?? false) {
              item.salesCartItem.isInstallSameDay = false;
              item.salesCartItem.isInstallAfter = true;
              queue.articleInstDiffTeam.add(StringUtil.trimLeftZero(item.salesCartItem.articleNo));
            }
          }
        }
      }

      /// {{Process SpecialConditionItem}}
      GetSpecialConditionItemRq getSpecialConditionItemRq = GetSpecialConditionItemRq(
        storeId: appSession.userProfile.storeId,
        specialConditionItemBos: inquirySalesCartItems
            .where((element) => !StringUtil.isNullOrEmpty(element?.shippingPointId))
            .map(
              (e) => SpecialConditionItem(
                articleId: StringUtil.trimLeftZero(e.articleNo),
                shippingPointId: e.shippingPointId,
                isSpecialOrder: e.isSpecialOrder ?? false,
                isSpecialDts: e.isSpecialDts ?? false,
              ),
            )
            .toList(),
      );

      GetSpecialConditionItemRs getSpecialConditionItemRs = await _saleOrderService.getSpecialConditionItem(appSession, getSpecialConditionItemRq);
      List<QueueDataItem> allItemForSpecialCondition = queueDataList.fold([], (previousValue, element) => previousValue..addAll(element.queueDataItems));
      int index = 0;
      List<SalesCartItem> salesCartItemList = inquirySalesCartItems.where((element) => !StringUtil.isNullOrEmpty(element?.shippingPointId)).toList();
      for (SpecialConditionItem item in getSpecialConditionItemRs.specialConditionItemBos ?? []) {
        salesCartItemList[index]?.isSpecialOrder = item.isSpecialOrder;
        salesCartItemList[index]?.isSpecialDts = item.isSpecialDts;
        QueueDataItem queueDataItem = allItemForSpecialCondition.firstWhere((element) => element.salesCartItem.salesCartItemOid == salesCartItemList[index]?.salesCartItemOid, orElse: () => null);
        if(queueDataItem != null){
          queueDataItem.isDisableSpecialOrder = item.isSpecialOrder;
          queueDataItem.isDisableSpecialDts = item.isDisableSpecialDts;
          queueDataItem.isAutoCheckSpecialOrder = item.isAutoCheckSpecialOrder;
        }
        index++;
      }

      /// {{ค้นหา Item Batch}}
      /// สำหรับ dialog manage batch
      for (var queueData in queueDataList) {
        for (var queueDataItem in queueData.queueDataItems) {
          /// Article Lot Require && MCH3 isn't FC
          if (queueDataItem.salesCartItem.isLotReq && !(AppConfig.isHomePro() && queueDataItem.salesCartItem.mchId.startsWith('FC'))) {
            queueDataItem.salesCartItem.batch = null;
            InquiryStockRq inquiryStockRq = InquiryStockRq(
              storeId: Shippoint.VENDOR == shippoint ? appSession?.userProfile?.storeId : queueDataItem.salesCartItem.deliverySite,
              articleId: queueDataItem.salesCartItem.articleNo,
              unit: queueDataItem.salesCartItem.unit,
            );
            InquiryStockRs inquiryStockRs = await _saleOrderService.inquiryStock(appSession, inquiryStockRq);
            if (inquiryStockRs.sapBatchs?.isNotEmpty ?? false) {
              queueDataItem.sapBatchs = inquiryStockRs.sapBatchs;
            } else {
              /// กรณีไม่พบ batch จะ default batch `001`
              queueDataItem.sapBatchs = [SapBatch(batch: '001')];
            }
          }
        }
      }

      /// {{รวมคิว จองคิววันเวลาเดียวกัน}}
      if (isReserveSingleTime) {
        queueDataList = groupQueueReserveSingleTime(startDate, InquiryReserve.INQUIRY_DAY, queueDataList, getAvailableQueueTimesRs.queueDatas.map((e) => e.availableQueueTimes).toList());
      }

      /// {{Process TopWorker}}
      /// ต้องมี shipTo และ jobNo
      if (salesCartReserve.shipto != null) {
        for (var queue in queueDataList) {
          if (StringUtil.isNullOrEmpty(queue.jobNo)) continue;
          GetTopWorkerRq getTopWorkerRq = GetTopWorkerRq(
            shiptoNo: salesCartReserve.shipto.sapId,
            jobType: queue.jobNo,
            articleList: queue.queueDataItems.map((e) => GetTopWorkerRqArticle(article: e.salesCartItem.articleNo)).toList(),
          );
          GetTopWorkerRs getTopWorkerRs = await _saleOrderService.getTopWorker(appSession, getTopWorkerRq);
          queue
            ..isSpecifyWorker = getTopWorkerRs.isSpecifyWorker
            ..topWorkerList = getTopWorkerRs.topWorkerList;
        }
      }

      /// {{Default เลือก วัน เวลา แรกที่ว่าง}}
      for (QueueData queueData in queueDataList) {
        /// ลูกค้ารับเอง ไม่สนข้อมูลวันว่าง
        if (SOMode.CUST_RECEIVE == salesCartReserve.soMode) {
          queueData.dateIntoStock = queueData.dateIntoStock ?? startDate;
          queueData
            ..selectedDate = queueData.dateIntoStock
            ..fastestDate = queueData.dateIntoStock
            ..selectedTimeNo = TimeNo.NO_DURATION
            ..fastestTimeNo = TimeNo.NO_DURATION
            ..selectedTimeType = TimeType.NO_DURATION;

          continue;
        }

        if (queueData.isFreeServiceQueue()) {
          queueData.isPending = true;
          continue;
        }

        QueueDateMap queueDateMap = queueData.queueDateMap.values.firstWhere(
          (element) => element.status == DateStatus.Available,
          orElse: () => null,
        );
        queueData
          ..selectedDate = queueDateMap?.date
          ..selectedTimeNo = queueDateMap?.queueTime?.first?.timeNo;
        if (queueData.selectedTimeNo != null) {
          queueData.selectedTimeType = TimeNo.NO_DURATION == queueData.selectedTimeNo ? TimeType.NO_DURATION : TimeType.SPECIFY_DURATION;
        }

        if (queueData.fastestDate == null || queueData.fastestDate.compareTo(queueDateMap?.date) > 0) {
          queueData.fastestDate = queueDateMap?.date;
          queueData.fastestTimeNo = queueData.selectedTimeNo;
        }
      }

      /// {{save result to SalesCartReserve}}
      salesCartReserve.queueDataList = queueDataList;

      /// {{Calculate DeliveryFee}}
      /// เฉพาะ จองคิว Auto
      salesCartReserve..articleDeliveryFees = null;
      if (salesCartReserve.soMode == SOMode.DELIVERY) {
        SalesCart salesCart = salesCartBloc.state.salesCartDto.salesCart;
        GetDeliveryFeeRq getDeliveryFeeRq = createGetDeliveryFeeRq(appSession?.userProfile?.storeId, customer, salesCart, salesCartReserve);

        /// {{Cal API CalDeliveryFee}}
        GetDeliveryFeeRs getDeliveryFeeRs = await _saleOrderService.getDeliveryFee(appSession, getDeliveryFeeRq);
        salesCartReserve.articleDeliveryFees = getDeliveryFeeRs.articleDeliveryFees;
      }

      yield InquiryQueueSuccessState(canReserveSameDay: (isSameDay && !cannotReserveSameDay), isAllCanReserve: isAllCanReserve, isHaveFreeServiceQueue: isHaveFreeServiceQueue);
    } catch (error, stackTrace) {
      //SalesCartReserve salesCartReserve = salesCartReserveBloc.state.salesCartReserve;
      //salesCartReserve.queueDataList = [];
      AppLogger().e(error);
      yield InquiryQueueErrorState('text.error_cannot_inquiry_delivery_date'.tr());
    }
  }

  Stream<DeliveryInquiryReserveState> mapEventInquiryQueueSelectDateToState(InquiryQueueSelectDateEvent event) async* {
    try {
      yield DeliveryInquiryReserveLoadingState();

      AppSession appSession = applicationBloc.state.appSession;
      SalesCartReserve salesCartReserve = event.salesCartReserve;
      QueueDataItemDto queueData = salesCartReserve.isReserveSingleTime ? event.queueDataItemDtoList.first : event.selectQueueDataItemDto;

      Customer customer = salesCartReserve.shipto != null
          ? salesCartReserve.shipto
          : salesCartReserve.soldto != null
              ? salesCartReserve.soldto
              : salesCartReserve.customerTemp;

      List<SalesCartItem> salesCartItemList = <SalesCartItem>[];

      if (salesCartReserve.isReserveSingleTime) {
        event.queueDataItemDtoList.forEach((e) {
          salesCartItemList.add(e.salesCartItem);
        });
      } else {
        salesCartItemList.add(event.selectQueueDataItemDto.salesCartItem);
      }

      DateTime inquiryDate;
      DateTime startDate;
      if (event.inquiryDate != null || queueData.selectedDate != null) {
        inquiryDate = event.inquiryDate ?? queueData.selectedDate;
        startDate = inquiryDate.subtract(Duration(days: 7));
      } else {
        startDate = DateTimeUtil.toDate(queueData.startDate);
        inquiryDate = startDate.add(Duration(days: 7));
      }

      GetAvailableQueueTimesRq availableQueueTimesRq = GetAvailableQueueTimesRq(
        soMode: salesCartReserve.soMode,
        deliveryDate: inquiryDate,
        deliverySite: appSession.userProfile.storeId,
        storeId: appSession.userProfile.storeId,
        soldToNo: salesCartReserve.soldto?.sapId,
        shipToNo: salesCartReserve.shipto?.sapId,
        provinceName: customer.province,
        districtName: customer.district,
        subDistrictName: customer.subDistrict,
        timeType: TimeType.NO_DURATION,
        timeNo: TimeNo.NO_DURATION,
        salesCartItems: salesCartItemList,
        integrateDate: salesCartReserve.isReserveSingleTime ? 'Y' : 'N',
        isGroupQueue: false,
        jobNo: queueData.jobNo,
        servNo: queueData.jobType,
        prdTypeNo: queueData.prdNo,
        systemName: SystemName.SCAT,
      );

      GetQueueRs.GetAvailableQueueTimesRs getAvailableQueueTimesRs = await _saleOrderService.getAvailableQueueTimes(appSession, availableQueueTimesRq);

      List<GetQueueRs.AvailableQueueTimes> availableQueueTimes = <GetQueueRs.AvailableQueueTimes>[];

      /// {{รวมคิว จองคิววันเวลาเดียวกัน}}
      if (salesCartReserve.isReserveSingleTime) {
        List<List<GetQueueRs.AvailableQueueTimes>> availableQueueTimesList = getAvailableQueueTimesRs.queueDatas.map((e) => e.availableQueueTimes).toList();
        availableQueueTimes = mergeAvailableQueueTimes(availableQueueTimesList);
      } else {
        GetQueueRs.QueueData queueDataRs = getAvailableQueueTimesRs.queueDatas.last;
        queueData
          ..queueStyle = queueDataRs.queueStyle
          ..patType = queueDataRs.patType
          ..jobNo = queueDataRs.jobNo
          ..jobType = queueDataRs.jobType
          ..prdNo = queueDataRs.prdNo
          ..shippointManage = queueDataRs.shippointManage;

        availableQueueTimes = queueDataRs.availableQueueTimes;
      }

      queueData.queueDateMap = addToQueueDataMap(queueData.queueDateMap, startDate, InquiryReserve.INQUIRY_DAY, availableQueueTimes);

      yield InquiryQueueSelectDaySuccessState(queueData);
    } catch (error, stackTrace) {
      AppLogger().e(error);
      yield InquiryQueueSelectDateErrorState('text.error_cannot_inquiry_delivery_date'.tr());
    }
  }

  Stream<DeliveryInquiryReserveState> mapEventReserveQueueToState(ReserveQueueEvent event) async* /**/ {
    try {
      yield DeliveryInquiryReserveLoadingState();

      AppSession appSession = applicationBloc.state.appSession;
      SalesCart salesCart = SalesCart.fromJson(salesCartBloc.state.salesCartDto.salesCart.toJson());
      SalesCartReserve salesCartReserve = salesCartBloc.state.salesCartReserve;

      /// เพิ่ม ค่าขนส่ง/ติดตั้ง
      /// เพิ่มใน คิว ที่มี jobTyp และ queueStyle เดียวกัน ระบุเป็น article ค่าขนส่ง/ติดตั้ง[isDeliveryFee]
      /// โดย คิว ต้องไม่ใช่ คิว Vendor จัดส่ง
      /// หากไม่มีคิวให้ลง จะเพิ่มคิวใหม่ และ ระบุเป็น คิวค่าขนส่ง/ติดตั้ง[isQueueDeliveryFee]
      for (ArticleDeliveryFee item in salesCartReserve.articleDeliveryFees ?? []) {
        // print('ProcessDeliveryFee ${item.artDesc} - ${item.totalPrice}');
        bool isAdded = false;
        for (var queue in salesCartReserve.queueDataList) {
          String shippoint = queue.queueDataItems?.first?.salesCartItem?.shippingPointId;
          String deliverySite = queue.queueDataItems?.first?.salesCartItem?.deliverySite;

          if (shippoint == null || Shippoint.VENDOR == shippoint) continue;

          DateTime nextDay = DateTimeUtil.toDate(DateTime.now()).add(Duration(days: 1));
          bool isSameJob = queue.jobType == item.servNo;
          bool isSameQueueStyle = queue.queueStyle == QueueStyle.NEXT_DAY && queue.selectedDate != nextDay ? <String>[QueueStyle.NEXT_DAY, QueueStyle.NORMAL].contains(item.queueStyle) : queue.queueStyle == item.queueStyle;

          if (salesCartReserve.isReserveSingleTime || (isSameJob && isSameQueueStyle)) {
            int allItemCount = salesCartReserve.queueDataList.fold(0, (previousValue, element) => MathUtil.add(previousValue, element.queueDataItems.length));
            queue.queueDataItems.add(
              QueueDataItem(
                salesCartItem: generateSalesCartItemDeliveryFee(
                  item,
                  allItemCount,
                  shippoint: shippoint,
                  deliverySite: deliverySite,
                ),
                clmFlag: item.clmFlag,
              ),
            );
            isAdded = true;
            break;
          }
        }
        if (!isAdded) {
          int allItemCount = salesCartReserve.queueDataList.fold(0, (previousValue, element) => MathUtil.add(previousValue, element.queueDataItems.length));

          QueueData queue = salesCartReserve.queueDataList.first;
          salesCartReserve.queueDataList.add(
            QueueData(
              queueDataItems: [
                QueueDataItem(
                  salesCartItem: generateSalesCartItemDeliveryFee(
                    item,
                    allItemCount,
                    shippoint: Shippoint.CUSTOMER,
                    deliverySite: appSession.userProfile.storeId,
                  ),
                )
              ],
              selectedDate: queue.selectedDate,
              appointmentType: DsConfType.NOT_CONFIRM,
              selectedTimeNo: TimeNo.NO_DURATION,
              selectedTimeType: TimeType.NO_DURATION,
              isPending: queue.isPending,
              jobType: queue.jobType,
              queueStyle: queue.queueStyle,
              isSameDay: false,
              isCanReserveQueue: true,
              isOutOfStock: false,
              isQueueDeliveryFee: true,
            ),
          );
        }
      }

      for (var queue in salesCartReserve.queueDataList) {
        if (queue.appointmentType != DsConfType.NOT_CONFIRM && StringUtil.isNullOrEmpty(queue.contactName)) {
          yield ReserveQueueErrorState(AppException('warning.please_specify_contact_name'.tr(), errorType: ErrorType.WARNING));
          return;
        }
        if (queue.appointmentType != DsConfType.NOT_CONFIRM && StringUtil.isNullOrEmpty(queue.contactTel)) {
          yield ReserveQueueErrorState(AppException('warning.please_specify_contact_tel'.tr(), errorType: ErrorType.WARNING));
          return;
        }
        if (salesCartReserve.soMode != SOMode.CUST_RECEIVE && !queue.isPending && (queue.selectedDate == null || StringUtil.isNullOrEmpty(queue.selectedTimeNo))) {
          yield ReserveQueueErrorState(AppException('warning.please_specify_appointment_time'.tr(), errorType: ErrorType.WARNING));
          return;
        }
        // if (queue.isPending && StringUtil.isNullOrEmpty(queue.pendingContactDate)) {
        //   yield ReserveQueueErrorState(AppException('text.please_specify_pending_contact_date'.tr(), errorType: ErrorType.WARNING));
        //   return;
        // }
      }

      List<SalesCartItem> deleteSalesCartItems = [];
      List<SalesCartItem> salesCartItemReserve = salesCartReserve.queueDataList.fold(
        [],
        (previousValue, element) => previousValue..addAll(element.queueDataItems.map((e) => e.salesCartItem).toList()),
      );
      for (var salesCartItem in salesCartReserve.salesCartItemList.map((e) => e.salesCartItem).toList()) {
        if (salesCartItemReserve.any((element) => element.articleNo == salesCartItem.articleNo && element.isDeliveryFee && !(salesCartItem.isDeliveryFee ?? false))) {
          deleteSalesCartItems.add(salesCartItem);
        }
      }

      if (salesCartReserve.isReserveSingleTime) {
        QueueData queueData = salesCartReserve.queueDataList.first;
        queueData.queueReserveSingleTimeGroup.forEach((element) {
          element
            ..appointmentType = queueData.appointmentType
            ..contactName = queueData.contactName
            ..contactTel = queueData.contactTel
            ..selectedDate = queueData.selectedDate
            ..selectedTimeType = queueData.selectedTimeType
            ..selectedTimeNo = queueData.selectedTimeNo
            ..spacialOrderText = queueData.spacialOrderText
            ..isPending = queueData.isPending;
        });
      }

      List<SalesOrder> salesOrders = [await mapToSalesOrder(appSession, salesCart, salesCartReserve)];

      /// set qty จาก salesCart คืน ให้ Item salesCartReserve
      /// แล้ว set Item จาก salesCartReserve ลง SalesCart
      salesCart.customer = salesCartReserve.soldto;
      for (var item in salesCartReserve.salesCartItemList) {
        SalesCartItem salesCartItem = salesCart.salesCartItems.firstWhere((element) => element.salesCartItemOid == item.salesCartItem.salesCartItemOid);
        item.salesCartItem.qty = salesCartItem.qty;
      }
      salesCart.salesCartItems = salesCartReserve.salesCartItemList.map((e) => e.salesCartItem).toList();

      CreateSalesOrderRq createSalesOrderRq = CreateSalesOrderRq(
        soMode: salesCartReserve.soMode,
        isGroupQueue: false,
        salesCart: salesCart,
        salesOrders: salesOrders,
        updateBy: appSession.userProfile.empId,
        updateByEmpName: appSession.userProfile.empName,
        channelCode: SystemName.SCAT,
        village: salesCart.village,
        lat: salesCart.mapLat,
        lon: salesCart.mapLong,
        shippointManage: salesCartReserve.deliveryMng,
        prdTypeNo: salesCartReserve.mainProductType,
        servNo: salesCartReserve.jobType,
        deleteSalesCartItems: deleteSalesCartItems,
        reserveManual: salesCartReserve.soMode == SOMode.DELIVERY ? 'N' : 'Y',
        systemName: SystemName.SCAT,
      );
      await _saleOrderService.createSalesOrder(appSession, createSalesOrderRq);

      GetSalesCartByOidRq getSalesCartByOidRq = GetSalesCartByOidRq();
      getSalesCartByOidRq.salesCartOid = salesCart.salesCartOid;

      GetSalesCartByOidRs getSalesCartByOidRs = await _saleOrderService.getSalesCartByOid(appSession, getSalesCartByOidRq);

      salesCartBloc.state.salesCartDto.salesCart = getSalesCartByOidRs.salesCart;

      // salesCartReserveBloc.add(ResetSalesCartReserveEvent());
      yield ReserveQueueSuccessState();
    } catch (error, stackTrace) {
      AppLogger().e(error);
      yield ReserveQueueErrorState('text.error_cannot_reservations'.tr());
    }
  }

  Stream<DeliveryInquiryReserveState> mapEventCalculateDeliveryFeeToState(CalculateDeliveryFeeEvent event) async* {
    try {
      yield DeliveryInquiryReserveLoadingState();

      AppSession appSession = applicationBloc.state.appSession;
      SalesCart salesCart = salesCartBloc.state.salesCartDto.salesCart;
      SalesCartReserve salesCartReserve = salesCartBloc.state.salesCartReserve;
      Customer customer = salesCartReserve.shipto != null
          ? salesCartReserve.shipto
          : salesCartReserve.soldto != null
              ? salesCartReserve.soldto
              : salesCartReserve.customerTemp;
      GetDeliveryFeeRq getDeliveryFeeRq = createGetDeliveryFeeNextDayChangeDateRq(appSession.userProfile.storeId, customer, salesCart, salesCartReserve, event.queueDataItems);

      /// {{Cal API CalDeliveryFee}}
      GetDeliveryFeeRs getDeliveryFeeRs = await _saleOrderService.getDeliveryFee(appSession, getDeliveryFeeRq);
      salesCartReserve.articleDeliveryFees = getDeliveryFeeRs.articleDeliveryFees;

      salesCartBloc.state.salesCartDto.totalDeliveryFee = salesCartReserve.articleDeliveryFees?.fold(0, (previousValue, element) => MathUtil.add(previousValue, (element.totalPrice ?? 0))) ?? 0;

      yield CalculateDeliveryFeeSuccessState();
    } catch (error, stackTrace) {
      yield InquiryQueueErrorState(AppException(error, stackTrace: stackTrace));
    }
  }


  bool isServiceAreaNotFound(String errMsg) {
    if (StringUtil.isNullOrEmpty(errMsg)) return false;

    // validate นอกพื้นที่จัดส่ง
    String dsServiceAreaNotFound = applicationBloc.state.sysCfgMap[SystemConfig.DS_SERVICE_AREA_NOT_FOUND];
    List<String> listDsServiceAreaNotFound = dsServiceAreaNotFound.split(',');
    for (String item in listDsServiceAreaNotFound) {
      if (errMsg.contains(item)) {
        return true;
      }
    }

    return false;
  }

  bool isHaveMessageAndCanReserveQueue(GetQueueRs.GetAvailableQueueTimesRs getAvailableQueueTimesRs, String soMode) {
    if (soMode == SOMode.CUST_RECEIVE) {
      return getAvailableQueueTimesRs.queueDatas.every((element) => element.isOutOfStock);
    }

    return getAvailableQueueTimesRs.queueDatas.every((element) => element.availableQueueTimes.isNotNE);
  }

  Future<List<QueueData>> processInquiryAgain(AppSession appSession, List<SalesCartItem> salesCartItems, GetAvailableQueueTimesRq availableQueueTimesRq, List<QueueData> queueDataList, DateTime startDate, int inquiryDay, {bool isLastInquiry = false}) async {
    availableQueueTimesRq.deliveryDate = availableQueueTimesRq.deliveryDate.add(Duration(days: InquiryReserve.INQUIRY_DAY));

    availableQueueTimesRq.salesCartItems = availableQueueTimesRq.salesCartItems
        .where(
          (item) => queueDataList.any(
            (e) => e.queueDataItems.any((qItem) => qItem.salesCartItem == item) && !e.queueDateMap.values.any((date) => date.status == DateStatus.Available),
          ),
        )
        .toList()
          ..forEach((salesCartItem) {
            salesCartItem.deliverySite = null;
            salesCartItem.shippingPointId = null;
            salesCartItem.stockQty = null;
          });

    GetQueueRs.GetAvailableQueueTimesRs getAvailableQueueTimesRs = await _saleOrderService.getAvailableQueueTimes(appSession, availableQueueTimesRq);

    List<QueueData> newQueueDataList = getAvailableQueueTimesRs.queueDatas.map((e) => mapToQueueData(startDate, inquiryDay, salesCartItems, e)).toList();

    queueDataList = queueDataList.where((e) => e.queueDateMap.values.any((date) => date.status == DateStatus.Available)).toList();
    queueDataList.addAll(newQueueDataList);

    if (!isLastInquiry && newQueueDataList.any((e) => !e.queueDateMap.values.any((date) => date.status == DateStatus.Available))) {
      queueDataList = await processInquiryAgain(appSession, salesCartItems, availableQueueTimesRq, queueDataList, startDate, inquiryDay + InquiryReserve.INQUIRY_DAY, isLastInquiry: true);
    }

    return queueDataList;
  }

  GetDeliveryFeeRq createGetDeliveryFeeRq(String storeId, Customer customer, SalesCart salesCart, SalesCartReserve salesCartReserve) {
    bool isReserveSingleTime = salesCartReserve.isReserveSingleTime;
    List<QueueData> queueDataList = salesCartReserve.queueDataList;

    /// คำนวนยอดเงินที่ซื้อ
    /// ไม่นับรวม Article ค่าขนส่ง
    num purchaseAmount = getDeliveryFeePurchaseAmount(salesCart, salesCartReserve);

    /// ข้อมูลคิวที่จอง
    /// QueueStyle
    /// * กรณีเป็น Queue Next Day ตรวจสอบ วันที่เลือกจอง ถ้าไม่ใช่วันพรุ่งนี้ จะให้ระบุเป็น Queue Normal
    /// * กรณีอื่น (Normal, Same Day) ระบุตามนั้น
    /// Shippoint
    /// * เลือกจาก ShippingPointId ของ Article ตัวแรกในคิว
    List<ReservItem> reservItems = [];
    List<QueueData> allQueueList = isReserveSingleTime ? queueDataList.first.queueReserveSingleTimeGroup : queueDataList;
    for (var queue in allQueueList) {
      if (queue.isQueueDeliveryFee) continue;
      DateTime nextDay = DateTimeUtil.toDate(DateTime.now()).add(Duration(days: 1));
      DateTime selectedDate = isReserveSingleTime ? queueDataList.first.selectedDate : queue.selectedDate;
      reservItems.add(
        ReservItem(
          patKey: queue.jobNo,
          servNo: queue.jobType,
          queueStyle: QueueStyle.NEXT_DAY == queue.queueStyle ? (nextDay == selectedDate ? QueueStyle.NEXT_DAY : QueueStyle.NORMAL) : queue.queueStyle,
          shippoint: queue.queueDataItems?.isNotEmpty ?? false ? queue.queueDataItems?.first?.salesCartItem?.shippingPointId ?? '' : '',
        ),
      );
    }

    return GetDeliveryFeeRq(
      appChannel: 'SS',
      storeId: storeId,
      province: customer.province,
      district: customer.district,
      subDistrict: customer.subDistrict,
      purchaseAmount: purchaseAmount,
      cardNo: StringUtil.isNotEmpty(salesCartReserve?.soldto?.cardNumber) ? salesCartReserve?.soldto?.cardNumber?.split(" ")[0] : '',
      cardType: salesCartReserve?.soldto?.memberCardTypeId,
      reservItems: reservItems,
    );
  }

  GetDeliveryFeeRq createGetDeliveryFeeNextDayChangeDateRq(String storeId, Customer customer, SalesCart salesCart, SalesCartReserve salesCartReserve, List<QueueDataItemDto> queueDataItems) {
    bool isReserveSingleTime = salesCartReserve.isReserveSingleTime;
    List<QueueData> queueDataList = salesCartReserve.queueDataList;

    /// คำนวนยอดเงินที่ซื้อ
    /// ไม่นับรวม Article ค่าขนส่ง
    num purchaseAmount = getDeliveryFeePurchaseAmount(salesCart, salesCartReserve);

    /// ข้อมูลคิวที่จอง
    /// QueueStyle
    /// * กรณีเป็น Queue Next Day ตรวจสอบ วันที่เลือกจอง ถ้าไม่ใช่วันพรุ่งนี้ จะให้ระบุเป็น Queue Normal
    /// * กรณีอื่น (Normal, Same Day) ระบุตามนั้น
    /// Shippoint
    /// * เลือกจาก ShippingPointId ของ Article ตัวแรกในคิว
    List<ReservItem> reservItems = [];
    for (var queue in queueDataItems) {
      if (queue.isPending) continue;
      DateTime nextDay = DateTimeUtil.toDate(DateTime.now()).add(Duration(days: 1));
      DateTime selectedDate = isReserveSingleTime ? queueDataList.first.selectedDate : queue.selectedDate;
      reservItems.add(
        ReservItem(
          patKey: queue.jobNo,
          servNo: queue.jobType,
          queueStyle: QueueStyle.NEXT_DAY == queue.queueStyle ? (nextDay == selectedDate ? QueueStyle.NEXT_DAY : QueueStyle.NORMAL) : queue.queueStyle,
          shippoint: queue?.salesCartItem?.shippingPointId ?? '',
        ),
      );
    }

    return GetDeliveryFeeRq(
      appChannel: 'SS',
      storeId: storeId,
      province: customer.province,
      district: customer.district,
      subDistrict: customer.subDistrict,
      purchaseAmount: purchaseAmount,
      cardNo: StringUtil.isNotEmpty(salesCartReserve?.soldto?.cardNumber) ? salesCartReserve?.soldto?.cardNumber?.split(" ")[0] : '',
      cardType: salesCartReserve?.soldto?.memberCardTypeId,
      reservItems: reservItems,
    );
  }

  num getDeliveryFeePurchaseAmount(SalesCart salesCart, SalesCartReserve salesCartReserve){
    String articleDeliveryFee = applicationBloc.state.sysCfgMap[SystemConfig.ART_DELIVERY_FEE];
    List<String> articleDeliveryFeeList = articleDeliveryFee.split(',');
    List<SalesCartItem> salesCartItems = salesCartReserve.salesCartItemList.map((e) => e.salesCartItem).toList();

    /// คำนวนยอดเงินที่ซื้อ
    /// ไม่นับรวม Article ค่าขนส่ง
    num purchaseAmount = 0;
    for (var salesOrder in salesCart.salesOrders ?? []) {
      for (var salesOrderGroup in salesOrder.salesOrderGroups) {
        if (salesOrderGroup?.shipToCustomer != null && salesCartReserve.shipto != null) {
          if (salesOrderGroup.shipToCustomer.sapId != salesCartReserve.shipto.sapId) continue;
        } else {
          Customer currentCustomer = salesCartReserve.customerTemp;
          String salesCartAddress = '${salesCart.province} ${salesCart.district} ${salesCart.subDistrict} ${salesCart.floorNumber} ${salesCart.soi} ${salesCart.zipCode} ${salesCart.village} ${salesCart.street} ${salesCart.moo}';
          String currentAddress = '${currentCustomer?.province} ${currentCustomer?.district} ${currentCustomer?.subDistrict} ${currentCustomer?.floor} ${currentCustomer?.soi} ${currentCustomer?.zipCode} ${currentCustomer?.village} ${currentCustomer?.street} ${currentCustomer?.moo}';
          if (salesCartAddress != currentAddress) continue;
        }
        for (var salesOrderItem in salesOrderGroup?.salesOrderItems ?? List<SalesOrderItem>()) {
          if (articleDeliveryFeeList.contains(salesOrderItem.articleNo)) continue;
          purchaseAmount = MathUtil.add(purchaseAmount, salesOrderItem.netItemAmount);
        }
      }
    }
    for (var item in salesCartItems) {
      if (articleDeliveryFeeList.contains(item.articleNo) || item.isDeliveryFee) continue;
      purchaseAmount = MathUtil.add(purchaseAmount, MathUtil.multiple(item.qtyRemain, item.unitPrice));
    }

    return purchaseAmount;
  }

  Future<SalesOrder> mapToSalesOrder(AppSession appSession, SalesCart salesCart, SalesCartReserve salesCartReserve) async {
    GetSellChannelRq getSellChannelRq = GetSellChannelRq();
    getSellChannelRq.storeId = appSession?.userProfile?.storeId;
    getSellChannelRq.salesChannel = SellChannel.SALES_CHANNEL;

    GetSellChannelRs getSellChannelRs = await _saleOrderService.getSellChannel(appSession, getSellChannelRq);

    if (getSellChannelRs.sellChannelLists.isNullOrEmpty) {
      throw AppException('error.not_found_sell_channel'.tr());
    }

    List<SalesOrderGroup> salesOrderGroup = mapToSalesOrderGroups(salesCartReserve);
    return SalesOrder(
      storeId: appSession?.userProfile?.storeId,
      transactionDate: appSession?.transactionDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      salesType: 'SO',
      startDate: appSession?.transactionDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      createDate: appSession?.transactionDateTime ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      salesChannel: getSellChannelRs.sellChannelLists.first.salesChannel,
      sapOrderCode: getSellChannelRs.sellChannelLists.first.sapOrderCode,
      distributionChannel: getSellChannelRs.sellChannelLists.first.distributionChannel,
      firstName: salesCart.firstName,
      lastName: salesCart.lastName,
      telephoneNo: salesCart.telephoneNo,
      district: salesCart.district,
      subDistrict: salesCart.subDistrict,
      province: salesCart.province,
      zipCode: salesCart.zipCode,
      village: salesCart.village,
      unit: salesCart.unit,
      floorNumber: salesCart.floorNumber,
      moo: salesCart.moo,
      soi: salesCart.soi,
      number: salesCart.number,
      street: salesCart.street,
      routeDetails: salesCart.routeDetails,
      mapLat: salesCart.mapLat,
      mapLong: salesCart.mapLong,
      soldToCustomer: salesCartReserve.soldto,
      salesOrderGroups: salesOrderGroup,
      salesOrderItems: salesOrderGroup.fold(<SalesOrderItem>[], (previousValue, element) => previousValue..addAll(element.salesOrderItems)),
    );
  }

  List<SalesOrderGroup> mapToSalesOrderGroups(SalesCartReserve salesCartReserve) {
    List<QueueData> queueData = salesCartReserve.isReserveSingleTime ? salesCartReserve.queueDataList.first.queueReserveSingleTimeGroup : salesCartReserve.queueDataList;
    return queueData.map((e) => mapToSalesOrderGroup(salesCartReserve, e)).toList();
  }

  SalesOrderGroup mapToSalesOrderGroup(SalesCartReserve salesCartReserve, QueueData queueData) {
    SalesOrderGroup salesOrderGroup = SalesOrderGroup();
    salesOrderGroup.shipToCustomer = salesCartReserve.shipto;
    salesOrderGroup.confirmTypeId = queueData.appointmentType;
    salesOrderGroup.confirmTypeDesc = queueData.contactTel;
    salesOrderGroup.remark = queueData.spacialOrderText;
    salesOrderGroup.jobNo = queueData.jobNo;
    salesOrderGroup.jobType = InstallJobType(jobTypeId: queueData.jobType);
    salesOrderGroup.productType = queueData.prdNo;
    salesOrderGroup.shippingPointId = queueData.shippointManage;
    salesOrderGroup.contactName = queueData.contactName;
    salesOrderGroup.contactTel = queueData.contactTel;
    salesOrderGroup.isPendingFlag = queueData.isPending;
    salesOrderGroup.pendingContactDate = queueData.pendingContactDate;
    salesOrderGroup.deliveryDate = queueData.isPending ? null : queueData.selectedDate;
    salesOrderGroup.timeType = queueData.selectedTimeType;
    salesOrderGroup.timeNo = queueData.selectedTimeNo;
    salesOrderGroup.salesOrderItems = queueData.queueDataItems.map((e) => mapToSalesOrderItem(salesCartReserve, queueData.queueDataItems, e)).toList();
    salesOrderGroup.vendorNo = queueData.queueDataItems
        .firstWhere(
          (element) => element.salesCartItem.shippingPointId == Shippoint.VENDOR,
          orElse: () => null,
        )
        ?.salesCartItem
        ?.deliverySite;
    salesOrderGroup.workNo = queueData.selectedWorker?.workNo;
    return salesOrderGroup;
  }

  SalesOrderItem mapToSalesOrderItem(SalesCartReserve salesCartReserve, List<QueueDataItem> queueDataItems, QueueDataItem queueDataItem) {
    SalesCartItem salesCartItem = queueDataItem.salesCartItem;
    SalesOrderItem salesOrderItem = SalesOrderItem();
    salesOrderItem.articleNo = salesCartItem.articleNo;
    salesOrderItem.seqNo = int.parse(salesCartItem.lineItem);
    salesOrderItem.description = salesCartItem.itemDescription;
    salesOrderItem.quantity = salesCartItem.qty;
    salesOrderItem.unit = salesCartItem.unit;
    salesOrderItem.unitPrice = salesCartItem.unitPrice;
    salesOrderItem.netItemAmount = salesCartItem.netItemAmt;
    salesOrderItem.salesCartItemOid = salesCartItem.salesCartItemOid;
    salesOrderItem.isMainProduct = salesCartItem.isInstallSameDay;
    salesOrderItem.itemUPC = salesCartItem.itemUpc;
    salesOrderItem.isSalesSet = salesCartItem.isSalesSet;
    salesOrderItem.isQtyRequired = salesCartItem.isQtyReq;
    salesOrderItem.batch = salesCartItem.batch;
    salesOrderItem.userIncentiveId = salesCartItem.incentiveId;
    salesOrderItem.userIncentiveName = salesCartItem.incentiveName;
    salesOrderItem.isSpecialDTS = salesCartItem.isSpecialDts;
    salesOrderItem.isSpecialOrder = salesCartItem.isSpecialOrder;
    salesOrderItem.remark = salesCartItem.remark;
    salesOrderItem.shippingPointId = salesCartItem.shippingPointId;
    salesOrderItem.deliverySite = salesCartItem.shippingPointId == Shippoint.VENDOR ? applicationBloc?.state?.appSession?.userProfile?.storeId : salesCartItem.deliverySite;
    if (salesCartItem.refSalesCartItemOid != null) {
      QueueDataItem pQueueDataItem = queueDataItems.firstWhere(
        (element) => element.salesCartItem.salesCartItemOid == salesCartItem.refSalesCartItemOid,
        orElse: () => null,
      );
      if (pQueueDataItem != null) salesOrderItem.refSeqNo = int.parse(pQueueDataItem.salesCartItem.lineItem);
    }
    salesOrderItem.isPremium = salesCartItem.isPremium;
    salesOrderItem.isMainInstall = salesCartItem.isMainInstall;
    salesOrderItem.isDeliveryFee = salesCartItem.isDeliveryFee;
    salesOrderItem.refClmId = queueDataItem.clmFlag;
    salesOrderItem.installCheckListId = salesCartItem.installCheckListId;

    return salesOrderItem;
  }

  SalesCartItem generateSalesCartItemDeliveryFee(ArticleDeliveryFee item, int allItemCount, {shippoint, deliverySite}) {
    SalesCartItem deliveryFeeItem = SalesCartItem();
    deliveryFeeItem.articleNo = item.artNo;
    deliveryFeeItem.itemDescription = item.artDesc;
    deliveryFeeItem.unitPrice = item.totalPrice;
    deliveryFeeItem.unit = item.unit;
    deliveryFeeItem.servNo = item.servNo;
    deliveryFeeItem.lineItem = ((allItemCount + 1) * 100).toString();
    deliveryFeeItem.shippingPointId = shippoint;
    deliveryFeeItem.deliverySite = deliverySite;

    deliveryFeeItem.itemUpc = item.itemUpc;
    deliveryFeeItem.mchId = item.mchId;
    deliveryFeeItem.isLotReq = item.isLotReq;
    deliveryFeeItem.isPriceReq = item.isPriceReq;
    deliveryFeeItem.isQtyReq = item.isQtyReq;

    deliveryFeeItem.salesCartItemOid = 0;
    deliveryFeeItem.qty = 1;
    deliveryFeeItem.qtyRemain = 1;
    deliveryFeeItem.isSpecialOrder = false;
    deliveryFeeItem.isSpecialDts = false;
    deliveryFeeItem.isMainPrd = false;
    deliveryFeeItem.isSalesSet = false;
    deliveryFeeItem.isInstallAfter = false;
    deliveryFeeItem.isPremium = false;
    deliveryFeeItem.isMainInstall = false;
    deliveryFeeItem.isInstallSameDay = QueueStyle.SAME_DAY == item.queueStyle && JobType.I == item.servNo;

    deliveryFeeItem.isDeliveryFee = true;
    deliveryFeeItem.netItemAmt = MathUtil.multiple(deliveryFeeItem.unitPrice, deliveryFeeItem.qty);
    return deliveryFeeItem;
  }
}
