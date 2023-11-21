part of 'create_customer_bloc.dart';

@immutable
abstract class CreateCustomerEvent {}

class CreateShiptoCustomerEvent extends CreateCustomerEvent {
  Customer soldTo;
  String systemName;
  String screenName;

  //AppSession
  String companyCode;
  String fromStore;
  String formUser;

  //CustomerBo
  String type;
  String number;
  String unit;
  String floor;
  String village;
  String moo;
  String soi;
  String street;
  String placeId;
  String subDistrict;
  String district;
  String province;
  String zipcode;
  String phoneNumber1;
  String building;

  // TransportData
  String routeDetails;
  String tmsLatitude;
  String tmsLongtitude;

  //For Get Customer
  num salesCartOid;

  CreateShiptoCustomerEvent({
    this.systemName,
    this.screenName,
    this.companyCode,
    this.fromStore,
    this.formUser,
    this.type,
    this.number,
    this.unit,
    this.floor,
    this.village,
    this.moo,
    this.soi,
    this.street,
    this.placeId,
    this.subDistrict,
    this.district,
    this.province,
    this.zipcode,
    this.phoneNumber1,
    this.building,
    this.routeDetails,
    this.tmsLatitude,
    this.tmsLongtitude,
    this.soldTo,
    this.salesCartOid,
  });

  @override
  String toString() {
    return 'CreateShiptoCustomerEvent{systemName: $systemName, screenName: $screenName, companyCode: $companyCode, fromStore: $fromStore, formUser: $formUser, type: $type, number: $number, unit: $unit, floor: $floor, village: $village, moo: $moo, soi: $soi, street: $street, placeId: $placeId, subDistrict: $subDistrict, district: $district, provice: $province, zipcode: $zipcode, phoneNumber1: $phoneNumber1, building: $building, routeDetails: $routeDetails, tmsLatitude: $tmsLatitude, tmsLongtitude: $tmsLongtitude , soldTo:$soldTo, salesCartOid:$salesCartOid}';
  }
}

class CreateSoldToCustomerEvent extends CreateCustomerEvent {
  Customer customer;

  CreateSoldToCustomerEvent({this.customer});

  @override
  String toString() {
    return 'CreateSoldToCustomerEvent{customer: $customer}';
  }
}

class CreateBillToCustomerEvent extends CreateCustomerEvent {
  Customer soldTo;
  String systemName;
  String screenName;
  String idCard;

  //AppSession
  String companyCode;
  String fromStore;
  String formUser;

  //CustomerBo
  String type;
  String titleId;
  String title;
  String firstName;
  String lastName;
  String number;
  String email;
  String unit;
  String floor;
  String village;
  String moo;
  String soi;
  String street;
  String placeId;
  String subDistrict;
  String district;
  String province;
  String zipcode;
  String phoneNumber1;
  String building;
  String branchId;
  String branchType;
  String branchDesc;

  // TransportData
  String routeDetails;
  String tmsLatitude;
  String tmsLongtitude;

  //For Get Customer
  num salesCartOid;

  CreateBillToCustomerEvent({
    this.systemName,
    this.screenName,
    this.idCard,
    this.companyCode,
    this.fromStore,
    this.formUser,
    this.type,
    this.titleId,
    this.title,
    this.firstName,
    this.lastName,
    this.number,
    this.email,
    this.unit,
    this.floor,
    this.village,
    this.moo,
    this.soi,
    this.street,
    this.placeId,
    this.subDistrict,
    this.district,
    this.province,
    this.zipcode,
    this.phoneNumber1,
    this.building,
    this.branchId,
    this.branchType,
    this.branchDesc,
    this.routeDetails,
    this.tmsLatitude,
    this.tmsLongtitude,
    this.soldTo,
    this.salesCartOid,
  });

  @override
  String toString() {
    return 'CreateBillToCustomerEvent{systemName: $systemName, screenName: $screenName, idCard: $idCard, companyCode: $companyCode, fromStore: $fromStore, formUser: $formUser, type: $type, titleId: $titleId, title: $title, firstName: $firstName, lastName: $lastName, number: $number, email: $email, unit: $unit, floor: $floor, village: $village, moo: $moo, soi: $soi, street: $street, placeId: $placeId, subDistrict: $subDistrict, district: $district, provice: $province, zipcode: $zipcode, phoneNumber1: $phoneNumber1, building: $building, branchId: $branchId, branchType: $branchType, branchDesc: $branchDesc, routeDetails: $routeDetails, tmsLatitude: $tmsLatitude, tmsLongtitude: $tmsLongtitude , soldTo:$soldTo, salesCartOid:$salesCartOid}';
  }
}
