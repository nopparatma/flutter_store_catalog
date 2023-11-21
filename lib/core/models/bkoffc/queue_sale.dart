import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class QueueSale {
  String confirmTypeId;
  String contactName;
  String contactTel;
  DateTime deliveryDate;
  String deliveryManagerId;
  String deliveryQueueNo;
  DateTime installDate;
  String installDeliverySite;
  String installMainProductTypeId;
  String installQueueNo;
  String installRemark;
  String installShippingPointId;
  String installShippingPointNo;
  String installTimeNo;
  String installTimeType;
  bool isPendingFlag;
  String jobNo;
  String jobNoIns;
  String jobTypeId;
  String jobTypeInsId;
  String mainProductTypeId;
  String posId;
  List<QueueSalesItem> queueSalesItems;
  String remark;
  String storeId;
  String ticketNo;
  String timeNo;
  String timeType;
  String transDate;
  String vendorNo;
  String workNo;

  QueueSale({this.confirmTypeId, this.contactName, this.contactTel, this.deliveryDate, this.deliveryManagerId, this.deliveryQueueNo, this.installDate, this.installDeliverySite, this.installMainProductTypeId, this.installQueueNo, this.installRemark, this.installShippingPointId, this.installShippingPointNo, this.installTimeNo, this.installTimeType, this.isPendingFlag = false, this.jobNo, this.jobNoIns, this.jobTypeId, this.jobTypeInsId, this.mainProductTypeId, this.posId, this.queueSalesItems, this.remark, this.storeId, this.ticketNo, this.timeNo, this.timeType, this.transDate, this.vendorNo, this.workNo});

  QueueSale.fromJson(Map<String, dynamic> json) {
    confirmTypeId = json['confirmTypeId'];
    contactName = json['contactName'];
    contactTel = json['contactTel'];
    deliveryDate = DateTimeUtil.toDateTime(json['deliveryDate']);
    deliveryManagerId = json['deliveryManagerId'];
    deliveryQueueNo = json['deliveryQueueNo'];
    installDate = DateTimeUtil.toDateTime(json['installDate']);
    installDeliverySite = json['installDeliverySite'];
    installMainProductTypeId = json['installMainProductTypeId'];
    installQueueNo = json['installQueueNo'];
    installRemark = json['installRemark'];
    installShippingPointId = json['installShippingPointId'];
    installShippingPointNo = json['installShippingPointNo'];
    installTimeNo = json['installTimeNo'];
    installTimeType = json['installTimeType'];
    isPendingFlag = json['isPendingFlag'];
    jobNo = json['jobNo'];
    jobNoIns = json['jobNoIns'];
    jobTypeId = json['jobTypeId'];
    jobTypeInsId = json['jobTypeInsId'];
    mainProductTypeId = json['mainProductTypeId'];
    posId = json['posId'];
    if (json['queueSalesItemBos'] != null) {
      queueSalesItems = new List<QueueSalesItem>();
      json['queueSalesItemBos'].forEach((v) {
        queueSalesItems.add(new QueueSalesItem.fromJson(v));
      });
    }
    remark = json['remark'];
    storeId = json['storeId'];
    ticketNo = json['ticketNo'];
    timeNo = json['timeNo'];
    timeType = json['timeType'];
    transDate = json['transDate'];
    vendorNo = json['vendorNo'];
    workNo = json['workNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['confirmTypeId'] = this.confirmTypeId;
    data['contactName'] = this.contactName;
    data['contactTel'] = this.contactTel;
    data['deliveryDate'] = this.deliveryDate?.toIso8601String();
    data['deliveryManagerId'] = this.deliveryManagerId;
    data['deliveryQueueNo'] = this.deliveryQueueNo;
    data['installDate'] = this.installDate?.toIso8601String();
    data['installDeliverySite'] = this.installDeliverySite;
    data['installMainProductTypeId'] = this.installMainProductTypeId;
    data['installQueueNo'] = this.installQueueNo;
    data['installRemark'] = this.installRemark;
    data['installShippingPointId'] = this.installShippingPointId;
    data['installShippingPointNo'] = this.installShippingPointNo;
    data['installTimeNo'] = this.installTimeNo;
    data['installTimeType'] = this.installTimeType;
    data['isPendingFlag'] = this.isPendingFlag;
    data['jobNo'] = this.jobNo;
    data['jobNoIns'] = this.jobNoIns;
    data['jobTypeId'] = this.jobTypeId;
    data['jobTypeInsId'] = this.jobTypeInsId;
    data['mainProductTypeId'] = this.mainProductTypeId;
    data['posId'] = this.posId;
    if (this.queueSalesItems != null) {
      data['queueSalesItemBos'] = this.queueSalesItems.map((v) => v.toJson()).toList();
    }
    data['remark'] = this.remark;
    data['storeId'] = this.storeId;
    data['ticketNo'] = this.ticketNo;
    data['timeNo'] = this.timeNo;
    data['timeType'] = this.timeType;
    data['transDate'] = this.transDate;
    data['vendorNo'] = this.vendorNo;
    data['workNo'] = this.workNo;
    return data;
  }
}

class QueueSalesItem {
  String articleNo;
  List<ArticleSet> articleSets;
  String deliverySite;
  String description;
  String installPLineItem;
  bool isMainInstall;
  bool isMainProduct;
  bool isPremium;
  bool isSalesSet;
  String lineItem;
  num netItemAmount;
  num objectId;
  String premiumPLineItem;
  num quantity;
  String shippingPointId;
  String unit;
  num unitPrice;

  QueueSalesItem({this.articleNo, this.articleSets, this.deliverySite, this.description, this.installPLineItem, this.isMainInstall, this.isMainProduct = false, this.isPremium, this.isSalesSet = false, this.lineItem, this.netItemAmount, this.objectId, this.premiumPLineItem, this.quantity, this.shippingPointId, this.unit, this.unitPrice});

  QueueSalesItem.fromJson(Map<String, dynamic> json) {
    articleNo = json['articleNo'];
    if (json['articleSets'] != null) {
      articleSets = new List<ArticleSet>();
      json['articleSets'].forEach((v) {
        articleSets.add(new ArticleSet.fromJson(v));
      });
    }
    deliverySite = json['deliverySite'];
    description = json['description'];
    installPLineItem = json['installPLineItem'];
    isMainInstall = json['isMainInstall'];
    isMainProduct = json['isMainProduct'];
    isPremium = json['isPremium'];
    isSalesSet = json['isSalesSet'];
    lineItem = json['lineItem'];
    netItemAmount = json['netItemAmount'];
    objectId = json['objectId'];
    premiumPLineItem = json['premiumPLineItem'];
    quantity = json['quantity'];
    shippingPointId = json['shippingPointId'];
    unit = json['unit'];
    unitPrice = json['unitPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleNo'] = this.articleNo;
    if (this.articleSets != null) {
      data['articleSets'] = this.articleSets.map((v) => v.toJson()).toList();
    }
    data['deliverySite'] = this.deliverySite;
    data['description'] = this.description;
    data['installPLineItem'] = this.installPLineItem;
    data['isMainInstall'] = this.isMainInstall;
    data['isMainProduct'] = this.isMainProduct;
    data['isPremium'] = this.isPremium;
    data['isSalesSet'] = this.isSalesSet;
    data['lineItem'] = this.lineItem;
    data['netItemAmount'] = this.netItemAmount;
    data['objectId'] = this.objectId;
    data['premiumPLineItem'] = this.premiumPLineItem;
    data['quantity'] = this.quantity;
    data['shippingPointId'] = this.shippingPointId;
    data['unit'] = this.unit;
    data['unitPrice'] = this.unitPrice;
    return data;
  }
}
