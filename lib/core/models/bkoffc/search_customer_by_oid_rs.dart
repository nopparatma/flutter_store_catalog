import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';

import 'sale_cart.dart';

class SearchCustomerByOidRs extends BaseBackOfficeWebApiRs {
  Customer customer;
  num rowCount;

  SearchCustomerByOidRs({this.customer, this.rowCount});

  SearchCustomerByOidRs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    customer = json['customer'] != null ? new Customer.fromJson(json['customer']) : null;
    rowCount = json['rowCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    data['rowCount'] = this.rowCount;
    return data;
  }
}

// class Customer {
//   num customerOid;
//   String sapId;
//   String title;
//   String type;
//   String firstName;
//   String lastName;
//   String village;
//   String soi;
//   String street;
//   String subDistrict;
//   String district;
//   String province;
//   String zipCode;
//   String phoneNumber1;
//   String customerGroup;
//   String language;
//   String partnerFunctionTypeId;
//   String building;
//   bool vatClassification;
//   String number;
//   List<CustomerPartners> customerPartners;
//   TransportData transportData;

//   Customer({this.customerOid, this.sapId, this.title, this.type, this.firstName, this.lastName, this.village, this.soi, this.street, this.subDistrict, this.district, this.province, this.zipCode, this.phoneNumber1, this.customerGroup, this.language, this.partnerFunctionTypeId, this.building, this.vatClassification, this.customerPartners, this.transportData, this.number});

//   Customer.fromJson(Map<String, dynamic> json) {
//     customerOid = json['customerOid'];
//     sapId = json['sapId'];
//     title = json['title'];
//     type = json['type'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     village = json['village'];
//     soi = json['soi'];
//     street = json['street'];
//     subDistrict = json['subDistrict'];
//     district = json['district'];
//     province = json['province'];
//     zipCode = json['zipCode'];
//     phoneNumber1 = json['phoneNumber1'];
//     customerGroup = json['customerGroup'];
//     language = json['language'];
//     partnerFunctionTypeId = json['partnerFunctionTypeId'];
//     building = json['building'];
//     number = json['number'];
//     vatClassification = json['vatClassification'];
//     if (json['customerPartners'] != null) {
//       customerPartners = new List<CustomerPartners>();
//       json['customerPartners'].forEach((v) {
//         customerPartners.add(new CustomerPartners.fromJson(v));
//       });
//     }
//     transportData = json['transportData'] != null ? new TransportData.fromJson(json['transportData']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['customerOid'] = this.customerOid;
//     data['sapId'] = this.sapId;
//     data['title'] = this.title;
//     data['type'] = this.type;
//     data['firstName'] = this.firstName;
//     data['lastName'] = this.lastName;
//     data['village'] = this.village;
//     data['soi'] = this.soi;
//     data['street'] = this.street;
//     data['subDistrict'] = this.subDistrict;
//     data['district'] = this.district;
//     data['province'] = this.province;
//     data['zipCode'] = this.zipCode;
//     data['phoneNumber1'] = this.phoneNumber1;
//     data['customerGroup'] = this.customerGroup;
//     data['language'] = this.language;
//     data['partnerFunctionTypeId'] = this.partnerFunctionTypeId;
//     data['building'] = this.building;
//     data['number'] = this.number;
//     data['vatClassification'] = this.vatClassification;
//     if (this.customerPartners != null) {
//       data['customerPartners'] = this.customerPartners.map((v) => v.toJson()).toList();
//     }
//     if (this.transportData != null) {
//       data['transportData'] = this.transportData.toJson();
//     }
//     return data;
//   }
// }

// class CustomerPartners {
//   Customer partnerCustomer;
//   String partnerFunctionTypeId;
//   bool isDefaultShipTo;

//   CustomerPartners({this.partnerCustomer, this.partnerFunctionTypeId, this.isDefaultShipTo});

//   CustomerPartners.fromJson(Map<String, dynamic> json) {
//     partnerCustomer = json['partnerCustomer'] != null ? new Customer.fromJson(json['partnerCustomer']) : null;
//     partnerFunctionTypeId = json['partnerFunctionTypeId'];
//     isDefaultShipTo = json['isDefaultShipTo'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.partnerCustomer != null) {
//       data['partnerCustomer'] = this.partnerCustomer.toJson();
//     }
//     data['partnerFunctionTypeId'] = this.partnerFunctionTypeId;
//     data['isDefaultShipTo'] = this.isDefaultShipTo;
//     return data;
//   }
// }

