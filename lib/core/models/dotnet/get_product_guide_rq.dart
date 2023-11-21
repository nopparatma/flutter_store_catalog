class GetProductGuideRq {
  List<String> mCHList;

  GetProductGuideRq({this.mCHList});

  GetProductGuideRq.fromJson(Map<String, dynamic> json) {
    mCHList = json['MCHList']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCHList'] = this.mCHList;
    return data;
  }
}
