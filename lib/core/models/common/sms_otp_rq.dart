class SendOTPRq {
  bool isNotCheckCust;
  String cardNo;
  String cardType;
  String mobileNo;
  String sMSPromID;

  SendOTPRq(
      {this.isNotCheckCust,
        this.cardNo,
        this.cardType,
        this.mobileNo,
        this.sMSPromID});

  SendOTPRq.fromJson(Map<String, dynamic> json) {
    isNotCheckCust = json['IsNotCheckCust'];
    cardNo = json['CardNo'];
    cardType = json['CardType'];
    mobileNo = json['MobileNo'];
    sMSPromID = json['SMSPromID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsNotCheckCust'] = this.isNotCheckCust;
    data['CardNo'] = this.cardNo;
    data['CardType'] = this.cardType;
    data['MobileNo'] = this.mobileNo;
    data['SMSPromID'] = this.sMSPromID;
    return data;
  }
}
