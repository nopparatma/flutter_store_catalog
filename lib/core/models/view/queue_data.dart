import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_top_worker_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/inquiry_stock_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_available_queue_times_rs.dart' as GetQueueRs;
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';

class QueueData {
  /// ส่วนยืนยันนัดหมาย
  /// [appointmentType] : วิธียืนยันนัดหมาย
  /// [contactName] : ชื่อผู้รับ
  /// [contactTel] : เบอร์โทร
  /// [spacialOrderText] : คำสั่งพิเศษ
  String appointmentType;
  String contactName;
  String contactTel;
  String spacialOrderText;

  /// วันที่เริ่มต้นที่สามารถจองได้
  /// ปกติจะเป็นวันปัจจุบัน
  /// กรณีจองคิดติดตั้งภายหลังจะเป็น วันที่จองคิว [SalesOrderGroup.deliveryDate] ของคิวจัดส่ง
  DateTime startDate;

  DateTime selectedDate;
  String selectedTimeNo;
  String selectedTimeType;

  /// Flag จองคิวไม่ระบุวัน
  bool isPending;
  String pendingContactDate;

  /// Flag คิวค่าขนส่ง ภายในจะมีแต่ article ค่าขนส่ง
  bool isQueueDeliveryFee;

  List<String> articleInstDiffTeam;

  /// ข้อมูลวันที่ตรวจสอบคิว
  Map<DateTime, QueueDateMap> queueDateMap;

  /// เก็บ [QueueData] ทั้งหมด กรณีจองคิววันเวลาเดียวกัน
  List<QueueData> queueReserveSingleTimeGroup;

  /// การจองคิวระบุช่าง
  /// [isSpecifyWorker] : Flag ให้สามารถระบุช่างได้
  /// [topWorkerList] : รายการช่างที่เลือกได้
  /// [selectedWorker] : ช่างที่เลือก
  bool isSpecifyWorker;
  List<TopWorker> topWorkerList;
  TopWorker selectedWorker;

  List<QueueDataItem> queueDataItems;

  DateTime fastestDate;
  String fastestTimeNo;

  /// Field จาก [GetQueueRs.QueueData]
  DateTime dateIntoStock;
  bool isCanReserveQueue;
  bool isOutOfStock;
  bool isSameDay;
  String jobNo;
  String jobType;
  String patType;
  String prdNo;
  String queueStyle;
  String reserveMessage;
  String shippointManage;
  String vendorGroupNo;

  bool isFreeServiceQueue() {
    return queueDataItems.every((element) => element.salesCartItem.isPremiumService);
  }

  QueueData({
    this.contactName,
    this.contactTel,
    this.spacialOrderText,
    this.appointmentType,
    this.startDate,
    this.selectedDate,
    this.selectedTimeNo,
    this.selectedTimeType,
    this.isPending = false,
    this.pendingContactDate,
    this.isQueueDeliveryFee = false,
    this.articleInstDiffTeam,
    this.queueDateMap,
    this.queueReserveSingleTimeGroup,
    this.isSpecifyWorker = false,
    this.topWorkerList,
    this.selectedWorker,
    this.dateIntoStock,
    this.isCanReserveQueue,
    this.isOutOfStock,
    this.isSameDay,
    this.jobNo,
    this.jobType,
    this.patType,
    this.prdNo,
    this.queueStyle,
    this.reserveMessage,
    this.shippointManage,
    this.vendorGroupNo,
    this.queueDataItems,
    this.fastestDate,
    this.fastestTimeNo,
  });
}

class QueueDateMap {
  /// [status] สำหรับแสดงปฏิทิน ประกอบด้วย
  /// * [DateStatus.Available] : วันว่าง แสดงสีเขียว
  /// * [DateStatus.Unavailable] : วันไม่ว่าง แสดงสีแดง
  /// * [DateStatus.OutOfRange] : วันที่นอกเหนือขอบเขตการจอง แสดงสีเทา

  DateTime date;
  DateStatus status;
  List<QueueTime> queueTime;

  QueueDateMap({this.date, this.status, this.queueTime});
}

class QueueTime {
  /// [workerAvailable] สถานะของช่างที่ [QueueDateMap.date] และ [QueueTime.timeNo]
  /// * [WorkerStatus.AVAILABLE] : ช่างว่าง
  /// * [WorkerStatus.NOT_AVAILABLE] : ช่างไม่ว่าง
  /// * [WorkerStatus.OFF] : วันหยุดช่าง

  num capaQty;
  String timeName;
  String timeNo;
  String workerAvailable;

  QueueTime({this.capaQty, this.timeName, this.timeNo, this.workerAvailable});
}

class QueueDataItem {
  SalesCartItem salesCartItem;
  List<SapBatch> sapBatchs;
  bool isDisableSpecialOrder;
  bool isDisableSpecialDts;
  bool isAutoCheckSpecialOrder;
  String clmFlag;

  QueueDataItem({
    this.salesCartItem,
    this.sapBatchs,
    this.isDisableSpecialOrder = false,
    this.isDisableSpecialDts = false,
    this.isAutoCheckSpecialOrder = false,
    this.clmFlag,
  });
}

