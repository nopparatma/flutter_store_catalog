class GetStoreInfoRq {
  String storeId;

  GetStoreInfoRq({this.storeId});

  GetStoreInfoRq.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeId'] = this.storeId;
    return data;
  }
}
