class ValidateOTPRq {
  String mobileNo;
  String oTPCode;
  String refCode;
  String transID;
  String sMSPromID;

  ValidateOTPRq(
      {this.mobileNo,
        this.oTPCode,
        this.refCode,
        this.transID,
        this.sMSPromID});

  ValidateOTPRq.fromJson(Map<String, dynamic> json) {
    mobileNo = json['MobileNo'];
    oTPCode = json['OTPCode'];
    refCode = json['RefCode'];
    transID = json['TransID'];
    sMSPromID = json['SMSPromID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MobileNo'] = this.mobileNo;
    data['OTPCode'] = this.oTPCode;
    data['RefCode'] = this.refCode;
    data['TransID'] = this.transID;
    data['SMSPromID'] = this.sMSPromID;
    return data;
  }
}
