class CashierTrn {
  num seqNo;
  String tenderId;
  num trnAmt;
  String refInfo;
  String promotionId;
  String tenderNo;

  CashierTrn({this.promotionId, this.refInfo, this.seqNo, this.tenderId, this.tenderNo, this.trnAmt});

  CashierTrn.fromJson(Map<String, dynamic> json) {
    promotionId = json['promotionId'];
    refInfo = json['refInfo'];
    seqNo = json['seqNo'];
    tenderId = json['tenderId'];
    tenderNo = json['tenderNo'];
    trnAmt = json['trnAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotionId'] = this.promotionId;
    data['refInfo'] = this.refInfo;
    data['seqNo'] = this.seqNo;
    data['tenderId'] = this.tenderId;
    data['tenderNo'] = this.tenderNo;
    data['trnAmt'] = this.trnAmt;
    return data;
  }
}
