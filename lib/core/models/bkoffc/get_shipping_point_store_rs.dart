import 'base_bkoffc_webapi_rs.dart';

class GetShippingPointStoreRs extends BaseBackOfficeWebApiRs {
  String latitude;
  String longitude;
  List<ShippingPointList> shippingPointList;

  GetShippingPointStoreRs({this.latitude, this.longitude, this.shippingPointList});

  GetShippingPointStoreRs.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    message = json['message'];
    if (json['shippingPointlist'] != null) {
      shippingPointList = new List<ShippingPointList>();
      json['shippingPointlist'].forEach((v) {
        shippingPointList.add(new ShippingPointList.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['message'] = this.message;
    if (this.shippingPointList != null) {
      data['shippingPointlist'] = this.shippingPointList.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class ShippingPointList {
  num distance;
  String isDeliveryStore;
  String isPricingStore;
  String isSaleStore;
  String searchTerm;
  String shippingPointId;
  String shippingPointName;
  String shippingPointAddress;
  String shippingPointPhoneNo;
  String storeStatus;
  String zoneCode;
  String zoneName;

  ShippingPointList({this.distance, this.isDeliveryStore, this.isPricingStore, this.isSaleStore, this.searchTerm, this.shippingPointId, this.shippingPointName, this.shippingPointAddress, this.shippingPointPhoneNo, this.storeStatus, this.zoneCode, this.zoneName});

  ShippingPointList.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    isDeliveryStore = json['isDeliveryStore'];
    isPricingStore = json['isPricingStore'];
    isSaleStore = json['isSaleStore'];
    searchTerm = json['searchTerm'];
    shippingPointId = json['shippingPointId'];
    shippingPointName = json['shippingPointName'];
    shippingPointAddress = json['shippingPointAddress'];
    shippingPointPhoneNo = json['shippingPointPhoneNo'];
    storeStatus = json['storeStatus'];
    zoneCode = json['zoneCode'];
    zoneName = json['zoneName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['isDeliveryStore'] = this.isDeliveryStore;
    data['isPricingStore'] = this.isPricingStore;
    data['isSaleStore'] = this.isSaleStore;
    data['searchTerm'] = this.searchTerm;
    data['shippingPointId'] = this.shippingPointId;
    data['shippingPointName'] = this.shippingPointName;
    data['shippingPointAddress'] = this.shippingPointAddress;
    data['shippingPointPhoneNo'] = this.shippingPointPhoneNo;
    data['storeStatus'] = this.storeStatus;
    data['zoneCode'] = this.zoneCode;
    data['zoneName'] = this.zoneName;
    return data;
  }

  @override
  String toString() {
    return 'ShippingPointList{distance: $distance, isDeliveryStore: $isDeliveryStore, isPricingStore: $isPricingStore, isSaleStore: $isSaleStore, searchTerm: $searchTerm, shippingPointId: $shippingPointId, shippingPointName: $shippingPointName, shippingPointAddress: $shippingPointAddress, shippingPointPhoneNo: $shippingPointPhoneNo, storeStatus: $storeStatus, zoneCode: $zoneCode, zoneName: $zoneName}';
  }
}
