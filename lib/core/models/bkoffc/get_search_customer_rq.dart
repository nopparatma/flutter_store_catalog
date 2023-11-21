class GetSearchCustomerRq {
  String addressType;
  String cardNo;
  String cardTypeNo;
  String customerNo;
  String customerStatus;
  String email;
  String firstName;
  String idCard;
  String lastName;
  String phoneNo;

  GetSearchCustomerRq({this.addressType, this.cardNo, this.cardTypeNo, this.customerNo, this.customerStatus, this.email, this.firstName, this.idCard, this.lastName, this.phoneNo});

  GetSearchCustomerRq.fromJson(Map<String, dynamic> json) {
    addressType = json['addressType'];
    cardNo = json['cardNo'];
    cardTypeNo = json['cardTypeNo'];
    customerNo = json['customerNo'];
    customerStatus = json['customerStatus'];
    email = json['email'];
    firstName = json['firstName'];
    idCard = json['idCard'];
    lastName = json['lastName'];
    phoneNo = json['phoneNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressType'] = this.addressType;
    data['cardNo'] = this.cardNo;
    data['cardTypeNo'] = this.cardTypeNo;
    data['customerNo'] = this.customerNo;
    data['customerStatus'] = this.customerStatus;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['idCard'] = this.idCard;
    data['lastName'] = this.lastName;
    data['phoneNo'] = this.phoneNo;
    return data;
  }
}