// class PartnerCustomer {
//   num customerOid;
//   String sapId;
//   String title;
//   String type;
//   String firstName;
//   String lastName;
//   String village;
//   String soi;
//   String street;
//   String subDistrict;
//   String district;
//   String province;
//   String zipCode;
//   String phoneNumber1;
//   String customerGroup;
//   String language;
//   String partnerFunctionTypeId;
//   String building;
//   bool vatClassification;
//   TransportData transportData;
//   String floor;
//   String moo;
//   String number;
//   String unit;
//   String placeId;

//   PartnerCustomer(
//       {this.customerOid,
//       this.sapId,
//       this.title,
//       this.type,
//       this.firstName,
//       this.lastName,
//       this.village,
//       this.soi,
//       this.street,
//       this.subDistrict,
//       this.district,
//       this.province,
//       this.zipCode,
//       this.phoneNumber1,
//       this.customerGroup,
//       this.language,
//       this.partnerFunctionTypeId,
//       this.building,
//       this.vatClassification,
//       this.transportData,
//       this.floor,
//       this.moo,
//       this.number,
//       this.unit,
//       this.placeId});

//   PartnerCustomer.fromJson(Map<String, dynamic> json) {
//     customerOid = json['customerOid'];
//     sapId = json['sapId'];
//     title = json['title'];
//     type = json['type'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     village = json['village'];
//     soi = json['soi'];
//     street = json['street'];
//     subDistrict = json['subDistrict'];
//     district = json['district'];
//     province = json['province'];
//     zipCode = json['zipCode'];
//     phoneNumber1 = json['phoneNumber1'];
//     customerGroup = json['customerGroup'];
//     language = json['language'];
//     partnerFunctionTypeId = json['partnerFunctionTypeId'];
//     building = json['building'];
//     vatClassification = json['vatClassification'];
//     transportData = json['transportData'] != null
//         ? new TransportData.fromJson(json['transportData'])
//         : null;
//     floor = json['floor'];
//     moo = json['moo'];
//     number = json['number'];
//     unit = json['unit'];
//     placeId = json['placeId'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['customerOid'] = this.customerOid;
//     data['sapId'] = this.sapId;
//     data['title'] = this.title;
//     data['type'] = this.type;
//     data['firstName'] = this.firstName;
//     data['lastName'] = this.lastName;
//     data['village'] = this.village;
//     data['soi'] = this.soi;
//     data['street'] = this.street;
//     data['subDistrict'] = this.subDistrict;
//     data['district'] = this.district;
//     data['province'] = this.province;
//     data['zipCode'] = this.zipCode;
//     data['phoneNumber1'] = this.phoneNumber1;
//     data['customerGroup'] = this.customerGroup;
//     data['language'] = this.language;
//     data['partnerFunctionTypeId'] = this.partnerFunctionTypeId;
//     data['building'] = this.building;
//     data['vatClassification'] = this.vatClassification;
//     if (this.transportData != null) {
//       data['transportData'] = this.transportData.toJson();
//     }
//     data['floor'] = this.floor;
//     data['moo'] = this.moo;
//     data['number'] = this.number;
//     data['unit'] = this.unit;
//     data['placeId'] = this.placeId;
//     return data;
//   }
// }

// class TransportData {
//   num tranDataOid;
//   bool isLiftAvailability;
//   String tmsLatitude;
//   String tmsLongtitude;
//   String routeDetails;

//   TransportData({this.tranDataOid, this.isLiftAvailability, this.tmsLatitude, this.tmsLongtitude, this.routeDetails});

//   TransportData.fromJson(Map<String, dynamic> json) {
//     tranDataOid = json['tranDataOid'];
//     isLiftAvailability = json['isLiftAvailability'];
//     tmsLatitude = json['tmsLatitude'];
//     tmsLongtitude = json['tmsLongtitude'];
//     routeDetails = json['routeDetails'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['tranDataOid'] = this.tranDataOid;
//     data['isLiftAvailability'] = this.isLiftAvailability;
//     data['tmsLatitude'] = this.tmsLatitude;
//     data['tmsLongtitude'] = this.tmsLongtitude;
//     data['routeDetails'] = this.routeDetails;
//     return data;
//   }
//
