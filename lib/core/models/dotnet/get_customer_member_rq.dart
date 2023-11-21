class GetCustomerMemberRq {
  String custNo;
  String cardNo;

  GetCustomerMemberRq({this.custNo, this.cardNo});

  GetCustomerMemberRq.fromJson(Map<String, dynamic> json) {
    custNo = json['custNo'];
    cardNo = json['cardNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['custNo'] = this.custNo;
    data['cardNo'] = this.cardNo;
    return data;
  }
}