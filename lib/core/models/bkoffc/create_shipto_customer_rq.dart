
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';

class CreateShiptoCustomerRq {
  String companyCode;
  String fromStore;
  String fromUser;
  String screenName;
  Customer shipToCustomerBo;
  int soldToCustomerOid;
  String soldToSapId;
  String systemName;

  CreateShiptoCustomerRq({this.companyCode, this.fromStore, this.fromUser, this.screenName, this.shipToCustomerBo, this.soldToCustomerOid, this.soldToSapId, this.systemName});

  CreateShiptoCustomerRq.fromJson(Map<String, dynamic> json) {
    companyCode = json['companyCode'];
    fromStore = json['fromStore'];
    fromUser = json['fromUser'];
    screenName = json['screenName'];
    shipToCustomerBo = json['shipToCustomerBo'] != null ? new Customer.fromJson(json['shipToCustomerBo']) : null;
    soldToCustomerOid = json['soldToCustomerOid'];
    soldToSapId = json['soldToSapId'];
    systemName = json['systemName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyCode'] = this.companyCode;
    data['fromStore'] = this.fromStore;
    data['fromUser'] = this.fromUser;
    data['screenName'] = this.screenName;
    if (this.shipToCustomerBo != null) {
      data['shipToCustomerBo'] = this.shipToCustomerBo.toJson();
    }
    data['soldToCustomerOid'] = this.soldToCustomerOid;
    data['soldToSapId'] = this.soldToSapId;
    data['systemName'] = this.systemName;
    return data;
  }
}

// class ShipToCustomerBo {
//   String building;
//   String cardNumber;
//   String customerGroup;
//   int customerOid;
//   String district;
//   String email;
//   String fax;
//   String firstName;
//   String floor;
//   String language;
//   String lastName;
//   String moo;
//   String number;
//   String partnerFunctionTypeId;
//   String phoneNumber1;
//   String phoneNumber2;
//   String phoneNumber3;
//   String phoneNumber4;
//   String placeId;
//   String province;
//   String sapId;
//   String soi;
//   String street;
//   String subDistrict;
//   String title;
//   TransportData transportData;
//   String type;
//   String unit;
//   bool vatClassification;
//   String village;
//   String zipCode;

//   ShipToCustomerBo({this.building, this.cardNumber, this.customerGroup, this.customerOid, this.district, this.email, this.fax, this.firstName, this.floor, this.language, this.lastName, this.moo, this.number, this.partnerFunctionTypeId, this.phoneNumber1, this.phoneNumber2, this.phoneNumber3, this.phoneNumber4, this.placeId, this.province, this.sapId, this.soi, this.street, this.subDistrict, this.title, this.transportData, this.type, this.unit, this.vatClassification, this.village, this.zipCode});

//   ShipToCustomerBo.fromJson(Map<String, dynamic> json) {
//     building = json['building'];
//     cardNumber = json['cardNumber'];
//     customerGroup = json['customerGroup'];
//     customerOid = json['customerOid'];
//     district = json['district'];
//     email = json['email'];
//     fax = json['fax'];
//     firstName = json['firstName'];
//     floor = json['floor'];
//     language = json['language'];
//     lastName = json['lastName'];
//     moo = json['moo'];
//     number = json['number'];
//     partnerFunctionTypeId = json['partnerFunctionTypeId'];
//     phoneNumber1 = json['phoneNumber1'];
//     phoneNumber2 = json['phoneNumber2'];
//     phoneNumber3 = json['phoneNumber3'];
//     phoneNumber4 = json['phoneNumber4'];
//     placeId = json['placeId'];
//     province = json['province'];
//     sapId = json['sapId'];
//     soi = json['soi'];
//     street = json['street'];
//     subDistrict = json['subDistrict'];
//     title = json['title'];
//     transportData = json['transportData'] != null ? new TransportData.fromJson(json['transportData']) : null;
//     type = json['type'];
//     unit = json['unit'];
//     vatClassification = json['vatClassification'];
//     village = json['village'];
//     zipCode = json['zipCode'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['building'] = this.building;
//     data['cardNumber'] = this.cardNumber;
//     data['customerGroup'] = this.customerGroup;
//     data['customerOid'] = this.customerOid;
//     data['district'] = this.district;
//     data['email'] = this.email;
//     data['fax'] = this.fax;
//     data['firstName'] = this.firstName;
//     data['floor'] = this.floor;
//     data['language'] = this.language;
//     data['lastName'] = this.lastName;
//     data['moo'] = this.moo;
//     data['number'] = this.number;
//     data['partnerFunctionTypeId'] = this.partnerFunctionTypeId;
//     data['phoneNumber1'] = this.phoneNumber1;
//     data['phoneNumber2'] = this.phoneNumber2;
//     data['phoneNumber3'] = this.phoneNumber3;
//     data['phoneNumber4'] = this.phoneNumber4;
//     data['placeId'] = this.placeId;
//     data['province'] = this.province;
//     data['sapId'] = this.sapId;
//     data['soi'] = this.soi;
//     data['street'] = this.street;
//     data['subDistrict'] = this.subDistrict;
//     data['title'] = this.title;
//     if (this.transportData != null) {
//       data['transportData'] = this.transportData.toJson();
//     }
//     data['type'] = this.type;
//     data['unit'] = this.unit;
//     data['vatClassification'] = this.vatClassification;
//     data['village'] = this.village;
//     data['zipCode'] = this.zipCode;
//     return data;
//   }
// }

