class InquiryTransactionRq {
  String appChannel;
  String referenceId;
  String qrCodeId;
  num amount;
  String inquiryUserId;

  InquiryTransactionRq({
    this.appChannel,
    this.referenceId,
    this.qrCodeId,
    this.amount,
    this.inquiryUserId,
  });

  InquiryTransactionRq.fromJson(Map<String, dynamic> json) {
    appChannel = json['AppChannel'];
    referenceId = json['ReferenceId'];
    qrCodeId = json['QrCodeId'];
    amount = json['Amount'];
    inquiryUserId = json['InquiryUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AppChannel'] = this.appChannel;
    data['ReferenceId'] = this.referenceId;
    data['QrCodeId'] = this.qrCodeId;
    data['Amount'] = this.amount;
    data['InquiryUserId'] = this.inquiryUserId;
    return data;
  }
}
