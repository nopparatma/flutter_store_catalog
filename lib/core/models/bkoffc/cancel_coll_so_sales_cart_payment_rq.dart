class CancelCollSOSalesCartPaymentRq {
  num collectSalesOrderOid;
  String lastUpdateUser;
  num salesCartOid;

  CancelCollSOSalesCartPaymentRq(
      {this.collectSalesOrderOid, this.lastUpdateUser, this.salesCartOid});

  CancelCollSOSalesCartPaymentRq.fromJson(Map<String, dynamic> json) {
    collectSalesOrderOid = json['collectSalesOrderOid'];
    lastUpdateUser = json['lastUpdateUser'];
    salesCartOid = json['salesCartOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['collectSalesOrderOid'] = this.collectSalesOrderOid;
    data['lastUpdateUser'] = this.lastUpdateUser;
    data['salesCartOid'] = this.salesCartOid;
    return data;
  }
}