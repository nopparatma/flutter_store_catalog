class GetConfigRq {
  String key;
  String data1;
  String data2;

  GetConfigRq({this.key, this.data1, this.data2});

  GetConfigRq.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    data1 = json['Data1'];
    data2 = json['Data2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Data1'] = this.data1;
    data['Data2'] = this.data2;
    return data;
  }
}