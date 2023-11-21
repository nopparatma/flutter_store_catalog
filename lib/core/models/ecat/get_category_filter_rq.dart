class GetCategoryFilterRq {
  String mCHId;

  GetCategoryFilterRq({this.mCHId});

  GetCategoryFilterRq.fromJson(Map<String, dynamic> json) {
    mCHId = json['MCHId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCHId'] = this.mCHId;
    return data;
  }
}
