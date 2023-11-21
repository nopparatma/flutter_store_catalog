import 'package:flutter_store_catalog/core/models/bkoffc/get_top_worker_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/view/basket_item.dart';
import 'package:flutter_store_catalog/core/models/view/queue_data.dart';

class QueueDataItemDto {
  DateTime selectedDate;
  String selectedTimeNo;
  String selectedTimeType;
  DateTime startDate;
  DateTime fastestDate;
  String fastestTime;
  DateTime readyDateInStock;
  String jobNo;
  String jobType;
  String patType;
  String prdNo;
  String queueStyle;
  String shippointManage;
  TopWorker selectedWorker;
  String contactName;
  String contactTel;
  String spacialOrderText;
  SalesCartItem salesCartItem;
  List<QueueDataItemDto> queueItemInstallServices;
  BasketItem basketItem;
  Map<DateTime, QueueDateMap> queueDateMap;
  bool isPending;

  QueueDataItemDto({
    this.selectedDate,
    this.selectedTimeNo,
    this.selectedTimeType,
    this.startDate,
    this.fastestDate,
    this.fastestTime,
    this.readyDateInStock,
    this.jobNo,
    this.jobType,
    this.patType,
    this.prdNo,
    this.queueStyle,
    this.shippointManage,
    this.selectedWorker,
    this.contactName,
    this.contactTel,
    this.spacialOrderText,
    this.salesCartItem,
    salesCartItemInstallServices,
    this.basketItem,
    this.queueDateMap,
    this.isPending = false,
  }) : this.queueItemInstallServices = salesCartItemInstallServices ?? [];
}
