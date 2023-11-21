class UpdateSalesCartCustomerRq {
  String building;
  int customerOid;
  String district;
  String firstName;
  String floorNumber;
  String lastName;
  String lastUpdUser;
  String mapLat;
  String mapLong;
  String moo;
  String number;
  String province;
  String routeDetails;
  int rowVersion;
  int salesCartOid;
  String soi;
  String street;
  String subDistrict;
  String telephoneNo;
  String unit;
  String village;
  String zipCode;

  UpdateSalesCartCustomerRq({this.building, this.customerOid, this.district, this.firstName, this.floorNumber, this.lastName, this.lastUpdUser, this.mapLat, this.mapLong, this.moo, this.number, this.province, this.routeDetails, this.rowVersion, this.salesCartOid, this.soi, this.street, this.subDistrict, this.telephoneNo, this.unit, this.village, this.zipCode});

  UpdateSalesCartCustomerRq.fromJson(Map<String, dynamic> json) {
    building = json['building'];
    customerOid = json['customerOid'];
    district = json['district'];
    firstName = json['firstName'];
    floorNumber = json['floorNumber'];
    lastName = json['lastName'];
    lastUpdUser = json['lastUpdUser'];
    mapLat = json['mapLat'];
    mapLong = json['mapLong'];
    moo = json['moo'];
    number = json['number'];
    province = json['province'];
    routeDetails = json['routeDetails'];
    rowVersion = json['rowVersion'];
    salesCartOid = json['salesCartOid'];
    soi = json['soi'];
    street = json['street'];
    subDistrict = json['subDistrict'];
    telephoneNo = json['telephoneNo'];
    unit = json['unit'];
    village = json['village'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['building'] = this.building;
    data['customerOid'] = this.customerOid;
    data['district'] = this.district;
    data['firstName'] = this.firstName;
    data['floorNumber'] = this.floorNumber;
    data['lastName'] = this.lastName;
    data['lastUpdUser'] = this.lastUpdUser;
    data['mapLat'] = this.mapLat;
    data['mapLong'] = this.mapLong;
    data['moo'] = this.moo;
    data['number'] = this.number;
    data['province'] = this.province;
    data['routeDetails'] = this.routeDetails;
    data['rowVersion'] = this.rowVersion;
    data['salesCartOid'] = this.salesCartOid;
    data['soi'] = this.soi;
    data['street'] = this.street;
    data['subDistrict'] = this.subDistrict;
    data['telephoneNo'] = this.telephoneNo;
    data['unit'] = this.unit;
    data['village'] = this.village;
    data['zipCode'] = this.zipCode;
    return data;
  }
}
