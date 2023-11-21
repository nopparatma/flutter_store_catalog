class GenerateSalesCartFromCollRq {
  num collSalesOrderOid;

  GenerateSalesCartFromCollRq({this.collSalesOrderOid});

  GenerateSalesCartFromCollRq.fromJson(Map<String, dynamic> json) {
    collSalesOrderOid = json['collSalesOrderOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['collSalesOrderOid'] = this.collSalesOrderOid;
    return data;
  }
}