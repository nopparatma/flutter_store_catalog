class GetShippingPointStoreRq {
  String customerNo;
  String district;
  String latitude;
  String longitude;
  String province;
  String subDistrict;

  GetShippingPointStoreRq({this.customerNo, this.district, this.latitude, this.longitude, this.province, this.subDistrict});

  GetShippingPointStoreRq.fromJson(Map<String, dynamic> json) {
    customerNo = json['customerNo'];
    district = json['district'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    province = json['province'];
    subDistrict = json['subdistrict'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerNo'] = this.customerNo;
    data['district'] = this.district;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['province'] = this.province;
    data['subdistrict'] = this.subDistrict;
    return data;
  }
}
