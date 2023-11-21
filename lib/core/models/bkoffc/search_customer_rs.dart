import 'package:flutter_store_catalog/core/models/bkoffc/base_bkoffc_webapi_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';

class SearchCustomerRs extends BaseBackOfficeWebApiRs {
  List<Customer> customers;
  num rowCount;

  SearchCustomerRs({this.customers, this.rowCount});

  SearchCustomerRs.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['customers'] != null) {
      customers = new List<Customer>();
      json['customers'].forEach((v) {
        customers.add(new Customer.fromJson(v));
      });
    }
    rowCount = json['rowCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.customers != null) {
      data['customers'] = this.customers.map((v) => v.toJson()).toList();
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
//   String cardNumber;
//   String customerGroup;
//   String language;
//   bool vatClassification;
//     TransportData transportData;

//   Customer(
//       {this.customerOid,
//         this.sapId,
//         this.title,
//         this.type,
//         this.firstName,
//         this.lastName,
//         this.village,
//         this.soi,
//         this.street,
//         this.subDistrict,
//         this.district,
//         this.province,
//         this.zipCode,
//         this.phoneNumber1,
//         this.cardNumber,
//         this.customerGroup,
//         this.language,
//         this.vatClassification,
//         this.transportData});

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
//     cardNumber = json['cardNumber'];
//     customerGroup = json['customerGroup'];
//     language = json['language'];
//     vatClassification = json['vatClassification'];
//     transportData = json['transportData'] != null
//         ? new TransportData.fromJson(json['transportData'])
//         : null;
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
//     data['cardNumber'] = this.cardNumber;
//     data['customerGroup'] = this.customerGroup;
//     data['language'] = this.language;
//     data['vatClassification'] = this.vatClassification;
//     if (this.transportData != null) {
//       data['transportData'] = this.transportData.toJson();
//     }
//     return data;
//   }
// }

class TransportData {
  int tranDataOid;
  bool isLiftAvailability;

  TransportData({this.tranDataOid, this.isLiftAvailability});

  TransportData.fromJson(Map<String, dynamic> json) {
    tranDataOid = json['tranDataOid'];
    isLiftAvailability = json['isLiftAvailability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tranDataOid'] = this.tranDataOid;
    data['isLiftAvailability'] = this.isLiftAvailability;
    return data;
  }
}
