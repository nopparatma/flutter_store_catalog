import 'package:flutter_store_catalog/core/models/bkoffc/base_master_data_rs.dart';

class GetSearchCustomerRs extends BaseMasterDataRs {
  List<CustomerDataList> customerDataLists;
  String numberOfRecord;

  GetSearchCustomerRs({this.customerDataLists, this.numberOfRecord});

  GetSearchCustomerRs.fromJson(Map<String, dynamic> json) {
    if (json['customerDataLists'] != null) {
      customerDataLists = new List<CustomerDataList>();
      json['customerDataLists'].forEach((v) {
        customerDataLists.add(new CustomerDataList.fromJson(v));
      });
    }
    message = json['message'];
    numberOfRecord = json['numberOfRecord'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customerDataLists != null) {
      data['customerDataLists'] = this.customerDataLists.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['numberOfRecord'] = this.numberOfRecord;
    data['status'] = this.status;
    return data;
  }
}

class CustomerDataList {
  String addressType;
  List<CardDataList> cardDataLists;
  String custNo;
  String email;
  String firstName;
  String idCard;
  String lastName;
  String phoneNo1;
  String phoneNo2;
  String phoneNo3;
  String phoneNo4;
  String subdistrict;
  String title;

  CustomerDataList({this.addressType, this.cardDataLists, this.custNo, this.email, this.firstName, this.idCard, this.lastName, this.phoneNo1, this.phoneNo2, this.phoneNo3, this.phoneNo4, this.subdistrict, this.title});

  CustomerDataList.fromJson(Map<String, dynamic> json) {
    addressType = json['addressType'];
    if (json['cardDataLists'] != null) {
      cardDataLists = new List<CardDataList>();
      json['cardDataLists'].forEach((v) {
        cardDataLists.add(new CardDataList.fromJson(v));
      });
    }
    custNo = json['custNo'];
    email = json['email'];
    firstName = json['firstName'];
    idCard = json['idCard'];
    lastName = json['lastName'];
    phoneNo1 = json['phoneNo1'];
    phoneNo2 = json['phoneNo2'];
    phoneNo3 = json['phoneNo3'];
    phoneNo4 = json['phoneNo4'];
    subdistrict = json['subdistrict'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressType'] = this.addressType;
    if (this.cardDataLists != null) {
      data['cardDataLists'] = this.cardDataLists.map((v) => v.toJson()).toList();
    }
    data['custNo'] = this.custNo;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['idCard'] = this.idCard;
    data['lastName'] = this.lastName;
    data['phoneNo1'] = this.phoneNo1;
    data['phoneNo2'] = this.phoneNo2;
    data['phoneNo3'] = this.phoneNo3;
    data['phoneNo4'] = this.phoneNo4;
    data['subdistrict'] = this.subdistrict;
    data['title'] = this.title;
    return data;
  }
}

class CardDataList {
  String cardNo;
  String cardStatus;
  String cardTypeDesc;
  String cardTypeNo;
  String custNo;

  CardDataList({this.cardNo, this.cardStatus, this.cardTypeDesc, this.cardTypeNo, this.custNo});

  CardDataList.fromJson(Map<String, dynamic> json) {
    cardNo = json['cardNo'];
    cardStatus = json['cardStatus'];
    cardTypeDesc = json['cardTypeDesc'];
    cardTypeNo = json['cardTypeNo'];
    custNo = json['custNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNo'] = this.cardNo;
    data['cardStatus'] = this.cardStatus;
    data['cardTypeDesc'] = this.cardTypeDesc;
    data['cardTypeNo'] = this.cardTypeNo;
    data['custNo'] = this.custNo;
    return data;
  }
}
