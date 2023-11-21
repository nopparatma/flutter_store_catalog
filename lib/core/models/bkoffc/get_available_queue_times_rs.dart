import 'package:equatable/equatable.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

import 'base_bkoffc_webapi_rs.dart';

class GetAvailableQueueTimesRs extends BaseBackOfficeWebApiRs {
  List<QueueData> queueDatas;

  GetAvailableQueueTimesRs({this.queueDatas});

  GetAvailableQueueTimesRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['queueDatas'] != null) {
      queueDatas = new List<QueueData>();
      json['queueDatas'].forEach((v) {
        queueDatas.add(new QueueData.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.queueDatas != null) {
      data['queueDatas'] = this.queueDatas.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class QueueData {
  List<AvailableQueueTimes> availableQueueTimes;
  String dateIntoStock;
  bool isCanReserveQueue;
  bool isOutOfStock;
  bool isSameDay;
  String jobNo;
  String jobType;
  String patType;
  String prdNo;
  List<QueueDataItem> queueDataItems;
  String queueStyle;
  String reserveMessage;
  String shippointManage;
  String vendorGroupNo;

  QueueData({this.availableQueueTimes, this.dateIntoStock, this.isCanReserveQueue, this.isOutOfStock, this.isSameDay, this.jobNo, this.jobType, this.patType, this.prdNo, this.queueDataItems, this.queueStyle, this.reserveMessage, this.shippointManage, this.vendorGroupNo});

  QueueData.fromJson(Map<String, dynamic> json) {
    if (json['availableQueueTimes'] != null) {
      availableQueueTimes = new List<AvailableQueueTimes>();
      json['availableQueueTimes'].forEach((v) {
        availableQueueTimes.add(new AvailableQueueTimes.fromJson(v));
      });
    }
    dateIntoStock = json['dateIntoStock'];
    isCanReserveQueue = json['isCanReserveQueue'];
    isOutOfStock = json['isOutOfStock'];
    isSameDay = json['isSameDay'];
    jobNo = json['jobNo'];
    jobType = json['jobType'];
    patType = json['patType'];
    prdNo = json['prdNo'];
    if (json['queueDataItems'] != null) {
      queueDataItems = new List<QueueDataItem>();
      json['queueDataItems'].forEach((v) {
        queueDataItems.add(new QueueDataItem.fromJson(v));
      });
    }
    queueStyle = json['queueStyle'];
    reserveMessage = json['reserveMessage'];
    shippointManage = json['shippointManage'];
    vendorGroupNo = json['vendorGroupNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.availableQueueTimes != null) {
      data['availableQueueTimes'] = this.availableQueueTimes.map((v) => v.toJson()).toList();
    }
    data['dateIntoStock'] = this.dateIntoStock;
    data['isCanReserveQueue'] = this.isCanReserveQueue;
    data['isOutOfStock'] = this.isOutOfStock;
    data['isSameDay'] = this.isSameDay;
    data['jobNo'] = this.jobNo;
    data['jobType'] = this.jobType;
    data['patType'] = this.patType;
    data['prdNo'] = this.prdNo;
    if (this.queueDataItems != null) {
      data['queueDataItems'] = this.queueDataItems.map((v) => v.toJson()).toList();
    }
    data['queueStyle'] = this.queueStyle;
    data['reserveMessage'] = this.reserveMessage;
    data['shippointManage'] = this.shippointManage;
    data['vendorGroupNo'] = this.vendorGroupNo;
    return data;
  }
}

class AvailableQueueTimes extends Equatable {
  DateTime availableDate;
  num capaQty;
  String timeName;
  String timeNo;
  String workerAvailable;

  AvailableQueueTimes({this.availableDate, this.capaQty, this.timeName, this.timeNo, this.workerAvailable});

  AvailableQueueTimes.fromJson(Map<String, dynamic> json) {
    availableDate = DateTimeUtil.toDateTime(json['availableDate']);
    capaQty = json['capaQty'];
    timeName = json['timeName'];
    timeNo = json['timeNo'];
    workerAvailable = json['workerAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['availableDate'] = this.availableDate?.toIso8601String();
    data['capaQty'] = this.capaQty;
    data['timeName'] = this.timeName;
    data['timeNo'] = this.timeNo;
    data['workerAvailable'] = this.workerAvailable;
    return data;
  }

  @override
  List<Object> get props => [availableDate, timeNo];
}

class QueueDataItem {
  String artNo;
  String deliverySite;
  String lineItem;
  String shippoint;
  num stockQty;

  QueueDataItem({this.artNo, this.deliverySite, this.lineItem, this.shippoint, this.stockQty});

  QueueDataItem.fromJson(Map<String, dynamic> json) {
    artNo = json['artNo'];
    deliverySite = json['deliverySite'];
    lineItem = json['lineItem'];
    shippoint = json['shippoint'];
    stockQty = json['stockQty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artNo'] = this.artNo;
    data['deliverySite'] = this.deliverySite;
    data['lineItem'] = this.lineItem;
    data['shippoint'] = this.shippoint;
    data['stockQty'] = this.stockQty;
    return data;
  }
}
