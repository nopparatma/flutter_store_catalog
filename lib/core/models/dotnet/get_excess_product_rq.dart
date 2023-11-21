class GetExcessProductRq {
  String mch;
  String insProductGPID;

  GetExcessProductRq({this.mch, this.insProductGPID});

  GetExcessProductRq.fromJson(Map<String, dynamic> json) {
    mch = json['MCH'];
    insProductGPID = json['InsProductGP_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCH'] = this.mch;
    data['InsProductGP_ID'] = this.insProductGPID;
    return data;
  }
}