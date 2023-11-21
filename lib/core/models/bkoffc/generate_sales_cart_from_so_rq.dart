class GenerateSalesCartFromSoRq {
  num salesOrderOid;

  GenerateSalesCartFromSoRq({this.salesOrderOid});

  GenerateSalesCartFromSoRq.fromJson(Map<String, dynamic> json) {
    salesOrderOid = json['salesOrderOid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesOrderOid'] = this.salesOrderOid;
    return data;
  }
}