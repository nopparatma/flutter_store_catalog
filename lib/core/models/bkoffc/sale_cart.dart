import 'package:flutter_store_catalog/core/utilities/math_util.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';

class SalesCart {
  String building;
  String cardForBurnpoint;
  CollectSalesOrder collectSalesOrder;
  DateTime createDateTime;
  String createUser;
  Customer customer;
  String district;
  String firstName;
  bool flagHirepurchase;
  String floorNumber;
  String lastName;
  DateTime lastUpdDttm;
  String lastUpdateUser;
  String mapLat;
  String mapLong;
  String moo;
  num netTranAmt;
  String number;
  String province;
  String routeDetails;
  String rowMode;
  num rowVersion;
  List<SalesCartItem> salesCartItems;
  num salesCartOid;
  String salesChannel;
  String salesChannelRef1;
  String salesChannelRef2;
  String salesOrderNo;
  num salesOrderOid;
  String salesOrderStsId;
  List<SalesOrder> salesOrders;
  SimulatePaymentBo simulatePaymentBo;
  String soi;
  Store store;
  String street;
  String subDistrict;
  String telephoneNo;
  num totalDscntAmt;
  num totalTranAmt;
  DateTime transactionDate;
  DateTime trnDate;
  String unit;
  String village;
  String zipCode;
  String paymentType;

  SalesCart({
    this.building,
    this.cardForBurnpoint,
    this.collectSalesOrder,
    this.createDateTime,
    this.createUser,
    this.customer,
    this.district,
    this.firstName,
    this.flagHirepurchase,
    this.floorNumber,
    this.lastName,
    this.lastUpdDttm,
    this.lastUpdateUser,
    this.mapLat,
    this.mapLong,
    this.moo,
    this.netTranAmt,
    this.number,
    this.province,
    this.routeDetails,
    this.rowMode,
    this.rowVersion,
    this.salesCartItems,
    this.salesCartOid = 0,
    this.salesChannel,
    this.salesChannelRef1,
    this.salesChannelRef2,
    this.salesOrderNo,
    this.salesOrderOid,
    this.salesOrderStsId,
    this.salesOrders,
    this.simulatePaymentBo,
    this.soi,
    this.store,
    this.street,
    this.subDistrict,
    this.telephoneNo,
    this.totalDscntAmt,
    this.totalTranAmt,
    this.transactionDate,
    this.trnDate,
    this.unit,
    this.village,
    this.zipCode,
    this.paymentType,
  });

  num getTotalPrice() => this.salesCartItems?.fold(0, (previousValue, element) => MathUtil.add(previousValue, (element.netItemAmt ?? 0))) ?? 0;

  num getTotalDiscount() => MathUtil.add(
        this.simulatePaymentBo?.simPayDiscountBos?.fold(0, (previousValue, element) => MathUtil.add(previousValue, (element.discountAmount ?? 0))) ?? 0,
        this.simulatePaymentBo?.simPayPromoitonBos?.fold(0, (previousValue, element) => MathUtil.add(previousValue, (element.discountAmount ?? 0))) ?? 0,
      );

  num getNetTranAmount() => MathUtil.add(this.getTotalPrice(), this.getTotalDiscount());

