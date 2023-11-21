class AddressData {
  String subDistrict;
  String district;
  String provice;
  String zipcode;
  num lat;
  num lon;
  String geoName;
  String placeId;
  String type;

  AddressData({this.subDistrict, this.district, this.provice, this.zipcode, this.lat, this.lon, this.geoName, this.placeId, this.type});

  @override
  String toString() {
    return 'AddressData{subDistrict: $subDistrict, district: $district, provice: $provice, zipcode: $zipcode, lat: $lat, lon: $lon, geoName: $geoName, placeId: $placeId, type: $type}';
  }
}
