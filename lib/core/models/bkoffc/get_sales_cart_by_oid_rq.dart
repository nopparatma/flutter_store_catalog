class GetSalesCartByOidRq {
  num salesCartOid;

  GetSalesCartByOidRq({this.salesCartOid});

  GetSalesCartByOidRq.fromJson(Map<String, dynamic> json) {
    salesCartOid = json['salesCartOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesCartOid'] = this.salesCartOid;
    return data;
  }
}