  SalesCart.fromJson(Map<String, dynamic> json) {
    building = json['building'];
    cardForBurnpoint = json['cardForBurnpoint'];
    collectSalesOrder = json['collectSalesOrder'] != null ? new CollectSalesOrder.fromJson(json['collectSalesOrder']) : null;
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUser = json['createUser'];
    customer = json['customer'] != null ? new Customer.fromJson(json['customer']) : null;
    district = json['district'];
    firstName = json['firstName'];
    flagHirepurchase = json['flagHirepurchase'] ?? false;
    floorNumber = json['floorNumber'];
    lastName = json['lastName'];
    lastUpdDttm = DateTimeUtil.toDateTime(json['lastUpdDttm']);
    lastUpdateUser = json['lastUpdateUser'];
    mapLat = json['mapLat'];
    mapLong = json['mapLong'];
    moo = json['moo'];
    netTranAmt = json['netTranAmt'];
    number = json['number'];
    province = json['province'];
    routeDetails = json['routeDetails'];
    rowMode = json['rowMode'];
    rowVersion = json['rowVersion'];
    if (json['salesCartItems'] != null) {
      salesCartItems = new List<SalesCartItem>();
      json['salesCartItems'].forEach((v) {
        salesCartItems.add(new SalesCartItem.fromJson(v));
      });
    }
    salesCartOid = json['salesCartOid'];
    salesChannel = json['salesChannel'];
    salesChannelRef1 = json['salesChannelRef1'];
    salesChannelRef2 = json['salesChannelRef2'];
    salesOrderNo = json['salesOrderNo'];
    salesOrderOid = json['salesOrderOid'];
    salesOrderStsId = json['salesOrderStsId'];
    if (json['salesOrders'] != null) {
      salesOrders = new List<SalesOrder>();
      json['salesOrders'].forEach((v) {
        salesOrders.add(new SalesOrder.fromJson(v));
      });
    }
    simulatePaymentBo = json['simulatePaymentBo'] != null ? new SimulatePaymentBo.fromJson(json['simulatePaymentBo']) : null;
    soi = json['soi'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    street = json['street'];
    subDistrict = json['subDistrict'];
    telephoneNo = json['telephoneNo'];
    totalDscntAmt = json['totalDscntAmt'];
    totalTranAmt = json['totalTranAmt'];
    transactionDate = DateTimeUtil.toDateTime(json['transactionDate']);
    trnDate = DateTimeUtil.toDateTime(json['trnDate']);
    unit = json['unit'];
    village = json['village'];
    zipCode = json['zipCode'];
    paymentType = json['paymentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['building'] = this.building;
    data['cardForBurnpoint'] = this.cardForBurnpoint;
    if (this.collectSalesOrder != null) {
      data['collectSalesOrder'] = this.collectSalesOrder.toJson();
    }
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUser'] = this.createUser;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    data['district'] = this.district;
    data['firstName'] = this.firstName;
    data['flagHirepurchase'] = this.flagHirepurchase;
    data['floorNumber'] = this.floorNumber;
    data['lastName'] = this.lastName;
    data['lastUpdDttm'] = this.lastUpdDttm?.toIso8601String();
    data['lastUpdateUser'] = this.lastUpdateUser;
    data['mapLat'] = this.mapLat;
    data['mapLong'] = this.mapLong;
    data['moo'] = this.moo;
    data['netTranAmt'] = this.netTranAmt;
    data['number'] = this.number;
    data['province'] = this.province;
    data['routeDetails'] = this.routeDetails;
    data['rowMode'] = this.rowMode;
    data['rowVersion'] = this.rowVersion;
    if (this.salesCartItems != null) {
      data['salesCartItems'] = this.salesCartItems.map((v) => v.toJson()).toList();
    }
    data['salesCartOid'] = this.salesCartOid;
    data['salesChannel'] = this.salesChannel;
    data['salesChannelRef1'] = this.salesChannelRef1;
    data['salesChannelRef2'] = this.salesChannelRef2;
    data['salesOrderNo'] = this.salesOrderNo;
    data['salesOrderOid'] = this.salesOrderOid;
    data['salesOrderStsId'] = this.salesOrderStsId;
    if (this.salesOrders != null) {
      data['salesOrders'] = this.salesOrders.map((v) => v.toJson()).toList();
    }
    if (this.simulatePaymentBo != null) {
      data['simulatePaymentBo'] = this.simulatePaymentBo.toJson();
    }
    data['soi'] = this.soi;
    if (this.store != null) {
      data['store'] = this.store.toJson();
    }
    data['street'] = this.street;
    data['subDistrict'] = this.subDistrict;
    data['telephoneNo'] = this.telephoneNo;
    data['totalDscntAmt'] = this.totalDscntAmt;
    data['totalTranAmt'] = this.totalTranAmt;
    data['transactionDate'] = this.transactionDate?.toIso8601String();
    data['trnDate'] = this.trnDate?.toIso8601String();
    data['unit'] = this.unit;
    data['village'] = this.village;
    data['zipCode'] = this.zipCode;
    data['paymentType'] = this.paymentType;
    return data;
  }
}

class CollectSalesOrder {
  Customer billToCustomer;
  String collSalesOrderNo;
  num collectSalesOrderOid;
  String contactName;
  String contactTel;
  DateTime createDttm;
  String createUserId;
  String createUserNm;
  bool isCalPro;
  bool isHirePurchasePayment;
  bool isNotReject;
  DateTime lastUpdDttm;
  String lastUpdUser;
  num numItem;
  String qtNo;
  String salesChannel;
  String salesOrderStsId;
  String salesOrderTypeId;
  List<SalesOrder> salesOrders;
  String sapBillingNo;
  String sapSoNo;
  Customer soldToCustomer;
  num storeId;
  DateTime trnDt;
  String versionId;

  CollectSalesOrder({this.billToCustomer, this.collSalesOrderNo, this.collectSalesOrderOid, this.contactName, this.contactTel, this.createDttm, this.createUserId, this.createUserNm, this.isCalPro, this.isHirePurchasePayment, this.isNotReject, this.lastUpdDttm, this.lastUpdUser, this.numItem, this.qtNo, this.salesChannel, this.salesOrderStsId, this.salesOrderTypeId, this.salesOrders, this.sapBillingNo, this.sapSoNo, this.soldToCustomer, this.storeId, this.trnDt, this.versionId});

  CollectSalesOrder.fromJson(Map<String, dynamic> json) {
    billToCustomer = json['billToCustomer'] != null ? new Customer.fromJson(json['billToCustomer']) : null;
    collSalesOrderNo = json['collSalesOrderNo'];
    collectSalesOrderOid = json['collectSalesOrderOid'];
    contactName = json['contactName'];
    contactTel = json['contactTel'];
    createDttm = DateTimeUtil.toDateTime(json['createDttm']);
    createUserId = json['createUserId'];
    createUserNm = json['createUserNm'];
    isCalPro = json['isCalPro'] ?? false;
    isHirePurchasePayment = json['isHirePurchasePayment'] ?? false;
    isNotReject = json['isNotReject'] ?? false;
    lastUpdDttm = DateTimeUtil.toDateTime(json['lastUpdDttm']);
    lastUpdUser = json['lastUpdUser'];
    numItem = json['numItem'];
    qtNo = json['qtNo'];
    salesChannel = json['salesChannel'];
    salesOrderStsId = json['salesOrderStsId'];
    salesOrderTypeId = json['salesOrderTypeId'];
    if (json['salesOrders'] != null) {
      salesOrders = new List<SalesOrder>();
      json['salesOrders'].forEach((v) {
        salesOrders.add(new SalesOrder.fromJson(v));
      });
    }
    sapBillingNo = json['sapBillingNo'];
    sapSoNo = json['sapSoNo'];
    soldToCustomer = json['soldToCustomer'] != null ? new Customer.fromJson(json['soldToCustomer']) : null;
    storeId = json['storeId'];
    trnDt = DateTimeUtil.toDateTime(json['trnDt']);
    versionId = json['versionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.billToCustomer != null) {
      data['billToCustomer'] = this.billToCustomer.toJson();
    }
    data['collSalesOrderNo'] = this.collSalesOrderNo;
    data['collectSalesOrderOid'] = this.collectSalesOrderOid;
    data['contactName'] = this.contactName;
    data['contactTel'] = this.contactTel;
    data['createDttm'] = this.createDttm?.toIso8601String();
    data['createUserId'] = this.createUserId;
    data['createUserNm'] = this.createUserNm;
    data['isCalPro'] = this.isCalPro;
    data['isHirePurchasePayment'] = this.isHirePurchasePayment;
    data['isNotReject'] = this.isNotReject;
    data['lastUpdDttm'] = this.lastUpdDttm?.toIso8601String();
    data['lastUpdUser'] = this.lastUpdUser;
    data['numItem'] = this.numItem;
    data['qtNo'] = this.qtNo;
    data['salesChannel'] = this.salesChannel;
    data['salesOrderStsId'] = this.salesOrderStsId;
    data['salesOrderTypeId'] = this.salesOrderTypeId;
    if (this.salesOrders != null) {
      data['salesOrders'] = this.salesOrders.map((v) => v.toJson()).toList();
    }
    data['sapBillingNo'] = this.sapBillingNo;
    data['sapSoNo'] = this.sapSoNo;
    if (this.soldToCustomer != null) {
      data['soldToCustomer'] = this.soldToCustomer.toJson();
    }
    data['storeId'] = this.storeId;
    data['trnDt'] = this.trnDt?.toIso8601String();
    data['versionId'] = this.versionId;
    return data;
  }
}

class Customer {
  String building;
  String cardNumber;
  String customerGroup;
  num customerOid;
  String district;
  String email;
  String fax;
  String firstName;
  String floor;
  String language;
  String lastName;
  String moo;
  String number;
  String partnerFunctionTypeId;
  String phoneNumber1;
  String phoneNumber2;
  String phoneNumber3;
  String phoneNumber4;
  String placeId;
  String province;
  String sapId;
  String soi;
  String street;
  String subDistrict;
  String titleId;
  String title;
  TransportData transportData;
  String type;
  String unit;
  bool vatClassification;
  String village;
  String zipCode;
  String taxId;
  String nationality;
  String branchId;
  String branchType;
  String branchDesc;
  List<CustomerPartners> customerPartners;
  String memberCardTypeId;
  bool isRewardCardNo;

  Customer({this.building, this.cardNumber, this.customerGroup, this.customerOid, this.district, this.email, this.fax, this.firstName, this.floor, this.language, this.lastName, this.moo, this.number, this.partnerFunctionTypeId, this.phoneNumber1, this.phoneNumber2, this.phoneNumber3, this.phoneNumber4, this.placeId, this.province, this.sapId, this.soi, this.street, this.subDistrict, this.titleId, this.title, this.transportData, this.type, this.unit, this.vatClassification, this.village, this.zipCode, this.taxId, this.branchId, this.branchType, this.branchDesc, this.nationality, this.memberCardTypeId, this.isRewardCardNo});

  Customer.fromJson(Map<String, dynamic> json) {
    building = json['building'];
    cardNumber = json['cardNumber'];
    customerGroup = json['customerGroup'];
    customerOid = json['customerOid'];
    district = json['district'];
    email = json['email'];
    fax = json['fax'];
    firstName = json['firstName'];
    floor = json['floor'];
    language = json['language'];
    lastName = json['lastName'];
    moo = json['moo'];
    number = json['number'];
    partnerFunctionTypeId = json['partnerFunctionTypeId'];
    phoneNumber1 = json['phoneNumber1'];
    phoneNumber2 = json['phoneNumber2'];
    phoneNumber3 = json['phoneNumber3'];
    phoneNumber4 = json['phoneNumber4'];
    placeId = json['placeId'];
    province = json['province'];
    sapId = json['sapId'];
    soi = json['soi'];
    street = json['street'];
    subDistrict = json['subDistrict'];
    titleId = json['titleId'];
    title = json['title'];
    transportData = json['transportData'] != null ? new TransportData.fromJson(json['transportData']) : null;
    type = json['type'];
    unit = json['unit'];
    vatClassification = json['vatClassification'];
    village = json['village'];
    zipCode = json['zipCode'];
    taxId = json['taxId'];
    nationality = json['nationality'];
    branchId = json['branchId'];
    branchType = json['branchType'];
    branchDesc = json['branchDesc'];
    if (json['customerPartners'] != null) {
      customerPartners = new List<CustomerPartners>();
      json['customerPartners'].forEach((v) {
        customerPartners.add(new CustomerPartners.fromJson(v));
      });
    }
    memberCardTypeId = json['memberCardTypeId'];
    isRewardCardNo = json['isRewardCardNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['building'] = this.building;
    data['cardNumber'] = this.cardNumber;
    data['customerGroup'] = this.customerGroup;
    data['customerOid'] = this.customerOid;
    data['district'] = this.district;
    data['email'] = this.email;
    data['fax'] = this.fax;
    data['firstName'] = this.firstName;
    data['floor'] = this.floor;
    data['language'] = this.language;
    data['lastName'] = this.lastName;
    data['moo'] = this.moo;
    data['number'] = this.number;
    data['partnerFunctionTypeId'] = this.partnerFunctionTypeId;
    data['phoneNumber1'] = this.phoneNumber1;
    data['phoneNumber2'] = this.phoneNumber2;
    data['phoneNumber3'] = this.phoneNumber3;
    data['phoneNumber4'] = this.phoneNumber4;
    data['placeId'] = this.placeId;
    data['province'] = this.province;
    data['sapId'] = this.sapId;
    data['soi'] = this.soi;
    data['street'] = this.street;
    data['subDistrict'] = this.subDistrict;
    data['titleId'] = this.titleId;
    data['title'] = this.title;
    if (this.transportData != null) {
      data['transportData'] = this.transportData.toJson();
    }
    data['type'] = this.type;
    data['unit'] = this.unit;
    data['vatClassification'] = this.vatClassification;
    data['village'] = this.village;
    data['zipCode'] = this.zipCode;
    data['taxId'] = this.taxId;
    data['branchId'] = this.branchId;
    data['branchType'] = this.branchType;
    data['branchDesc'] = this.branchDesc;
    data['nationality'] = this.nationality;
    if (this.customerPartners != null) {
      data['customerPartners'] = this.customerPartners.map((v) => v.toJson()).toList();
    }
    if (this.transportData != null) {
      data['transportData'] = this.transportData.toJson();
    }
    data['memberCardTypeId'] = this.memberCardTypeId;
    data['isRewardCardNo'] = this.isRewardCardNo;
    return data;
  }
}

class SalesCartItem {
  List<ArticleSet> articleSets;
  String articleNo;
  String batch;
  String deliverySite;
  String incentiveId;
  String incentiveName;
  int installCheckListId;
  bool isDeliveryFee;
  bool isInstallAfter;
  bool isInstallSameDay;
  bool isLotReq;
  bool isMainInstall;
  bool isMainPrd;
  bool isPremium;
  bool isPremiumService;
  bool isPriceReq;
  bool isQtyReq;
  bool isSalesSet;
  bool isSameDay;
  bool isSpecialDts;
  bool isSpecialOrder;
  String itemDescription;
  String itemUpc;
  String lineItem;
  String mchId;
  num netItemAmt;
  num qty;
  num qtyRemain;
  num refSalesCartItemOid;
  String remark;
  num salesCartItemOid;
  num salesOrderItemOid;
  num salesOrderGroupOid;
  num salesOrderOid;
  String servNo;
  String shippingPointId;
  num stockQty;
  String unit;
  num unitPrice;
  num refMainItemIndex;

  SalesCartItem({
    this.articleSets,
    this.articleNo,
    this.batch,
    this.deliverySite,
    this.incentiveId,
    this.incentiveName,
    this.installCheckListId,
    this.isDeliveryFee = false,
    this.isInstallAfter = false,
    this.isInstallSameDay = false,
    this.isLotReq = false,
    this.isMainInstall = false,
    this.isMainPrd = false,
    this.isPremium = false,
    this.isPremiumService = false,
    this.isPriceReq = false,
    this.isQtyReq = false,
    this.isSalesSet = false,
    this.isSameDay = false,
    this.isSpecialDts = false,
    this.isSpecialOrder = false,
    this.itemDescription,
    this.itemUpc,
    this.lineItem,
    this.mchId,
    this.netItemAmt,
    this.qty,
    this.qtyRemain,
    this.refSalesCartItemOid,
    this.remark,
    this.salesCartItemOid = 0,
    this.salesOrderItemOid,
    this.salesOrderGroupOid,
    this.salesOrderOid,
    this.servNo,
    this.shippingPointId,
    this.stockQty,
    this.unit,
    this.unitPrice,
    this.refMainItemIndex,
  });

  SalesCartItem.fromJson(Map<String, dynamic> json) {
    if (json['articeSets'] != null) {
      articleSets = new List<ArticleSet>();
      json['articeSets'].forEach((v) {
        articleSets.add(new ArticleSet.fromJson(v));
      });
    }
    articleNo = json['articleNo'];
    batch = json['batch'];
    deliverySite = json['deliverySite'];
    incentiveId = json['incentiveId'];
    incentiveName = json['incentiveName'];
    installCheckListId = json['installCheckListId'];
    isDeliveryFee = json['isDeliveryFee'] ?? false;
    isInstallAfter = json['isInstallAfter'] ?? false;
    isInstallSameDay = json['isInstallSameDay'] ?? false;
    isLotReq = json['isLotReq'] ?? false;
    isMainInstall = json['isMainInstall'] ?? false;
    isMainPrd = json['isMainPrd'] ?? false;
    isPremium = json['isPremium'] ?? false;
    isPremiumService = json['isPremiumService'] ?? false;
    isPriceReq = json['isPriceReq'] ?? false;
    isQtyReq = json['isQtyReq'] ?? false;
    isSalesSet = json['isSalesSet'] ?? false;
    isSameDay = json['isSameDay'] ?? false;
    isSpecialDts = json['isSpecialDts'] ?? false;
    isSpecialOrder = json['isSpecialOrder'] ?? false;
    itemDescription = json['itemDescription'];
    itemUpc = json['itemUpc'];
    lineItem = json['lineItem'];
    mchId = json['mchId'];
    netItemAmt = json['netItemAmt'];
    qty = json['qty'];
    qtyRemain = json['qtyRemain'];
    refSalesCartItemOid = json['refSalesCartItemOid'];
    remark = json['remark'];
    salesCartItemOid = json['salesCartItemOid'];
    salesOrderGroupOid = json['salesOrderGroupOid'];
    salesOrderItemOid = json['salesOrderItemOid'];
    salesOrderOid = json['salesOrderOid'];
    servNo = json['servNo'];
    shippingPointId = json['shippingPointId'];
    stockQty = json['stockQty'];
    unit = json['unit'];
    unitPrice = json['unitPrice'];
    refMainItemIndex = json['refMainItemIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articleSets != null) {
      data['articeSets'] = this.articleSets.map((v) => v.toJson()).toList();
    }
    data['articleNo'] = this.articleNo;
    data['batch'] = this.batch;
    data['deliverySite'] = this.deliverySite;
    data['incentiveId'] = this.incentiveId;
    data['incentiveName'] = this.incentiveName;
    data['installCheckListId'] = this.installCheckListId;
    data['isDeliveryFee'] = this.isDeliveryFee;
    data['isInstallAfter'] = this.isInstallAfter;
    data['isInstallSameDay'] = this.isInstallSameDay;
    data['isLotReq'] = this.isLotReq;
    data['isMainInstall'] = this.isMainInstall;
    data['isMainPrd'] = this.isMainPrd;
    data['isPremium'] = this.isPremium;
    data['isPremiumService'] = this.isPremiumService;
    data['isPriceReq'] = this.isPriceReq;
    data['isQtyReq'] = this.isQtyReq;
    data['isSalesSet'] = this.isSalesSet;
    data['isSameDay'] = this.isSameDay;
    data['isSpecialDts'] = this.isSpecialDts;
    data['isSpecialOrder'] = this.isSpecialOrder;
    data['itemDescription'] = this.itemDescription;
    data['itemUpc'] = this.itemUpc;
    data['lineItem'] = this.lineItem;
    data['mchId'] = this.mchId;
    data['netItemAmt'] = this.netItemAmt;
    data['qty'] = this.qty;
    data['qtyRemain'] = this.qtyRemain;
    data['refSalesCartItemOid'] = this.refSalesCartItemOid;
    data['remark'] = this.remark;
    data['salesCartItemOid'] = this.salesCartItemOid;
    data['salesOrderItemOid'] = this.salesOrderItemOid;
    data['salesOrderGroupOid'] = this.salesOrderGroupOid;
    data['salesOrderOid'] = this.salesOrderOid;
    data['servNo'] = this.servNo;
    data['shippingPointId'] = this.shippingPointId;
    data['stockQty'] = this.stockQty;
    data['unit'] = this.unit;
    data['unitPrice'] = this.unitPrice;
    data['refMainItemIndex'] = this.refMainItemIndex;
    return data;
  }

  @override
  String toString() {
    return 'SalesCartItem{articleSets: $articleSets, articleNo: $articleNo, batch: $batch, deliverySite: $deliverySite, incentiveId: $incentiveId, incentiveName: $incentiveName, isDeliveryFee: $isDeliveryFee, isInstallAfter: $isInstallAfter, isInstallSameDay: $isInstallSameDay, isLotReq: $isLotReq, isMainInstall: $isMainInstall, isMainPrd: $isMainPrd, isPremium: $isPremium, isPriceReq: $isPriceReq, isQtyReq: $isQtyReq, isSalesSet: $isSalesSet, isSameDay: $isSameDay, isSpecialDts: $isSpecialDts, isSpecialOrder: $isSpecialOrder, itemDescription: $itemDescription, itemUpc: $itemUpc, lineItem: $lineItem, mchId: $mchId, netItemAmt: $netItemAmt, qty: $qty, qtyRemain: $qtyRemain, refSalesCartItemOid: $refSalesCartItemOid, remark: $remark, salesCartItemOid: $salesCartItemOid, salesOrderItemOid: $salesOrderItemOid, salesOrderGroupOid: $salesOrderGroupOid, salesOrderOid: $salesOrderOid, servNo: $servNo, shippingPointId: $shippingPointId, stockQty: $stockQty, unit: $unit, unitPrice: $unitPrice}';
  }

  bool isLocalImage() {
    return isPremium || isPremiumService;
  }

  String getImagePath() {
    if (isPremiumService) return 'assets/images/free_service.png';
    if (isPremium) return 'assets/images/free_gift.png';
    return '';
  }

}

class SalesOrder {
  String building;
  DateTime createDate;
  String district;
  String firstName;
  String floorNumber;
  String lastName;
  String mapLat;
  String mapLong;
  String moo;
  String number;
  String province;
  String routeDetails;
  String salesChannel;
  List<SalesOrderGroup> salesOrderGroups;
  List<SalesOrderItem> salesOrderItems;
  String salesOrderNo;
  num salesOrderOid;
  String salesType;
  String soi;
  Customer soldToCustomer;
  DateTime startDate;
  String storeId;
  String street;
  String subDistrict;
  String telephoneNo;
  DateTime transactionDate;
  String unit;
  String village;
  String zipCode;
  String sapOrderCode;
  String distributionChannel;

  SalesOrder({this.building, this.createDate, this.district, this.firstName, this.floorNumber, this.lastName, this.mapLat, this.mapLong, this.moo, this.number, this.province, this.routeDetails, this.salesChannel, this.salesOrderGroups, this.salesOrderItems, this.salesOrderNo, this.salesOrderOid, this.salesType, this.soi, this.soldToCustomer, this.startDate, this.storeId, this.street, this.subDistrict, this.telephoneNo, this.transactionDate, this.unit, this.village, this.zipCode, this.sapOrderCode, this.distributionChannel});

  SalesOrder.fromJson(Map<String, dynamic> json) {
    building = json['building'];
    createDate = DateTimeUtil.toDateTime(json['createDate']);
    district = json['district'];
    firstName = json['firstName'];
    floorNumber = json['floorNumber'];
    lastName = json['lastName'];
    mapLat = json['mapLat'];
    mapLong = json['mapLong'];
    moo = json['moo'];
    number = json['number'];
    province = json['province'];
    routeDetails = json['routeDetails'];
    salesChannel = json['salesChannel'];
    if (json['salesOrderGroups'] != null) {
      salesOrderGroups = new List<SalesOrderGroup>();
      json['salesOrderGroups'].forEach((v) {
        salesOrderGroups.add(new SalesOrderGroup.fromJson(v));
      });
    }
    if (json['salesOrderItems'] != null) {
      salesOrderItems = new List<SalesOrderItem>();
      json['salesOrderItems'].forEach((v) {
        salesOrderItems.add(new SalesOrderItem.fromJson(v));
      });
    }
    salesOrderNo = json['salesOrderNo'];
    salesOrderOid = json['salesOrderOid'];
    salesType = json['salesType'];
    soi = json['soi'];
    soldToCustomer = json['soldToCustomer'] != null ? new Customer.fromJson(json['soldToCustomer']) : null;
    startDate = DateTimeUtil.toDateTime(json['startDate']);
    storeId = json['storeId'];
    street = json['street'];
    subDistrict = json['subDistrict'];
    telephoneNo = json['telephoneNo'];
    transactionDate = DateTimeUtil.toDateTime(json['transactionDate']);
    unit = json['unit'];
    village = json['village'];
    zipCode = json['zipCode'];
    sapOrderCode = json['sapOrderCode'];
    distributionChannel = json['distributionChannel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['building'] = this.building;
    data['createDate'] = this.createDate?.toIso8601String();
    data['district'] = this.district;
    data['firstName'] = this.firstName;
    data['floorNumber'] = this.floorNumber;
    data['lastName'] = this.lastName;
    data['mapLat'] = this.mapLat;
    data['mapLong'] = this.mapLong;
    data['moo'] = this.moo;
    data['number'] = this.number;
    data['province'] = this.province;
    data['routeDetails'] = this.routeDetails;
    data['salesChannel'] = this.salesChannel;
    if (this.salesOrderGroups != null) {
      data['salesOrderGroups'] = this.salesOrderGroups.map((v) => v.toJson()).toList();
    }
    if (this.salesOrderItems != null) {
      data['salesOrderItems'] = this.salesOrderItems.map((v) => v.toJson()).toList();
    }
    data['salesOrderNo'] = this.salesOrderNo;
    data['salesOrderOid'] = this.salesOrderOid;
    data['salesType'] = this.salesType;
    data['soi'] = this.soi;
    if (this.soldToCustomer != null) {
      data['soldToCustomer'] = this.soldToCustomer.toJson();
    }
    data['startDate'] = this.startDate?.toIso8601String();
    data['storeId'] = this.storeId;
    data['street'] = this.street;
    data['subDistrict'] = this.subDistrict;
    data['telephoneNo'] = this.telephoneNo;
    data['transactionDate'] = this.transactionDate?.toIso8601String();
    data['unit'] = this.unit;
    data['village'] = this.village;
    data['zipCode'] = this.zipCode;
    data['sapOrderCode'] = this.sapOrderCode;
    data['distributionChannel'] = this.distributionChannel;
    return data;
  }
}

class SalesOrderGroup {
  String confirmTypeDesc;
  String confirmTypeId;
  String contactName;
  String contactTel;
  DateTime deliveryDate;
  String deliveryManagerId;
  String deliveryQueueNo;
  String deliverySite;
  String deliveryStoreId;
  String districtNo;
  num groupNo;
  DateTime installDate;
  String installDeliverySite;
  String installDistrictNo;
  String installJobNo;
  InstallJobType installJobType;
  num installMainQuantity;
  String installProductType;
  String installProvinceNo;
  String installQueueNo;
  String installRemark;
  String installSapDONo;
  String installShippingPointId;
  String installSpecWork;
  String installTimeFrameNo;
  String installTimeNo;
  String installTimeType;
  String installVendorNo;
  bool isDTSpecify;
  bool isInstallDTSpecify;
  bool isInstallLater;
  bool isOtherStoreDelivery;
  bool isPendingFlag;
  String pendingContactDate;
  String jobNo;
  InstallJobType jobType;
  num mainQuantity;
  String productType;
  String provinceNo;
  String remark;
  num salesOrderGroupId;
  List<SalesOrderItem> salesOrderItems;
  String sapDONo;
  Customer shipToCustomer;
  String shippingPointId;
  String specWork;
  String timeFrameNo;
  String timeNo;
  String timeType;
  String vendorNo;
  String workNo;

  SalesOrderGroup({
    this.confirmTypeDesc,
    this.confirmTypeId,
    this.contactName,
    this.contactTel,
    this.deliveryDate,
    this.deliveryManagerId,
    this.deliveryQueueNo,
    this.deliverySite,
    this.deliveryStoreId,
    this.districtNo,
    this.groupNo,
    this.installDate,
    this.installDeliverySite,
    this.installDistrictNo,
    this.installJobNo,
    this.installJobType,
    this.installMainQuantity,
    this.installProductType,
    this.installProvinceNo,
    this.installQueueNo,
    this.installRemark,
    this.installSapDONo,
    this.installShippingPointId,
    this.installSpecWork,
    this.installTimeFrameNo,
    this.installTimeNo,
    this.installTimeType,
    this.installVendorNo,
    this.isDTSpecify,
    this.isInstallDTSpecify,
    this.isInstallLater,
    this.isOtherStoreDelivery,
    this.isPendingFlag,
    this.pendingContactDate,
    this.jobNo,
    this.jobType,
    this.mainQuantity,
    this.productType,
    this.provinceNo,
    this.remark,
    this.salesOrderGroupId,
    this.salesOrderItems,
    this.sapDONo,
    this.shipToCustomer,
    this.shippingPointId,
    this.specWork,
    this.timeFrameNo,
    this.timeNo,
    this.timeType,
    this.vendorNo,
    this.workNo,
  }) {
    isInstallLater = false;
    isDTSpecify = false;
    isInstallDTSpecify = false;
    isOtherStoreDelivery = false;
    isPendingFlag = false;
  }

  SalesOrderGroup.fromJson(Map<String, dynamic> json) {
    confirmTypeDesc = json['confirmTypeDesc'];
    confirmTypeId = json['confirmTypeId'];
    contactName = json['contactName'];
    contactTel = json['contactTel'];
    deliveryDate = DateTimeUtil.toDateTime(json['deliveryDate']);
    deliveryManagerId = json['deliveryManagerId'];
    deliveryQueueNo = json['deliveryQueueNo'];
    deliverySite = json['deliverySite'];
    deliveryStoreId = json['deliveryStoreId'];
    districtNo = json['districtNo'];
    groupNo = json['groupNo'];
    installDate = DateTimeUtil.toDateTime(json['installDate']);
    installDeliverySite = json['installDeliverySite'];
    installDistrictNo = json['installDistrictNo'];
    installJobNo = json['installJobNo'];
    installJobType = json['installJobType'] != null ? new InstallJobType.fromJson(json['installJobType']) : null;
    installMainQuantity = json['installMainQuantity'];
    installProductType = json['installProductType'];
    installProvinceNo = json['installProvinceNo'];
    installQueueNo = json['installQueueNo'];
    installRemark = json['installRemark'];
    installSapDONo = json['installSapDONo'];
    installShippingPointId = json['installShippingPointId'];
    installSpecWork = json['installSpecWork'];
    installTimeFrameNo = json['installTimeFrameNo'];
    installTimeNo = json['installTimeNo'];
    installTimeType = json['installTimeType'];
    installVendorNo = json['installVendorNo'];
    isDTSpecify = json['isDTSpecify'];
    isInstallDTSpecify = json['isInstallDTSpecify'];
    isInstallLater = json['isInstallLater'];
    isOtherStoreDelivery = json['isOtherStoreDelivery'];
    isPendingFlag = json['isPendingFlag'];
    pendingContactDate = json['pendingContactDate'];
    jobNo = json['jobNo'];
    jobType = json['jobType'] != null ? new InstallJobType.fromJson(json['jobType']) : null;
    mainQuantity = json['mainQuantity'];
    productType = json['productType'];
    provinceNo = json['provinceNo'];
    remark = json['remark'];
    salesOrderGroupId = json['salesOrderGroupId'];
    if (json['salesOrderItems'] != null) {
      salesOrderItems = new List<SalesOrderItem>();
      json['salesOrderItems'].forEach((v) {
        salesOrderItems.add(new SalesOrderItem.fromJson(v));
      });
    }
    sapDONo = json['sapDONo'];
    shipToCustomer = json['shipToCustomer'] != null ? new Customer.fromJson(json['shipToCustomer']) : null;
    shippingPointId = json['shippingPointId'];
    specWork = json['specWork'];
    timeFrameNo = json['timeFrameNo'];
    timeNo = json['timeNo'];
    timeType = json['timeType'];
    vendorNo = json['vendorNo'];
    workNo = json['workNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['confirmTypeDesc'] = this.confirmTypeDesc;
    data['confirmTypeId'] = this.confirmTypeId;
    data['contactName'] = this.contactName;
    data['contactTel'] = this.contactTel;
    data['deliveryDate'] = this.deliveryDate?.toIso8601String();
    data['deliveryManagerId'] = this.deliveryManagerId;
    data['deliveryQueueNo'] = this.deliveryQueueNo;
    data['deliverySite'] = this.deliverySite;
    data['deliveryStoreId'] = this.deliveryStoreId;
    data['districtNo'] = this.districtNo;
    data['groupNo'] = this.groupNo;
    data['installDate'] = this.installDate?.toIso8601String();
    data['installDeliverySite'] = this.installDeliverySite;
    data['installDistrictNo'] = this.installDistrictNo;
    data['installJobNo'] = this.installJobNo;
    if (this.installJobType != null) {
      data['installJobType'] = this.installJobType.toJson();
    }
    data['installMainQuantity'] = this.installMainQuantity;
    data['installProductType'] = this.installProductType;
    data['installProvinceNo'] = this.installProvinceNo;
    data['installQueueNo'] = this.installQueueNo;
    data['installRemark'] = this.installRemark;
    data['installSapDONo'] = this.installSapDONo;
    data['installShippingPointId'] = this.installShippingPointId;
    data['installSpecWork'] = this.installSpecWork;
    data['installTimeFrameNo'] = this.installTimeFrameNo;
    data['installTimeNo'] = this.installTimeNo;
    data['installTimeType'] = this.installTimeType;
    data['installVendorNo'] = this.installVendorNo;
    data['isDTSpecify'] = this.isDTSpecify;
    data['isInstallDTSpecify'] = this.isInstallDTSpecify;
    data['isInstallLater'] = this.isInstallLater;
    data['isOtherStoreDelivery'] = this.isOtherStoreDelivery;
    data['isPendingFlag'] = this.isPendingFlag;
    data['pendingContactDate'] = this.pendingContactDate;
    data['jobNo'] = this.jobNo;
    if (this.jobType != null) {
      data['jobType'] = this.jobType.toJson();
    }
    data['mainQuantity'] = this.mainQuantity;
    data['productType'] = this.productType;
    data['provinceNo'] = this.provinceNo;
    data['remark'] = this.remark;
    data['salesOrderGroupId'] = this.salesOrderGroupId;
    if (this.salesOrderItems != null) {
      data['salesOrderItems'] = this.salesOrderItems.map((v) => v.toJson()).toList();
    }
    data['sapDONo'] = this.sapDONo;
    if (this.shipToCustomer != null) {
      data['shipToCustomer'] = this.shipToCustomer.toJson();
    }
    data['shippingPointId'] = this.shippingPointId;
    data['specWork'] = this.specWork;
    data['timeFrameNo'] = this.timeFrameNo;
    data['timeNo'] = this.timeNo;
    data['timeType'] = this.timeType;
    data['vendorNo'] = this.vendorNo;
    data['workNo'] = this.workNo;
    return data;
  }
}

class SimulatePaymentBo {
  List<SimPayBurnpointBo> simPayBurnpointBos;
  List<SimPayDiscountBo> simPayDiscountBos;
  List<SimPayHirepurchaseBo> simPayHirepurchaseBo;
  List<SimPayMemberDiscountBo> simPayMemberDiscountBo;
  SimPayMemberDiscountBo simPayMemberRewardBo;
  List<SimPayPremiumBo> simPayPremiumBos;
  List<SimPayPromoitonBo> simPayPromoitonBos;
  List<SimPayTenderBo> simPayTenderBos;
  num totalPromotionDiscount;

  SimulatePaymentBo({this.simPayBurnpointBos, this.simPayDiscountBos, this.simPayHirepurchaseBo, this.simPayMemberDiscountBo, this.simPayMemberRewardBo, this.simPayPremiumBos, this.simPayPromoitonBos, this.simPayTenderBos, this.totalPromotionDiscount});

  SimulatePaymentBo.fromJson(Map<String, dynamic> json) {
    if (json['simPayBurnpointBos'] != null) {
      simPayBurnpointBos = new List<SimPayBurnpointBo>();
      json['simPayBurnpointBos'].forEach((v) {
        simPayBurnpointBos.add(new SimPayBurnpointBo.fromJson(v));
      });
    }
    if (json['simPayDiscountBos'] != null) {
      simPayDiscountBos = new List<SimPayDiscountBo>();
      json['simPayDiscountBos'].forEach((v) {
        simPayDiscountBos.add(new SimPayDiscountBo.fromJson(v));
      });
    }
    if (json['simPayHirepurchaseBo'] != null) {
      simPayHirepurchaseBo = new List<SimPayHirepurchaseBo>();
      json['simPayHirepurchaseBo'].forEach((v) {
        simPayHirepurchaseBo.add(new SimPayHirepurchaseBo.fromJson(v));
      });
    }
    if (json['simPayMemberDiscountBo'] != null) {
      simPayMemberDiscountBo = new List<SimPayMemberDiscountBo>();
      json['simPayMemberDiscountBo'].forEach((v) {
        simPayMemberDiscountBo.add(new SimPayMemberDiscountBo.fromJson(v));
      });
    }
    simPayMemberRewardBo = json['simPayMemberRewardBo'] != null ? new SimPayMemberDiscountBo.fromJson(json['simPayMemberRewardBo']) : null;
    if (json['simPayPremiumBos'] != null) {
      simPayPremiumBos = new List<SimPayPremiumBo>();
      json['simPayPremiumBos'].forEach((v) {
        simPayPremiumBos.add(new SimPayPremiumBo.fromJson(v));
      });
    }
    if (json['simPayPromoitonBos'] != null) {
      simPayPromoitonBos = new List<SimPayPromoitonBo>();
      json['simPayPromoitonBos'].forEach((v) {
        simPayPromoitonBos.add(new SimPayPromoitonBo.fromJson(v));
      });
    }
    if (json['simPayTenderBos'] != null) {
      simPayTenderBos = new List<SimPayTenderBo>();
      json['simPayTenderBos'].forEach((v) {
        simPayTenderBos.add(new SimPayTenderBo.fromJson(v));
      });
    }
    totalPromotionDiscount = json['totalPromotionDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.simPayBurnpointBos != null) {
      data['simPayBurnpointBos'] = this.simPayBurnpointBos.map((v) => v.toJson()).toList();
    }
    if (this.simPayDiscountBos != null) {
      data['simPayDiscountBos'] = this.simPayDiscountBos.map((v) => v.toJson()).toList();
    }
    if (this.simPayHirepurchaseBo != null) {
      data['simPayHirepurchaseBo'] = this.simPayHirepurchaseBo.map((v) => v.toJson()).toList();
    }
    if (this.simPayMemberDiscountBo != null) {
      data['simPayMemberDiscountBo'] = this.simPayMemberDiscountBo.map((v) => v.toJson()).toList();
    }
    if (this.simPayMemberRewardBo != null) {
      data['simPayMemberRewardBo'] = this.simPayMemberRewardBo.toJson();
    }
    if (this.simPayPremiumBos != null) {
      data['simPayPremiumBos'] = this.simPayPremiumBos.map((v) => v.toJson()).toList();
    }
    if (this.simPayPromoitonBos != null) {
      data['simPayPromoitonBos'] = this.simPayPromoitonBos.map((v) => v.toJson()).toList();
    }
    if (this.simPayTenderBos != null) {
      data['simPayTenderBos'] = this.simPayTenderBos.map((v) => v.toJson()).toList();
    }
    data['totalPromotionDiscount'] = this.totalPromotionDiscount;
    return data;
  }
}

class Store {
  String address1;
  String faxNo1;
  String name;
  String phoneNo1;
  String storeId;
  String storeIp;
  String taxId;
  String zipCode;

  Store({this.address1, this.faxNo1, this.name, this.phoneNo1, this.storeId, this.storeIp, this.taxId, this.zipCode});

  Store.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    faxNo1 = json['faxNo1'];
    name = json['name'];
    phoneNo1 = json['phoneNo1'];
    storeId = json['storeId'];
    storeIp = json['storeIp'];
    taxId = json['taxId'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['faxNo1'] = this.faxNo1;
    data['name'] = this.name;
    data['phoneNo1'] = this.phoneNo1;
    data['storeId'] = this.storeId;
    data['storeIp'] = this.storeIp;
    data['taxId'] = this.taxId;
    data['zipCode'] = this.zipCode;
    return data;
  }
}

class TransportData {
  String contactPoint;
  bool isLiftAvailability;
  String mapLatitude;
  String mapLocation;
  String mapLongtitude;
  String mapName;
  String parkingDistance;
  String parkingFee;
  String parkingTime;
  String plotMapLocation;
  String plotMapName;
  String plotMapPath;
  String pointOfInterest;
  String receipient;
  String routeDetails;
  String telephone;
  String tmsLatitude;
  String tmsLongtitude;
  num tranDataOid;

  TransportData({this.contactPoint, this.isLiftAvailability, this.mapLatitude, this.mapLocation, this.mapLongtitude, this.mapName, this.parkingDistance, this.parkingFee, this.parkingTime, this.plotMapLocation, this.plotMapName, this.plotMapPath, this.pointOfInterest, this.receipient, this.routeDetails, this.telephone, this.tmsLatitude, this.tmsLongtitude, this.tranDataOid});

  TransportData.fromJson(Map<String, dynamic> json) {
    contactPoint = json['contactPoint'];
    isLiftAvailability = json['isLiftAvailability'];
    mapLatitude = json['mapLatitude'];
    mapLocation = json['mapLocation'];
    mapLongtitude = json['mapLongtitude'];
    mapName = json['mapName'];
    parkingDistance = json['parkingDistance'];
    parkingFee = json['parkingFee'];
    parkingTime = json['parkingTime'];
    plotMapLocation = json['plotMapLocation'];
    plotMapName = json['plotMapName'];
    plotMapPath = json['plotMapPath'];
    pointOfInterest = json['pointOfInterest'];
    receipient = json['receipient'];
    routeDetails = json['routeDetails'];
    telephone = json['telephone'];
    tmsLatitude = json['tmsLatitude'];
    tmsLongtitude = json['tmsLongtitude'];
    tranDataOid = json['tranDataOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactPoint'] = this.contactPoint;
    data['isLiftAvailability'] = this.isLiftAvailability;
    data['mapLatitude'] = this.mapLatitude;
    data['mapLocation'] = this.mapLocation;
    data['mapLongtitude'] = this.mapLongtitude;
    data['mapName'] = this.mapName;
    data['parkingDistance'] = this.parkingDistance;
    data['parkingFee'] = this.parkingFee;
    data['parkingTime'] = this.parkingTime;
    data['plotMapLocation'] = this.plotMapLocation;
    data['plotMapName'] = this.plotMapName;
    data['plotMapPath'] = this.plotMapPath;
    data['pointOfInterest'] = this.pointOfInterest;
    data['receipient'] = this.receipient;
    data['routeDetails'] = this.routeDetails;
    data['telephone'] = this.telephone;
    data['tmsLatitude'] = this.tmsLatitude;
    data['tmsLongtitude'] = this.tmsLongtitude;
    data['tranDataOid'] = this.tranDataOid;
    return data;
  }
}

class ArticleSet {
  String artcSetId;
  String articleNo;
  String itemDescription;
  num qty;
  String unit;

  ArticleSet({this.artcSetId, this.articleNo, this.itemDescription, this.qty, this.unit});

  ArticleSet.fromJson(Map<String, dynamic> json) {
    artcSetId = json['artcSetId'];
    articleNo = json['articleNo'];
    itemDescription = json['itemDescription'];
    qty = json['qty'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artcSetId'] = this.artcSetId;
    data['articleNo'] = this.articleNo;
    data['itemDescription'] = this.itemDescription;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    return data;
  }
}

class SalesOrderItem {
  String articleNo;
  String batch;
  String blockCodeId;
  String deliverySite;
  String description;
  DateTime downPaymentDateTime;
  int installCheckListId;
  bool isBlockPurchase;
  bool isDeliveryFee;
  bool isDownPayment;
  bool isLotRequired;
  bool isMainInstall;
  bool isMainProduct;
  bool isPremium;
  bool isPriceRequired;
  bool isQtyRequired;
  bool isReserveDC;
  bool isSalesSet;
  bool isSpecialDTS;
  bool isSpecialOrder;
  String itemUPC;
  String lastUpdateUser;
  String mainUPC;
  String mc9;
  num netItemAmount;
  num quantity;
  num refSeqNo;
  String rejectReasonId;
  String remark;
  num salesCartItemOid;
  num salesOrderItemOid;
  List<SalesOrderSetItem> salesOrderSetItemBos;
  String salesPersonId;
  String salesPersonName;
  num seqNo;
  String shippingPointId;
  String supplySourceId;
  String unit;
  num unitPrice;
  String userIncentiveId;
  String userIncentiveName;
  String refClmId;

  SalesOrderItem({
    this.articleNo,
    this.batch,
    this.blockCodeId,
    this.deliverySite,
    this.description,
    this.downPaymentDateTime,
    this.installCheckListId,
    this.isBlockPurchase = false,
    this.isDeliveryFee = false,
    this.isDownPayment = false,
    this.isLotRequired = false,
    this.isMainInstall = false,
    this.isMainProduct = false,
    this.isPremium = false,
    this.isPriceRequired = false,
    this.isQtyRequired = false,
    this.isReserveDC = false,
    this.isSalesSet = false,
    this.isSpecialDTS = false,
    this.isSpecialOrder = false,
    this.itemUPC,
    this.lastUpdateUser,
    this.mainUPC,
    this.mc9,
    this.netItemAmount,
    this.quantity,
    this.refSeqNo,
    this.rejectReasonId,
    this.remark,
    this.salesCartItemOid,
    this.salesOrderItemOid,
    this.salesOrderSetItemBos,
    this.salesPersonId,
    this.salesPersonName,
    this.seqNo,
    this.shippingPointId,
    this.supplySourceId,
    this.unit,
    this.unitPrice,
    this.userIncentiveId,
    this.userIncentiveName,
    this.refClmId,
  });

  SalesOrderItem.fromJson(Map<String, dynamic> json) {
    articleNo = json['articleNo'];
    batch = json['batch'];
    blockCodeId = json['blockCodeId'];
    deliverySite = json['deliverySite'];
    description = json['description'];
    downPaymentDateTime = DateTimeUtil.toDateTime(json['downPaymentDateTime']);
    installCheckListId = json['installCheckListId'];
    isBlockPurchase = json['isBlockPurchase'];
    isDeliveryFee = json['isDeliveryFee'];
    isDownPayment = json['isDownPayment'];
    isLotRequired = json['isLotRequired'];
    isMainInstall = json['isMainInstall'];
    isMainProduct = json['isMainProduct'];
    isPremium = json['isPremium'];
    isPriceRequired = json['isPriceRequired'];
    isQtyRequired = json['isQtyRequired'];
    isReserveDC = json['isReserveDC'];
    isSalesSet = json['isSalesSet'];
    isSpecialDTS = json['isSpecialDTS'];
    isSpecialOrder = json['isSpecialOrder'];
    itemUPC = json['itemUPC'];
    lastUpdateUser = json['lastUpdateUser'];
    mainUPC = json['mainUPC'];
    mc9 = json['mc9'];
    netItemAmount = json['netItemAmount'];
    quantity = json['quantity'];
    refSeqNo = json['refSeqNo'];
    rejectReasonId = json['rejectReasonId'];
    remark = json['remark'];
    salesCartItemOid = json['salesCartItemOid'];
    salesOrderItemOid = json['salesOrderItemOid'];
    if (json['salesOrderSetItemBos'] != null) {
      salesOrderSetItemBos = new List<SalesOrderSetItem>();
      json['salesOrderSetItemBos'].forEach((v) {
        salesOrderSetItemBos.add(new SalesOrderSetItem.fromJson(v));
      });
    }
    salesPersonId = json['salesPersonId'];
    salesPersonName = json['salesPersonName'];
    seqNo = json['seqNo'];
    shippingPointId = json['shippingPointId'];
    supplySourceId = json['supplySourceId'];
    unit = json['unit'];
    unitPrice = json['unitPrice'];
    userIncentiveId = json['userIncentiveId'];
    userIncentiveName = json['userIncentiveName'];
    refClmId = json['refClmId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleNo'] = this.articleNo;
    data['batch'] = this.batch;
    data['blockCodeId'] = this.blockCodeId;
    data['deliverySite'] = this.deliverySite;
    data['description'] = this.description;
    data['downPaymentDateTime'] = this.downPaymentDateTime?.toIso8601String();
    data['installCheckListId'] = this.installCheckListId;
    data['isBlockPurchase'] = this.isBlockPurchase;
    data['isDeliveryFee'] = this.isDeliveryFee;
    data['isDownPayment'] = this.isDownPayment;
    data['isLotRequired'] = this.isLotRequired;
    data['isMainInstall'] = this.isMainInstall;
    data['isMainProduct'] = this.isMainProduct;
    data['isPremium'] = this.isPremium;
    data['isPriceRequired'] = this.isPriceRequired;
    data['isQtyRequired'] = this.isQtyRequired;
    data['isReserveDC'] = this.isReserveDC;
    data['isSalesSet'] = this.isSalesSet;
    data['isSpecialDTS'] = this.isSpecialDTS;
    data['isSpecialOrder'] = this.isSpecialOrder;
    data['itemUPC'] = this.itemUPC;
    data['lastUpdateUser'] = this.lastUpdateUser;
    data['mainUPC'] = this.mainUPC;
    data['mc9'] = this.mc9;
    data['netItemAmount'] = this.netItemAmount;
    data['quantity'] = this.quantity;
    data['refSeqNo'] = this.refSeqNo;
    data['rejectReasonId'] = this.rejectReasonId;
    data['remark'] = this.remark;
    data['salesCartItemOid'] = this.salesCartItemOid;
    data['salesOrderItemOid'] = this.salesOrderItemOid;
    if (this.salesOrderSetItemBos != null) {
      data['salesOrderSetItemBos'] = this.salesOrderSetItemBos.map((v) => v.toJson()).toList();
    }
    data['salesPersonId'] = this.salesPersonId;
    data['salesPersonName'] = this.salesPersonName;
    data['seqNo'] = this.seqNo;
    data['shippingPointId'] = this.shippingPointId;
    data['supplySourceId'] = this.supplySourceId;
    data['unit'] = this.unit;
    data['unitPrice'] = this.unitPrice;
    data['userIncentiveId'] = this.userIncentiveId;
    data['userIncentiveName'] = this.userIncentiveName;
    data['refClmId'] = this.refClmId;
    return data;
  }
}

class InstallJobType {
  DateTime createDateTime;
  String description;
  String jobTypeId;
  DateTime lastPublishedDateTime;
  String referencePublishId;
  String status;

  InstallJobType({this.createDateTime, this.description, this.jobTypeId, this.lastPublishedDateTime, this.referencePublishId, this.status});

  InstallJobType.fromJson(Map<String, dynamic> json) {
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    description = json['description'];
    jobTypeId = json['jobTypeId'];
    lastPublishedDateTime = DateTimeUtil.toDateTime(json['lastPublishedDateTime']);
    referencePublishId = json['referencePublishId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['description'] = this.description;
    data['jobTypeId'] = this.jobTypeId;
    data['lastPublishedDateTime'] = this.lastPublishedDateTime?.toIso8601String();
    data['referencePublishId'] = this.referencePublishId;
    data['status'] = this.status;
    return data;
  }
}

class SimPayHirepurchaseBo {
  String articleDesc;
  String couponNo;
  DateTime createDateTime;
  String createUser;
  String creditCardNo;
  String creditCardType;
  num dscntAmt;
  String dscntCondTypId;
  num dscntPerUnit;
  String dscntTypDsc;
  num dscntVal;
  String groupId;
  DateTime lastUpdateDate;
  String lastUpdateUser;
  String mailId;
  num month;
  String optionId;
  num percentDiscount;
  String promotionHierarchyLevel;
  String remark;
  num salesCartOid;
  String tenderId;
  String tenderNo;

  SimPayHirepurchaseBo({this.articleDesc, this.couponNo, this.createDateTime, this.createUser, this.creditCardNo, this.creditCardType, this.dscntAmt, this.dscntCondTypId, this.dscntPerUnit, this.dscntTypDsc, this.dscntVal, this.groupId, this.lastUpdateDate, this.lastUpdateUser, this.mailId, this.month, this.optionId, this.percentDiscount, this.promotionHierarchyLevel, this.remark, this.salesCartOid, this.tenderId, this.tenderNo});

  SimPayHirepurchaseBo.fromJson(Map<String, dynamic> json) {
    articleDesc = json['articleDesc'];
    couponNo = json['couponNo'];
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUser = json['createUser'];
    creditCardNo = json['creditCardNo'];
    creditCardType = json['creditCardType'];
    dscntAmt = json['dscntAmt'];
    dscntCondTypId = json['dscntCondTypId'];
    dscntPerUnit = json['dscntPerUnit'];
    dscntTypDsc = json['dscntTypDsc'];
    dscntVal = json['dscntVal'];
    groupId = json['groupId'];
    lastUpdateDate = DateTimeUtil.toDateTime(json['lastUpdateDate']);
    lastUpdateUser = json['lastUpdateUser'];
    mailId = json['mailId'];
    month = json['month'];
    optionId = json['optionId'];
    percentDiscount = json['percentDiscount'];
    promotionHierarchyLevel = json['promotionHierarchyLevel'];
    remark = json['remark'];
    salesCartOid = json['salesCartOid'];
    tenderId = json['tenderId'];
    tenderNo = json['tenderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleDesc'] = this.articleDesc;
    data['couponNo'] = this.couponNo;
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUser'] = this.createUser;
    data['creditCardNo'] = this.creditCardNo;
    data['creditCardType'] = this.creditCardType;
    data['dscntAmt'] = this.dscntAmt;
    data['dscntCondTypId'] = this.dscntCondTypId;
    data['dscntPerUnit'] = this.dscntPerUnit;
    data['dscntTypDsc'] = this.dscntTypDsc;
    data['dscntVal'] = this.dscntVal;
    data['groupId'] = this.groupId;
    data['lastUpdateDate'] = this.lastUpdateDate?.toIso8601String();
    data['lastUpdateUser'] = this.lastUpdateUser;
    data['mailId'] = this.mailId;
    data['month'] = this.month;
    data['optionId'] = this.optionId;
    data['percentDiscount'] = this.percentDiscount;
    data['promotionHierarchyLevel'] = this.promotionHierarchyLevel;
    data['remark'] = this.remark;
    data['salesCartOid'] = this.salesCartOid;
    data['tenderId'] = this.tenderId;
    data['tenderNo'] = this.tenderNo;
    return data;
  }
}

class SimPayMemberDiscountBo {
  String cardNo;
  bool isDiscount;
  bool isReward;
  String memberCardTypeId;
  String name;
  num salesCartOid;

  SimPayMemberDiscountBo({this.cardNo, this.isDiscount, this.isReward, this.memberCardTypeId, this.name, this.salesCartOid});

  SimPayMemberDiscountBo.fromJson(Map<String, dynamic> json) {
    cardNo = json['cardNo'];
    isDiscount = json['isDiscount'];
    isReward = json['isReward'];
    memberCardTypeId = json['memberCardTypeId'];
    name = json['name'];
    salesCartOid = json['salesCartOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNo'] = this.cardNo;
    data['isDiscount'] = this.isDiscount;
    data['isReward'] = this.isReward;
    data['memberCardTypeId'] = this.memberCardTypeId;
    data['name'] = this.name;
    data['salesCartOid'] = this.salesCartOid;
    return data;
  }
}

class SimPayPremiumBo {
  String articleId;
  String articleName;
  DateTime createDateTime;
  String createUser;
  DateTime lastUpdateDate;
  String lastUpdateUser;
  num premiumQty;
  String promotionId;
  String promotionName;
  num salesCartOid;
  String unit;

  SimPayPremiumBo({this.articleId, this.articleName, this.createDateTime, this.createUser, this.lastUpdateDate, this.lastUpdateUser, this.premiumQty, this.promotionId, this.promotionName, this.salesCartOid, this.unit});

  SimPayPremiumBo.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    articleName = json['articleName'];
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUser = json['createUser'];
    lastUpdateDate = DateTimeUtil.toDateTime(json['lastUpdateDate']);
    lastUpdateUser = json['lastUpdateUser'];
    premiumQty = json['premiumQty'];
    promotionId = json['promotionId'];
    promotionName = json['promotionName'];
    salesCartOid = json['salesCartOid'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleId'] = this.articleId;
    data['articleName'] = this.articleName;
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUser'] = this.createUser;
    data['lastUpdateDate'] = this.lastUpdateDate?.toIso8601String();
    data['lastUpdateUser'] = this.lastUpdateUser;
    data['premiumQty'] = this.premiumQty;
    data['promotionId'] = this.promotionId;
    data['promotionName'] = this.promotionName;
    data['salesCartOid'] = this.salesCartOid;
    data['unit'] = this.unit;
    return data;
  }
}

class SimPayPromoitonBo {
  String articleNo;
  String couponNo;
  num couponQty;
  DateTime createDateTime;
  String createUser;
  num discountAmount;
  DiscountConditionType discountConditionType;
  DateTime lastUpdateDate;
  String lastUpdateUser;
  String promotionId;
  num qty;
  num salesCartItemOid;
  num salesOrderItemOid;
  String unit;
  String vendorId;
  String vendorName;

  SimPayPromoitonBo({
    this.articleNo,
    this.couponNo,
    this.couponQty,
    this.createDateTime,
    this.createUser,
    this.discountAmount,
    this.discountConditionType,
    this.lastUpdateDate,
    this.lastUpdateUser,
    this.promotionId,
    this.qty,
    this.salesCartItemOid = 0,
    this.salesOrderItemOid = 0,
    this.unit,
    this.vendorId,
    this.vendorName,
  });

  SimPayPromoitonBo.fromJson(Map<String, dynamic> json) {
    articleNo = json['articleNo'];
    couponNo = json['couponNo'];
    couponQty = json['couponQty'];
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUser = json['createUser'];
    discountAmount = json['discountAmount'];
    discountConditionType = json['discountConditionType'] != null ? new DiscountConditionType.fromJson(json['discountConditionType']) : null;
    lastUpdateDate = DateTimeUtil.toDateTime(json['lastUpdateDate']);
    lastUpdateUser = json['lastUpdateUser'];
    promotionId = json['promotionId'];
    qty = json['qty'];
    salesCartItemOid = json['salesCartItemOid'];
    salesOrderItemOid = json['salesOrderItemOid'];
    unit = json['unit'];
    vendorId = json['vendorId'];
    vendorName = json['vendorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleNo'] = this.articleNo;
    data['couponNo'] = this.couponNo;
    data['couponQty'] = this.couponQty;
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUser'] = this.createUser;
    data['discountAmount'] = this.discountAmount;
    if (this.discountConditionType != null) {
      data['discountConditionType'] = this.discountConditionType.toJson();
    }
    data['lastUpdateDate'] = this.lastUpdateDate?.toIso8601String();
    data['lastUpdateUser'] = this.lastUpdateUser;
    data['promotionId'] = this.promotionId;
    data['qty'] = this.qty;
    data['salesCartItemOid'] = this.salesCartItemOid;
    data['salesOrderItemOid'] = this.salesOrderItemOid;
    data['unit'] = this.unit;
    data['vendorId'] = this.vendorId;
    data['vendorName'] = this.vendorName;
    return data;
  }
}

class SimPayTenderBo {
  String cardDummy;
  DateTime createDateTime;
  String createUser;
  String creditCardNo;
  bool isHirepurchase;
  bool isPromotion;
  DateTime lastUpdateDate;
  String lastUpdateUser;
  String promotionId;
  num salesCartOid;
  String tenderDesc;
  String tenderId;
  String tenderName;
  String tenderNo;
  num tenderValue;

  // For Map CalPro
  int seqNo;

  SimPayTenderBo({this.cardDummy, this.createDateTime, this.createUser, this.creditCardNo, this.isHirepurchase, this.isPromotion, this.lastUpdateDate, this.lastUpdateUser, this.promotionId, this.salesCartOid, this.tenderDesc, this.tenderId, this.tenderName, this.tenderNo, this.tenderValue});

  SimPayTenderBo.fromJson(Map<String, dynamic> json) {
    cardDummy = json['cardDummy'];
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUser = json['createUser'];
    creditCardNo = json['creditCardNo'];
    isHirepurchase = json['isHirepurchase'];
    isPromotion = json['isPromotion'];
    lastUpdateDate = DateTimeUtil.toDateTime(json['lastUpdateDate']);
    lastUpdateUser = json['lastUpdateUser'];
    promotionId = json['promotionId'];
    salesCartOid = json['salesCartOid'];
    tenderDesc = json['tenderDesc'];
    tenderId = json['tenderId'];
    tenderName = json['tenderName'];
    tenderNo = json['tenderNo'];
    tenderValue = json['tenderValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardDummy'] = this.cardDummy;
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUser'] = this.createUser;
    data['creditCardNo'] = this.creditCardNo;
    data['isHirepurchase'] = this.isHirepurchase;
    data['isPromotion'] = this.isPromotion;
    data['lastUpdateDate'] = this.lastUpdateDate?.toIso8601String();
    data['lastUpdateUser'] = this.lastUpdateUser;
    data['promotionId'] = this.promotionId;
    data['salesCartOid'] = this.salesCartOid;
    data['tenderDesc'] = this.tenderDesc;
    data['tenderId'] = this.tenderId;
    data['tenderName'] = this.tenderName;
    data['tenderNo'] = this.tenderNo;
    data['tenderValue'] = this.tenderValue;
    return data;
  }
}

class SimPayBurnpointBo {
  num burnAmount;
  String burnpointDesc;
  String burnpointTypeNo;
  DateTime createDateTime;
  String createUser;
  num discountRate;
  DateTime lastUpdateDate;
  String lastUpdateUser;
  num pointRate;
  String promotionId;
  num salesCartOid;
  num seqNo;

  SimPayBurnpointBo({this.burnAmount, this.burnpointDesc, this.burnpointTypeNo, this.createDateTime, this.createUser, this.discountRate, this.lastUpdateDate, this.lastUpdateUser, this.pointRate, this.promotionId, this.salesCartOid, this.seqNo});

  SimPayBurnpointBo.fromJson(Map<String, dynamic> json) {
    burnAmount = json['burnAmount'];
    burnpointDesc = json['burnpointDesc'];
    burnpointTypeNo = json['burnpointTypeNo'];
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUser = json['createUser'];
    discountRate = json['discountRate'];
    lastUpdateDate = DateTimeUtil.toDateTime(json['lastUpdateDate']);
    lastUpdateUser = json['lastUpdateUser'];
    pointRate = json['pointRate'];
    promotionId = json['promotionId'];
    salesCartOid = json['salesCartOid'];
    seqNo = json['seqNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['burnAmount'] = this.burnAmount;
    data['burnpointDesc'] = this.burnpointDesc;
    data['burnpointTypeNo'] = this.burnpointTypeNo;
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUser'] = this.createUser;
    data['discountRate'] = this.discountRate;
    data['lastUpdateDate'] = this.lastUpdateDate?.toIso8601String();
    data['lastUpdateUser'] = this.lastUpdateUser;
    data['pointRate'] = this.pointRate;
    data['promotionId'] = this.promotionId;
    data['salesCartOid'] = this.salesCartOid;
    data['seqNo'] = this.seqNo;
    return data;
  }
}

class SimPayDiscountBo {
  String articleId;
  DateTime createDateTime;
  String createUser;
  num discountAmount;
  DiscountConditionType discountConditionType;
  num discountPerUnit;
  num discountPercent;
  String discountType;
  DateTime lastUpdateDate;
  String lastUpdateUser;
  num salesCartItemOid;
  num salesCartOid;
  num salesOrderItemOid;
  num simulatePaymentDiscountOid;

  SimPayDiscountBo({this.articleId, this.createDateTime, this.createUser, this.discountAmount, this.discountConditionType, this.discountPerUnit, this.discountPercent, this.discountType, this.lastUpdateDate, this.lastUpdateUser, this.salesCartItemOid, this.salesCartOid, this.salesOrderItemOid, this.simulatePaymentDiscountOid});

  SimPayDiscountBo.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    createDateTime = DateTimeUtil.toDateTime(json['createDateTime']);
    createUser = json['createUser'];
    discountAmount = json['discountAmount'];
    discountConditionType = json['discountConditionType'] != null ? new DiscountConditionType.fromJson(json['discountConditionType']) : null;
    discountPerUnit = json['discountPerUnit'];
    discountPercent = json['discountPercent'];
    discountType = json['discountType'];
    lastUpdateDate = DateTimeUtil.toDateTime(json['lastUpdateDate']);
    lastUpdateUser = json['lastUpdateUser'];
    salesCartItemOid = json['salesCartItemOid'];
    salesCartOid = json['salesCartOid'];
    salesOrderItemOid = json['salesOrderItemOid'];
    simulatePaymentDiscountOid = json['simulatePaymentDiscountOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleId'] = this.articleId;
    data['createDateTime'] = this.createDateTime?.toIso8601String();
    data['createUser'] = this.createUser;
    data['discountAmount'] = this.discountAmount;
    if (this.discountConditionType != null) {
      data['discountConditionType'] = this.discountConditionType.toJson();
    }
    data['discountPerUnit'] = this.discountPerUnit;
    data['discountPercent'] = this.discountPercent;
    data['discountType'] = this.discountType;
    data['lastUpdateDate'] = this.lastUpdateDate?.toIso8601String();
    data['lastUpdateUser'] = this.lastUpdateUser;
    data['salesCartItemOid'] = this.salesCartItemOid;
    data['salesCartOid'] = this.salesCartOid;
    data['salesOrderItemOid'] = this.salesOrderItemOid;
    data['simulatePaymentDiscountOid'] = this.simulatePaymentDiscountOid;
    return data;
  }
}

class SalesOrderSetItem {
  String articleId;
  String description;
  String mainUPC;
  String mc9;
  num quantity;
  num quantityInSet;
  String sapSeqNo;
  bool scannedItem;
  String unit;

  SalesOrderSetItem({this.articleId, this.description, this.mainUPC, this.mc9, this.quantity, this.quantityInSet, this.sapSeqNo, this.scannedItem, this.unit});

  SalesOrderSetItem.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    description = json['description'];
    mainUPC = json['mainUPC'];
    mc9 = json['mc9'];
    quantity = json['quantity'];
    quantityInSet = json['quantityInSet'];
    sapSeqNo = json['sapSeqNo'];
    scannedItem = json['scannedItem'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleId'] = this.articleId;
    data['description'] = this.description;
    data['mainUPC'] = this.mainUPC;
    data['mc9'] = this.mc9;
    data['quantity'] = this.quantity;
    data['quantityInSet'] = this.quantityInSet;
    data['sapSeqNo'] = this.sapSeqNo;
    data['scannedItem'] = this.scannedItem;
    data['unit'] = this.unit;
    return data;
  }
}

class DiscountConditionType {
  String description;
  String discountConditionTypeId;
  String discountType;
  bool isPercentDiscount = false;

  DiscountConditionType({this.description, this.discountConditionTypeId, this.discountType, this.isPercentDiscount});

  DiscountConditionType.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    discountConditionTypeId = json['discountConditionTypeId'];
    discountType = json['discountType'].toString();
    isPercentDiscount = json['isPercentDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['discountConditionTypeId'] = this.discountConditionTypeId;
//    data['discountType'] = this.discountType;
    data['isPercentDiscount'] = this.isPercentDiscount;
    return data;
  }
}

class CustomerPartners {
  Customer partnerCustomer;
  String partnerFunctionTypeId;
  bool isDefaultShipTo;

  CustomerPartners({this.partnerCustomer, this.partnerFunctionTypeId, this.isDefaultShipTo});

  CustomerPartners.fromJson(Map<String, dynamic> json) {
    partnerCustomer = json['partnerCustomer'] != null ? new Customer.fromJson(json['partnerCustomer']) : null;
    partnerFunctionTypeId = json['partnerFunctionTypeId'];
    isDefaultShipTo = json['isDefaultShipTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.partnerCustomer != null) {
      data['partnerCustomer'] = this.partnerCustomer.toJson();
    }
    data['partnerFunctionTypeId'] = this.partnerFunctionTypeId;
    data['isDefaultShipTo'] = this.isDefaultShipTo;
    return data;
  }
}