// class TransportData {
//   String contactPoint;
//   bool isLiftAvailability;
//   String mapLatitude;
//   String mapLocation;
//   String mapLongtitude;
//   String mapName;
//   String parkingDistance;
//   String parkingFee;
//   String parkingTime;
//   String plotMapLocation;
//   String plotMapName;
//   String plotMapPath;
//   String pointOfInterest;
//   String receipient;
//   String routeDetails;
//   String telephone;
//   String tmsLatitude;
//   String tmsLongtitude;
//   int tranDataOid;

//   TransportData({this.contactPoint, this.isLiftAvailability, this.mapLatitude, this.mapLocation, this.mapLongtitude, this.mapName, this.parkingDistance, this.parkingFee, this.parkingTime, this.plotMapLocation, this.plotMapName, this.plotMapPath, this.pointOfInterest, this.receipient, this.routeDetails, this.telephone, this.tmsLatitude, this.tmsLongtitude, this.tranDataOid});

//   TransportData.fromJson(Map<String, dynamic> json) {
//     contactPoint = json['contactPoint'];
//     isLiftAvailability = json['isLiftAvailability'];
//     mapLatitude = json['mapLatitude'];
//     mapLocation = json['mapLocation'];
//     mapLongtitude = json['mapLongtitude'];
//     mapName = json['mapName'];
//     parkingDistance = json['parkingDistance'];
//     parkingFee = json['parkingFee'];
//     parkingTime = json['parkingTime'];
//     plotMapLocation = json['plotMapLocation'];
//     plotMapName = json['plotMapName'];
//     plotMapPath = json['plotMapPath'];
//     pointOfInterest = json['pointOfInterest'];
//     receipient = json['receipient'];
//     routeDetails = json['routeDetails'];
//     telephone = json['telephone'];
//     tmsLatitude = json['tmsLatitude'];
//     tmsLongtitude = json['tmsLongtitude'];
//     tranDataOid = json['tranDataOid'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['contactPoint'] = this.contactPoint;
//     data['isLiftAvailability'] = this.isLiftAvailability;
//     data['mapLatitude'] = this.mapLatitude;
//     data['mapLocation'] = this.mapLocation;
//     data['mapLongtitude'] = this.mapLongtitude;
//     data['mapName'] = this.mapName;
//     data['parkingDistance'] = this.parkingDistance;
//     data['parkingFee'] = this.parkingFee;
//     data['parkingTime'] = this.parkingTime;
//     data['plotMapLocation'] = this.plotMapLocation;
//     data['plotMapName'] = this.plotMapName;
//     data['plotMapPath'] = this.plotMapPath;
//     data['pointOfInterest'] = this.pointOfInterest;
//     data['receipient'] = this.receipient;
//     data['routeDetails'] = this.routeDetails;
//     data['telephone'] = this.telephone;
//     data['tmsLatitude'] = this.tmsLatitude;
//     data['tmsLongtitude'] = this.tmsLongtitude;
//     data['tranDataOid'] = this.tranDataOid;
//     return data;
//   }
// }
