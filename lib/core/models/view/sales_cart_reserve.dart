import 'package:flutter_store_catalog/core/models/bkoffc/get_delivery_fee_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/view/sales_cart_item_dto.dart';
import 'package:flutter_store_catalog/core/models/view/queue_data.dart';

class SalesCartReserve {
  String soMode;
  bool isReserveSingleTime;
  bool isSameDay;
  bool isUseSameAppointment;
  String shippoint;
  String deliveryMng;
  String jobType;
  String mainProductType;
  List<QueueData> queueDataList;
  List<SalesCartItemDto> salesCartItemList;
  Customer soldto;
  Customer shipto;
  Customer customerTemp;
  DateTime startDate;

  /// [pInstallSalesOrder] ระบุเป็น SalesOrder ติวที่ติดตั้งภายหลัง
  /// [pInstallSalesOrderGroup] ระบุเป็น SalesOrderGroup ติวที่ติดตั้งภายหลัง
  SalesOrder pInstallSalesOrder;
  SalesOrderGroup pInstallSalesOrderGroup;

  List<ArticleDeliveryFee> articleDeliveryFees;

  SalesCartReserve({
    this.soMode,
    this.isReserveSingleTime = false,
    this.isSameDay = false,
    this.isUseSameAppointment = false,
    this.shippoint,
    this.deliveryMng,
    this.jobType,
    this.mainProductType,
    this.queueDataList,
    this.salesCartItemList,
    this.soldto,
    this.shipto,
    this.customerTemp,
    this.articleDeliveryFees,
    this.startDate,
  });

  List<SalesCartItemDto> getItemNonFreeServiceList() {
    return salesCartItemList.where((element) => element != null && !(element.salesCartItem.isPremiumService ?? false)).toList();
  }

  List<SalesCartItemDto> getItemFreeServiceList() {
    return salesCartItemList.where((element) => element != null && (element.salesCartItem.isPremiumService ?? false)).toList();
  }
}
