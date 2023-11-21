class GetDeliveryFeeRq {
  String appChannel;
  String district;
  String province;
  num purchaseAmount;
  List<ReservItem> reservItems;
  String storeId;
  String subDistrict;
  String cardNo;
  String cardType;

  GetDeliveryFeeRq({
    this.appChannel,
    this.district,
    this.province,
    this.purchaseAmount,
    this.reservItems,
    this.storeId,
    this.subDistrict,
    this.cardNo,
    this.cardType,
  });

  GetDeliveryFeeRq.fromJson(Map<String, dynamic> json) {
    appChannel = json['appChannel'];
    district = json['district'];
    province = json['province'];
    purchaseAmount = json['purchaseAmount'];
    if (json['reservItems'] != null) {
      reservItems = new List<ReservItem>();
      json['reservItems'].forEach((v) {
        reservItems.add(new ReservItem.fromJson(v));
      });
    }
    storeId = json['storeId'];
    subDistrict = json['subDistrict'];
    cardNo = json['cardNo'];
    cardType = json['cardType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appChannel'] = this.appChannel;
    data['district'] = this.district;
    data['province'] = this.province;
    data['purchaseAmount'] = this.purchaseAmount;
    if (this.reservItems != null) {
      data['reservItems'] = this.reservItems.map((v) => v.toJson()).toList();
    }
    data['storeId'] = this.storeId;
    data['subDistrict'] = this.subDistrict;
    data['cardNo'] = this.cardNo;
    data['cardType'] = this.cardType;
    return data;
  }
}

class ReservItem {
  String patKey;
  String queueStyle;
  String servNo;
  String shippoint;

  ReservItem({this.patKey, this.queueStyle, this.servNo, this.shippoint});

  ReservItem.fromJson(Map<String, dynamic> json) {
    patKey = json['patKey'];
    queueStyle = json['queueStyle'];
    servNo = json['servNo'];
    shippoint = json['shippoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patKey'] = this.patKey;
    data['queueStyle'] = this.queueStyle;
    data['servNo'] = this.servNo;
    data['shippoint'] = this.shippoint;
    return data;
  }
}
