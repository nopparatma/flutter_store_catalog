class CancelSalesCartRq {
  num collSalesOid;
  String lastUpdUser;
  num salesCartOid;
  num salesOrderOid;

  CancelSalesCartRq({this.collSalesOid, this.lastUpdUser, this.salesCartOid, this.salesOrderOid});

  CancelSalesCartRq.fromJson(Map<String, dynamic> json) {
    collSalesOid = json['collSalesOid'];
    lastUpdUser = json['lastUpdUser'];
    salesCartOid = json['salesCartOid'];
    salesOrderOid = json['salesOrderOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['collSalesOid'] = this.collSalesOid;
    data['lastUpdUser'] = this.lastUpdUser;
    data['salesCartOid'] = this.salesCartOid;
    data['salesOrderOid'] = this.salesOrderOid;
    return data;
  }
}