QueueData mapToQueueData(DateTime startDate, int inquiryDay, List<SalesCartItem> salesCartItems, GetQueueRs.QueueData obj) {
  return QueueData(
    jobNo: obj.jobNo,
    jobType: obj.jobType,
    patType: obj.patType,
    prdNo: obj.prdNo,
    dateIntoStock: StringUtil.isNullOrEmpty(obj.dateIntoStock) ? null : DateTimeUtil.toDateTime(obj.dateIntoStock),
    isCanReserveQueue: obj.isCanReserveQueue,
    isOutOfStock: obj.isOutOfStock,
    isSameDay: obj.isSameDay ?? false,
    queueStyle: obj.queueStyle,
    reserveMessage: obj.reserveMessage,
    shippointManage: obj.shippointManage,
    vendorGroupNo: obj.vendorGroupNo,
    queueDataItems: mapToQueueDataItems(salesCartItems, obj),
    queueDateMap: mapToQueueDateMap(startDate, inquiryDay, obj.availableQueueTimes),
    startDate: startDate,
  );
}

List<QueueDataItem> mapToQueueDataItems(List<SalesCartItem> salesCartItems, GetQueueRs.QueueData queueData) {
  List<GetQueueRs.QueueDataItem> dsQueueDataItems = queueData.queueDataItems.where((element) => int.parse(element.lineItem) % 100 == 0).toList();
  List<QueueDataItem> queueDataItems = dsQueueDataItems.map((e) => mapToQueueDataItem(salesCartItems, queueData, e)).toList();
  queueDataItems.sort((a, b) => a.salesCartItem.lineItem.compareTo(b.salesCartItem.lineItem));
  return queueDataItems;
}

QueueDataItem mapToQueueDataItem(List<SalesCartItem> salesCartItems, GetQueueRs.QueueData queueData, GetQueueRs.QueueDataItem obj) {
  SalesCartItem salesCartItem = salesCartItems.firstWhere((element) => element.lineItem == obj.lineItem);
  salesCartItem.deliverySite = obj.deliverySite;
  salesCartItem.shippingPointId = obj.shippoint;
  salesCartItem.isSameDay = queueData.isSameDay;
  salesCartItem.stockQty = obj.stockQty;

  return QueueDataItem(salesCartItem: salesCartItem);
}

Map<DateTime, QueueDateMap> mapToQueueDateMap(DateTime startDate, int inquiryDay, List<GetQueueRs.AvailableQueueTimes> availableQueueTimes) {
  Map map = Map<DateTime, QueueDateMap>();
  for (int i = 0; i < inquiryDay; i++) {
    DateTime date = startDate.add(Duration(days: i));
    var queueTimes = availableQueueTimes.where((element) => element.availableDate == date);
    if (queueTimes.isEmpty) {
      map[date] = QueueDateMap(date: date, status: DateStatus.Unavailable);
    } else {
      DateStatus dateStatus;
      if (queueTimes.every((element) => element.workerAvailable == WorkerStatus.NOT_AVAILABLE || element.capaQty == 0))
        dateStatus = DateStatus.Unavailable;
      else if (queueTimes.every((element) => element.workerAvailable == WorkerStatus.OFF)) {
        dateStatus = DateStatus.OutOfRange;
      } else {
        dateStatus = DateStatus.Available;
      }
      map[date] = QueueDateMap(
        date: date,
        status: dateStatus,
        queueTime: queueTimes
            .where((element) => ![WorkerStatus.NOT_AVAILABLE, WorkerStatus.OFF].contains(element.workerAvailable) && element.capaQty > 0)
            .map(
              (e) => QueueTime(
                timeNo: e.timeNo,
                timeName: e.timeName,
                capaQty: e.capaQty,
                workerAvailable: e.workerAvailable,
              ),
            )
            .toList(),
      );
    }
  }
  return map;
}

Map<DateTime, QueueDateMap> addToQueueDataMap(Map<DateTime, QueueDateMap> queueDateMap, DateTime startDate, int inquiryDay, List<GetQueueRs.AvailableQueueTimes> availableQueueTimes) {
  for (int i = 0; i < inquiryDay; i++) {
    DateTime day = startDate.add(Duration(days: i));
    if (queueDateMap.containsKey(day)) continue;
    var queueTimes = availableQueueTimes.where((element) => element.availableDate == day);
    if (queueTimes.isEmpty) {
      queueDateMap[day] = QueueDateMap(date: day, status: DateStatus.Unavailable);
    } else {
      DateStatus dateStatus;
      if (queueTimes.every((element) => element.workerAvailable == WorkerStatus.NOT_AVAILABLE || element.capaQty == 0))
        dateStatus = DateStatus.Unavailable;
      else if (queueTimes.every((element) => element.workerAvailable == WorkerStatus.OFF)) {
        dateStatus = DateStatus.OutOfRange;
      } else {
        dateStatus = DateStatus.Available;
      }
      queueDateMap[day] = QueueDateMap(
        date: day,
        status: dateStatus,
        queueTime: queueTimes
            .where((element) => ![WorkerStatus.NOT_AVAILABLE, WorkerStatus.OFF].contains(element.workerAvailable) && element.capaQty > 0)
            .map(
              (e) => QueueTime(
                timeNo: e.timeNo,
                timeName: e.timeName,
                capaQty: e.capaQty,
                workerAvailable: e.workerAvailable,
              ),
            )
            .toList(),
      );
    }
  }
  return queueDateMap;
}

