class SearchCustomerRq {
  String cardNo;
  num firstRow;
  String fname;
  String lname;
  num pageSize;
  String phoneNo;
  String sapId;
  String taxid;
  String partnerTypeId;

  SearchCustomerRq({this.cardNo, this.firstRow, this.fname, this.lname, this.pageSize, this.phoneNo, this.sapId, this.taxid, this.partnerTypeId});

  SearchCustomerRq.fromJson(Map<String, dynamic> json) {
    cardNo = json['cardNo'];
    firstRow = json['firstRow'];
    fname = json['fname'];
    lname = json['lname'];
    pageSize = json['pageSize'];
    phoneNo = json['phoneNo'];
    sapId = json['sapId'];
    taxid = json['taxid'];
    partnerTypeId = json['partnerTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNo'] = this.cardNo;
    data['firstRow'] = this.firstRow;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['pageSize'] = this.pageSize;
    data['phoneNo'] = this.phoneNo;
    data['sapId'] = this.sapId;
    data['taxid'] = this.taxid;
    data['partnerTypeId'] = this.partnerTypeId;
    return data;
  }
}
