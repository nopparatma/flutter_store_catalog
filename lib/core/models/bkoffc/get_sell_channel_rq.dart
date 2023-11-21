class GetSellChannelRq {
  String salesChannel;
  String storeId;

  GetSellChannelRq({this.salesChannel, this.storeId});

  GetSellChannelRq.fromJson(Map<String, dynamic> json) {
    salesChannel = json['salesChannel'];
    storeId = json['storeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['salesChannel'] = this.salesChannel;
    data['storeId'] = this.storeId;
    return data;
  }
}