List<QueueData> groupQueueReserveSingleTime(DateTime startDate, int inquiryDay, List<QueueData> queueDataList, List<List<GetQueueRs.AvailableQueueTimes>> availableQueueTimesList) {
  List<QueueDataItem> allQueueDataItem = [];
  for (var queue in queueDataList) {
    allQueueDataItem.addAll(queue.queueDataItems);
  }

  QueueData groupQueueData = QueueData(
    queueReserveSingleTimeGroup: queueDataList,
    queueDateMap: mapToSingleTimeQueueDateMap(startDate, inquiryDay, availableQueueTimesList),
    queueDataItems: allQueueDataItem,
    isSameDay: false,
    queueStyle: QueueStyle.NORMAL,
    startDate: startDate,
    isOutOfStock: queueDataList.any((element) => element.isOutOfStock ?? false),
  );

  if (groupQueueData.isOutOfStock) {
    List<DateTime> lstDateInStock = queueDataList.map((e) => e.dateIntoStock ?? DateTime.now()).toList();
    groupQueueData.dateIntoStock = (lstDateInStock..sort((a, b) => b.compareTo(a))).first;
  }
  return [groupQueueData];
}

Map<DateTime, QueueDateMap> mapToSingleTimeQueueDateMap(DateTime startDate, int inquiryDay, List<List<GetQueueRs.AvailableQueueTimes>> availableQueueTimesList) {
  return mapToQueueDateMap(startDate, inquiryDay, mergeAvailableQueueTimes(availableQueueTimesList));
}

List<GetQueueRs.AvailableQueueTimes> mergeAvailableQueueTimes(List<List<GetQueueRs.AvailableQueueTimes>> availableQueueTimesList) {
  availableQueueTimesList = availableQueueTimesList.map((e) => e.where((element) => element.capaQty > 0 && ![WorkerStatus.OFF, WorkerStatus.NOT_AVAILABLE].contains(element.workerAvailable)).toList()).toList();
  Set<GetQueueRs.AvailableQueueTimes> availableQueueTimes = availableQueueTimesList.first.toSet();
  availableQueueTimesList.forEach((element) {
    availableQueueTimes.retainAll(element);
  });

  return availableQueueTimes.toList();
}

List<QueueData> splitQueueFreeService(List<QueueData> listQueueData) {
  List<QueueData> newQueueData = <QueueData>[];

  ///หาคิวที่มี Artc PremiumService และมีมากกว่า 1 Artc
  ///แยก Artc PremiumService ออกมาเป็นคิวใหม่
  listQueueData.forEach((queue) {
    if (queue.queueDataItems.every((element) => !element.salesCartItem.isPremiumService) || queue.queueDataItems.length == 1) {
      newQueueData.add(queue);
      return;
    }
    queue.queueDataItems.forEach((item) {
      newQueueData.add(mapOneQueueOneItemData(queue, item));
    });
  });
  return newQueueData;
}

QueueData mapOneQueueOneItemData(QueueData queueData, QueueDataItem queueDataItem) {
  return QueueData(
    isPending: queueData.isPending,
    appointmentType: queueData.appointmentType,
    articleInstDiffTeam: queueData.articleInstDiffTeam,
    contactName: queueData.contactName,
    contactTel: queueData.contactTel,
    dateIntoStock: queueData.dateIntoStock,
    fastestDate: queueData.fastestDate,
    fastestTimeNo: queueData.fastestTimeNo,
    isCanReserveQueue: queueData.isCanReserveQueue,
    isOutOfStock: queueData.isOutOfStock,
    isQueueDeliveryFee: queueData.isQueueDeliveryFee,
    isSameDay: queueData.isSameDay,
    isSpecifyWorker: queueData.isSpecifyWorker,
    jobNo: queueData.jobNo,
    jobType: queueData.jobType,
    patType: queueData.patType,
    pendingContactDate: queueData.pendingContactDate,
    prdNo: queueData.prdNo,
    queueDateMap: queueData.queueDateMap,
    queueReserveSingleTimeGroup: queueData.queueReserveSingleTimeGroup,
    queueStyle: queueData.queueStyle,
    reserveMessage: queueData.reserveMessage,
    selectedDate: queueData.selectedDate,
    selectedTimeNo: queueData.selectedTimeNo,
    selectedTimeType: queueData.selectedTimeType,
    selectedWorker: queueData.selectedWorker,
    shippointManage: queueData.shippointManage,
    spacialOrderText: queueData.spacialOrderText,
    startDate: queueData.startDate,
    topWorkerList: queueData.topWorkerList,
    vendorGroupNo: queueData.vendorGroupNo,
    queueDataItems: [queueDataItem],
  );
}
