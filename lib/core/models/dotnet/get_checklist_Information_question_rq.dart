class GetCheckListInformationQuestionRq {
  String mch;
  String articleID;
  int sgTrnItemOid;
  bool isCheckMapping;

  GetCheckListInformationQuestionRq({this.mch, this.articleID, this.sgTrnItemOid = 0, this.isCheckMapping});

  GetCheckListInformationQuestionRq.fromJson(Map<String, dynamic> json) {
    mch = json['MCH'];
    articleID = json['ArticleID'];
    sgTrnItemOid = json['SgTrnItemOid'];
    isCheckMapping = json['IsCheckMapping'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MCH'] = this.mch;
    data['ArticleID'] = this.articleID;
    data['SgTrnItemOid'] = this.sgTrnItemOid;
    data['IsCheckMapping'] = this.isCheckMapping;
    return data;
  }
}